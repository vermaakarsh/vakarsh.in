require "digest"

asset = File.binread("static/images/akarsh-favicon.png")
abort "Favicon must be the supplied 160px PNG" unless asset.start_with?("\x89PNG\r\n\x1a\n".b) && asset.byteslice(16, 8).unpack("NN") == [160, 160]
digest = Digest::SHA256.hexdigest(asset)[0, 20]
expected = ["/posts", "/projects", "/talks", "/tags", "/about me"]
checked = 0
Dir.glob("public/**/*.html").each do |path|
  html = File.read(path)
  next if html.include?("<title>Redirect</title>") && html.include?("window.location.replace")
  nav = html[/<nav\b[^>]*>(.*?)<\/nav>/m, 1]
  abort "Navigation missing in #{path}" unless nav
  labels = nav.scan(/<a\b[^>]*>(.*?)<\/a>/m).flatten.select { |label| expected.include?(label) }
  abort "Wrong navigation order in #{path}: #{labels.inspect}" unless labels == expected
  abort "LinkedIn social missing in #{path}" unless nav.match?(/<a\b[^>]*href=(?:"https:\/\/www\.linkedin\.com\/in\/akarshverma\/"|https:\/\/www\.linkedin\.com\/in\/akarshverma\/)[^>]*>\s*<img\b[^>]*alt=LinkedIn[^>]*>/)
  %w[icon apple-touch-icon].each do |rel|
    links = html.scan(/<link\b[^>]*>/).select { |tag| tag.match?(/\brel=(?:"#{rel}"|#{rel})(?:\s|>)/) }
    abort "Missing or stale #{rel} in #{path}" unless links.length == 1 && links[0].include?("akarsh-favicon.png?h=#{digest}")
  end
  checked += 1
end
abort "No themed pages checked" if checked.zero?
abort "LinkedIn icon missing" unless File.file?("public/icons/social/linkedin.svg")
{"public/index.html" => "Hey there 👋🏼", "public/projects/index.html" => "Projects", "public/talks/index.html" => "Talks", "public/about/index.html" => "About me"}.each do |path, title|
  html = File.read(path)
  abort "Wrong heading in #{path}" unless html.match?(/<h1\b[^>]*>\s*#{Regexp.escape(title)}\s*<\/h1>/)
end
archive = File.read("public/posts/index.html")
abort "Posts archive title missing" unless archive.match?(/<div\b[^>]*class=(?:"page-header"|page-header)[^>]*>\s*Posts\s*<\/div>/)
puts "PASS: #{checked} themed pages have ordered navigation, LinkedIn and a versioned face favicon; page headings match"
