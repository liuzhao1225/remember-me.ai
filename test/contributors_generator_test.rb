require "fileutils"
require "minitest/autorun"
require "tmpdir"

require "jekyll"
require_relative "../_plugins/contributors_generator"

class ContributorsGeneratorTest < Minitest::Test
  def setup
    @generator = RememberMe::Generator.allocate
  end

  def test_rejects_symlinks_anywhere_under_contributors
    Dir.mktmpdir do |root|
      contributors = File.join(root, "contributors")
      user_dir = File.join(contributors, "alice")
      FileUtils.mkdir_p(user_dir)
      File.write(File.join(root, "outside.txt"), "secret")
      File.symlink("../../outside.txt", File.join(user_dir, "README.md"))

      error = assert_raises(Jekyll::Errors::FatalException) do
        RememberMe.reject_contributor_symlinks!(root)
      end
      assert_includes error.message, "contributors/alice/README.md"
    end
  end

  def test_rejects_a_symlinked_contributors_root
    Dir.mktmpdir do |root|
      target = File.join(root, "elsewhere")
      FileUtils.mkdir(target)
      File.symlink(target, File.join(root, "contributors"))

      error = assert_raises(Jekyll::Errors::FatalException) do
        RememberMe.reject_contributor_symlinks!(root)
      end
      assert_includes error.message, "contributors"
    end
  end

  def test_rejects_invalid_utf8
    Dir.mktmpdir do |root|
      path = File.join(root, "README.md")
      File.binwrite(path, "valid\xFF".b)

      assert_raises(Jekyll::Errors::FatalException) do
        @generator.send(:read_utf8, path)
      end
    end
  end

  def test_rewrites_readme_post_links_without_emitting_raw_html
    input = "[A post](posts/2026-01-01-example.md)"
    output = @generator.send(:rewrite_post_links, input)

    assert_equal "[A post](2026-01-01-example/)", output
    refute_includes output, "<a"
  end

  def test_collects_about_page
    Dir.mktmpdir do |user_dir|
      File.write(File.join(user_dir, "about.md"), "# About Alice\n\nHello.\n")

      about = @generator.send(:collect_about, user_dir)

      assert_equal "About Alice", about["title"]
      assert_includes about["content"], "Hello."
    end
  end
end

class ValidatePrWorkflowTest < Minitest::Test
  def test_renames_must_validate_both_old_and_new_paths
    workflow = File.read(File.expand_path("../.github/workflows/validate-pr.yml", __dir__))

    assert_includes workflow, ".previous_filename"
    assert_match(
      /for file in "\$\{CHANGED_FILES\[@\]\}" "\$\{PREVIOUS_FILES\[@\]\}"/,
      workflow
    )
  end
end
