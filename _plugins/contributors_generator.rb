require "find"

module RememberMe
  def self.reject_contributor_symlinks!(source)
    dir = File.join(source, "contributors")
    return unless File.symlink?(dir) || File.exist?(dir)

    if File.symlink?(dir)
      raise Jekyll::Errors::FatalException,
            "Symbolic links are not allowed under contributors/: contributors"
    end
    return unless File.directory?(dir)

    Find.find(dir) do |path|
      next unless File.symlink?(path)

      relative_path = path.delete_prefix("#{source}/")
      raise Jekyll::Errors::FatalException,
            "Symbolic links are not allowed under contributors/: #{relative_path}"
    end
  end

  Jekyll::Hooks.register :site, :after_init do |site|
    RememberMe.reject_contributor_symlinks!(site.source)
  end

  class GeneratedPage < Jekyll::Page
    def initialize(site, dir, name, content, data)
      @site = site
      @base = site.source
      @dir = dir
      @name = name
      self.process(name)
      self.content = content
      self.data = data
    end

    def render_with_liquid?
      false
    end
  end

  class Generator < Jekyll::Generator
    safe true

    def generate(site)
      dir = File.join(site.source, "contributors")
      RememberMe.reject_contributor_symlinks!(site.source)
      return unless File.directory?(dir)

      site.data["contributors"] = []

      Dir.children(dir).sort.each do |username|
        user_dir = File.join(dir, username)
        next unless File.directory?(user_dir)

        readme_path = File.join(user_dir, "README.md")
        next unless File.exist?(readme_path)

        readme = read_utf8(readme_path)
        title = readme[/^#\s+(.+)/, 1]&.strip || username
        quote = readme[/^>\s*(.+)/, 1]&.strip || ""

        posts = collect_posts(user_dir)
        pages = collect_pages(user_dir)
        about = collect_about(user_dir)
        last_updated = posts.map { |p| p["date"] }.reject(&:empty?).max || ""

        site.data["contributors"] << {
          "username" => username,
          "title" => title,
          "quote" => quote,
          "posts" => posts,
          "pages" => pages,
          "about" => !about.nil?,
          "last_updated" => last_updated,
        }

        # Rewrite markdown links: posts/xxx.md → xxx/
        rendered_readme = rewrite_post_links(readme)

        site.pages << GeneratedPage.new(
          site,
          "contributors/#{username}",
          "index.md",
          rendered_readme,
          {
            "layout" => "contributor",
            "title" => title,
            "username" => username,
            "posts" => posts,
            "pages" => pages,
            "about" => !about.nil?,
          }
        )

        if about
          site.pages << GeneratedPage.new(
            site,
            "contributors/#{username}/about",
            "index.md",
            about["content"],
            { "layout" => "post", "title" => about["title"], "username" => username }
          )
        end

        posts.each do |post|
          site.pages << GeneratedPage.new(
            site,
            "contributors/#{username}/#{post['slug']}",
            "index.md",
            post["content"],
            { "layout" => "post", "title" => post["title"], "username" => username }
          )
        end

        pages.select { |page| page["content"] }.each do |page|
          site.pages << GeneratedPage.new(
            site,
            "contributors/#{username}/pages/#{page['slug']}",
            "index.md",
            page["content"],
            { "layout" => page["layout"], "title" => page["title"], "username" => username }
          )
        end
      end

      # Remove raw .md files under contributors/ from static output
      site.static_files.reject! { |f| f.path =~ %r{contributors/.*\.md$} }
    end

    private

    def read_utf8(path)
      content = File.binread(path).force_encoding(Encoding::UTF_8)
      return content if content.valid_encoding?

      raise Jekyll::Errors::FatalException,
            "Contributor text files must be valid UTF-8: #{path}"
    end

    def rewrite_post_links(content)
      content.gsub(/(\[[^\]]+\]\()posts\/(.+?)\.md(\))/) do
        "#{$1}#{$2}/#{$3}"
      end
    end

    def collect_about(user_dir)
      path = File.join(user_dir, "about.md")
      return unless File.file?(path)

      content = read_utf8(path)
      title = content[/^#\s+(.+)/, 1]&.strip || "About"
      { "title" => title, "content" => content }
    end

    def collect_posts(user_dir)
      posts_dir = File.join(user_dir, "posts")
      return [] unless File.directory?(posts_dir)

      Dir.children(posts_dir)
        .select { |f| f.end_with?(".md") }
        .sort.reverse
        .map do |file|
          content = read_utf8(File.join(posts_dir, file))
          title = content[/^#\s+(.+)/, 1]&.strip || file.sub(/\.md$/, "")
          slug = file.sub(/\.md$/, "")
          date = slug[/^(\d{4}-\d{2}-\d{2})/, 1] || ""
          { "title" => title, "slug" => slug, "date" => date, "content" => content }
        end
    end

    def collect_pages(user_dir)
      pages_dir = File.join(user_dir, "pages")
      return [] unless File.directory?(pages_dir)

      Dir.children(pages_dir)
        .select { |f| f.end_with?(".html") || f.end_with?(".md") }
        .sort
        .map do |file|
          path = File.join(pages_dir, file)
          content = read_utf8(path)
          slug = file.sub(/\.(html|md)$/, "")

          if file.end_with?(".html")
            title = content[/<title>(.+?)<\/title>/im, 1]&.strip || slug
            { "title" => title, "slug" => slug, "path" => "pages/#{file}" }
          else
            title = content[/^#\s+(.+)/, 1]&.strip || slug
            {
              "title" => title,
              "slug" => slug,
              "path" => "pages/#{slug}/",
              "content" => content,
              "layout" => "post",
            }
          end
        end
    end
  end
end
