require "digest"
require "rexml/document"

asset_path = "static/images/akarsh-avatar.svg"
asset = File.read(asset_path)
abort "Unsafe avatar markup" if asset.match?(/<!DOCTYPE|<script\b|<foreignObject\b|\bon\w+\s*=|(?:xlink:)?href\s*=/i)
root = REXML::Document.new(asset).root
abort "Avatar must be a square SVG" unless root.name == "svg" && root.attributes["viewBox"] == "0 0 400 400"

html = File.read("public/about/index.html")
digest = Digest::SHA256.hexdigest(asset)[0, 20]
images = html.scan(/<img\b[^>]*>/)
portrait = images.select { |tag| tag.include?("images/akarsh-avatar.svg?h=#{digest}") }
abort "About must render exactly one versioned portrait" unless portrait.length == 1
abort "Missing descriptive alt text" unless portrait[0].include?('alt="Illustrated portrait of Akarsh Verma"')
abort "Missing reserved square dimensions" unless %w[width height].all? { |attr| portrait[0].match?(/\b#{attr}=(?:"180"|180)(?:\s|>)/) }
abort "Placeholder still visible" if html.include?("Photo to come") || html.include?("portrait-placeholder")
puts "PASS: About renders the supplied square avatar with alt text and a content-hashed URL"
