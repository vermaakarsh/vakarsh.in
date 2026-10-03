require "digest"
require "rexml/document"

asset_path = "static/images/akarsh-avatar.png"
asset = File.binread(asset_path)
abort "Avatar must be the supplied 360px square PNG" unless asset.start_with?("\x89PNG\r\n\x1a\n".b) && asset.byteslice(16, 8).unpack("NN") == [360, 360]
offset = 8
frames = nil
while offset + 12 <= asset.bytesize
  length = asset.byteslice(offset, 4).unpack1("N")
  type = asset.byteslice(offset + 4, 4)
  frames = asset.byteslice(offset + 8, 4).unpack1("N") if type == "acTL"
  offset += length + 12
end
abort "Supplied animation lost its 60 frames" unless frames == 60

still = File.read("static/images/akarsh-avatar.svg")
abort "Unsafe still portrait markup" if still.match?(/<!DOCTYPE|<script\b|<foreignObject\b|\bon\w+\s*=|(?:xlink:)?href\s*=/i)
root = REXML::Document.new(still).root
abort "Still portrait must be a square SVG" unless root.name == "svg" && root.attributes["viewBox"] == "0 0 400 400"

html = File.read("public/about/index.html")
digest = Digest::SHA256.hexdigest(asset)[0, 20]
images = html.scan(/<img\b[^>]*>/)
portrait = images.select { |tag| tag.include?("images/akarsh-avatar.png?h=#{digest}") }
abort "About must render exactly one versioned portrait" unless portrait.length == 1
abort "Missing descriptive alt text" unless portrait[0].include?('alt="Illustrated portrait of Akarsh Verma"')
abort "Missing reserved square dimensions" unless %w[width height].all? { |attr| portrait[0].match?(/\b#{attr}=(?:"180"|180)(?:\s|>)/) }
abort "Placeholder still visible" if html.include?("Photo to come") || html.include?("portrait-placeholder")
still_digest = Digest::SHA256.hexdigest(still)[0, 20]
abort "Missing reduced-motion still fallback" unless html.include?('media="(prefers-reduced-motion: reduce)"') && html.include?("akarsh-avatar.svg?h=#{still_digest}")
puts "PASS: About preserves the 60-frame supplied avatar, reserved dimensions, alt text, versioned URLs and reduced-motion still fallback"
