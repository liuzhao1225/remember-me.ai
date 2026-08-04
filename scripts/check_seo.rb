#!/usr/bin/env ruby

require "addressable/uri"
require "cgi"
require "optparse"
require "pathname"
require "rexml/document"
require "set"

options = { site_dir: "_site" }
site_base_url = "https://liuzhao1225.github.io/remember-me.ai"
OptionParser.new do |parser|
  parser.banner = "Usage: ruby scripts/check_seo.rb [--site-dir DIR]"
  parser.on("--site-dir DIR", "Built Jekyll site directory") do |dir|
    options[:site_dir] = dir
  end
end.parse!

site_dir = Pathname(options[:site_dir]).expand_path
abort "Site directory not found: #{site_dir}" unless site_dir.directory?

def single_match(html, pattern, label, relative_path, errors)
  matches = html.scan(pattern).flatten
  if matches.size != 1
    errors << "#{relative_path}: expected exactly one #{label}, found #{matches.size}"
    return
  end

  CGI.unescape_html(matches.first.strip)
end

def expected_canonical(site_base_url, relative_path)
  public_path = if relative_path == "index.html"
                  "/"
                elsif relative_path.end_with?("/index.html")
                  "/#{relative_path.delete_suffix('index.html')}"
                else
                  "/#{relative_path}"
                end

  Addressable::URI.parse("#{site_base_url}#{public_path}").normalize.to_s
end

errors = []
sitemap_path = site_dir.join("sitemap.xml")
if sitemap_path.file?
  sitemap = REXML::Document.new(sitemap_path.read)
  sitemap_url_list = REXML::XPath.match(sitemap, "//*[local-name()='loc']").map(&:text)
  sitemap_urls = sitemap_url_list.to_set
  errors << "sitemap.xml: duplicate URLs found" if sitemap_url_list.size != sitemap_urls.size
else
  errors << "sitemap.xml: missing"
  sitemap_urls = Set.new
end

html_files = Dir.glob(site_dir.join("**/*.html")).sort
errors << "No HTML files found under #{site_dir}" if html_files.empty?

canonicals = Set.new
html_files.each do |file|
  path = Pathname(file)
  relative_path = path.relative_path_from(site_dir).to_s
  html = path.read

  title = single_match(
    html,
    %r{<title>(.*?)</title>}im,
    "title",
    relative_path,
    errors
  )
  description = single_match(
    html,
    %r{<meta\s+name="description"\s+content="([^"]*)"\s*/?>}i,
    "meta description",
    relative_path,
    errors
  )
  canonical = single_match(
    html,
    %r{<link\s+rel="canonical"\s+href="([^"]+)"\s*/?>}i,
    "canonical URL",
    relative_path,
    errors
  )
  robots = single_match(
    html,
    %r{<meta\s+name="robots"\s+content="([^"]+)"\s*/?>}i,
    "robots meta tag",
    relative_path,
    errors
  )
  og_title = single_match(
    html,
    %r{<meta\s+property="og:title"\s+content="([^"]*)"\s*/?>}i,
    "Open Graph title",
    relative_path,
    errors
  )
  og_description = single_match(
    html,
    %r{<meta\s+property="og:description"\s+content="([^"]*)"\s*/?>}i,
    "Open Graph description",
    relative_path,
    errors
  )
  og_url = single_match(
    html,
    %r{<meta\s+property="og:url"\s+content="([^"]+)"\s*/?>}i,
    "Open Graph URL",
    relative_path,
    errors
  )
  twitter_card = single_match(
    html,
    %r{<meta\s+name="twitter:card"\s+content="([^"]+)"\s*/?>}i,
    "Twitter card",
    relative_path,
    errors
  )

  errors << "#{relative_path}: title must include remember-me.ai" if title && !title.include?("remember-me.ai")
  errors << "#{relative_path}: description is empty" if description&.empty?
  if description && description.length > 160
    errors << "#{relative_path}: description exceeds 160 characters"
  end
  if canonical
    expected_url = expected_canonical(site_base_url, relative_path)
    unless canonical == expected_url
      errors << "#{relative_path}: canonical must be #{expected_url}, found #{canonical}"
    end
    errors << "#{relative_path}: canonical is duplicated" unless canonicals.add?(canonical)
    errors << "#{relative_path}: canonical is missing from sitemap.xml" unless sitemap_urls.include?(canonical)
  end
  if robots
    robots_directives = robots.downcase.split(",").map(&:strip)
    if robots_directives.include?("noindex") || !robots_directives.include?("index")
      errors << "#{relative_path}: robots meta must allow indexing"
    end
  end
  errors << "#{relative_path}: og:title does not match title" if title && og_title != title
  if description && og_description != description
    errors << "#{relative_path}: og:description does not match description"
  end
  errors << "#{relative_path}: og:url does not match canonical" if canonical && og_url != canonical
  unless %w[summary summary_large_image].include?(twitter_card)
    errors << "#{relative_path}: unsupported Twitter card type"
  end
end

extra_sitemap_urls = sitemap_urls - canonicals
unless extra_sitemap_urls.empty?
  errors << "sitemap.xml: URLs without matching HTML canonical: #{extra_sitemap_urls.to_a.sort.join(', ')}"
end

errors << "assets/favicon.svg: missing" unless site_dir.join("assets/favicon.svg").file?

%w[AGENTS.md CONTRIBUTING.md LICENSE README.md README_EN.md templates test scripts].each do |entry|
  errors << "#{entry}: development source leaked into the built site" if site_dir.join(entry).exist?
end

if errors.empty?
  puts "Checked #{html_files.size} HTML files: SEO metadata and sitemap are valid"
else
  warn errors.join("\n")
  exit 1
end
