require "cgi"
require "optparse"
require "pathname"
require "uri"

options = {
  site_dir: "_site",
  baseurl: "",
}

OptionParser.new do |parser|
  parser.banner = "Usage: check_internal_links.rb [options]"
  parser.on("--site-dir DIR", "Generated site directory") { |value| options[:site_dir] = value }
  parser.on("--baseurl PATH", "Deployment base URL, for example /remember-me.ai") do |value|
    options[:baseurl] = value.sub(%r{/$}, "")
  end
end.parse!

site_dir = Pathname.new(options[:site_dir]).expand_path
abort "Site directory does not exist: #{site_dir}" unless site_dir.directory?

def candidates_for(path)
  return [path.join("index.html")] if path.to_s.end_with?(File::SEPARATOR)
  return [path] unless path.extname.empty?

  [path, Pathname.new("#{path}.html"), path.join("index.html")]
end

failures = []
html_files = Dir.glob(site_dir.join("**/*.html").to_s).sort

html_files.each do |html_path|
  html_file = Pathname.new(html_path)
  content = File.read(html_file, encoding: "utf-8")

  content.scan(/\bhref\s*=\s*(["'])(.*?)\1/i).each do |_quote, raw_href|
    href = CGI.unescapeHTML(raw_href).strip
    next if href.empty? || href.start_with?("#", "mailto:", "tel:")
    next if href.match?(%r{\A(?:https?:)?//}i)

    path_part = href.split(/[?#]/, 2).first
    next if path_part.empty?

    begin
      path_part = URI::DEFAULT_PARSER.unescape(path_part)
    rescue ArgumentError
      failures << "#{html_file.relative_path_from(site_dir)}: invalid URL encoding in #{href.inspect}"
      next
    end

    if path_part.start_with?("/")
      baseurl = options[:baseurl]
      unless baseurl.empty? || path_part == baseurl || path_part.start_with?("#{baseurl}/")
        failures << "#{html_file.relative_path_from(site_dir)}: absolute link misses baseurl: #{href}"
        next
      end
      relative = baseurl.empty? ? path_part.delete_prefix("/") : path_part.delete_prefix(baseurl).delete_prefix("/")
      target = site_dir.join(relative)
    else
      target = html_file.dirname.join(path_part).cleanpath
    end

    unless target.to_s == site_dir.to_s || target.to_s.start_with?("#{site_dir}#{File::SEPARATOR}")
      failures << "#{html_file.relative_path_from(site_dir)}: link escapes site directory: #{href}"
      next
    end

    next if candidates_for(target).any?(&:exist?)

    failures << "#{html_file.relative_path_from(site_dir)}: missing target: #{href}"
  end
end

if failures.empty?
  puts "Checked #{html_files.length} HTML files: all internal links resolve"
else
  warn failures.join("\n")
  abort "Found #{failures.length} broken internal link(s)"
end
