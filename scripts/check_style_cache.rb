require "digest"

# Run after `zola build`. A changed stylesheet must produce a changed asset URL.
# Zola 0.23.6 uses the first 20 hexadecimal characters for get_url(cachebust=true).
digest = Digest::SHA256.file("static/custom.css").hexdigest[0, 20]
pages = Dir.glob("public/**/*.html")
abort "Build the site before checking stylesheet URLs" if pages.empty?

checked = 0
pages.each do |path|
  html = File.read(path)
  # Zola's pagination redirects intentionally have no theme or stylesheet.
  next if html.include?("<title>Redirect</title>") && html.include?("window.location.replace")
  styles = html.scan(/<link\b[^>]*href="([^"]*custom\.css[^"]*)"/).flatten
  abort "Missing, duplicated, or stale stylesheet URL in #{path}" unless
    styles.length == 1 && styles.first.end_with?("custom.css?h=#{digest}")
  checked += 1
end

abort "No themed pages checked" if checked.zero?
puts "PASS: #{checked} themed pages use the current stylesheet content hash"
