module RememberMe
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
      return unless File.directory?(dir)

      site.data["contributors"] = []

      Dir.children(dir).sort.each do |username|
        user_dir = File.join(dir, username)
        next unless File.directory?(user_dir)

        readme_path = File.join(user_dir, "README.md")
        next unless File.exist?(readme_path)

        readme = File.read(readme_path, encoding: "utf-8")
        title = readme[/^#\s+(.+)/, 1]&.strip || username
        quote = readme[/^>\s*(.+)/, 1]&.strip || ""

        posts = collect_posts(user_dir)
        pages = collect_pages(user_dir)
        last_updated = posts.map { |p| p["date"] }.reject(&:empty?).max || ""

        site.data["contributors"] << {
          "username" => username,
          "title" => title,
          "quote" => quote,
          "posts" => posts,
          "pages" => pages,
          "last_updated" => last_updated,
        }

        # Rewrite markdown links: posts/xxx.md → xxx/
        rendered_readme = rewrite_post_links(readme)

        site.pages << GeneratedPage.new(
          site,
          "contributors/#{username}",
          "index.md",
          rendered_readme,
          { "layout" => "contributor", "title" => title, "username" => username, "posts" => posts, "pages" => pages }
        )

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

    def rewrite_post_links(content)
      content.gsub(/\[([^\]]+)\]\(posts\/(.+?)\.md\)/) do
        "<a href=\"#{$2}/\">#{$1}</a>"
      end
    end

    def collect_posts(user_dir)
      posts_dir = File.join(user_dir, "posts")
      return [] unless File.directory?(posts_dir)

      Dir.children(posts_dir)
        .select { |f| f.end_with?(".md") }
        .sort.reverse
        .map do |file|
          content = File.read(File.join(posts_dir, file), encoding: "utf-8")
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
          content = File.read(path, encoding: "utf-8")
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
