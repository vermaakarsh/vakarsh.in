require "fileutils"
require "tmpdir"

def assert(value, message)
  abort message unless value
end

home = File.read("public/index.html")
assert(home.include?("Hey there 👋🏼") && home.include?("🇮🇳"), "Homepage greeting and India flag missing")
assert(home.scan(/<h2\b[^>]*>(.*?)<\/h2>/m).flatten == ["Highlighted articles", "Recent articles"], "Homepage article sections missing or out of order")
[["highlighted-articles", "No highlighted articles yet."], ["recent-articles", "Nothing published yet."]].each do |id, empty|
  section = home[/<section\b[^>]*aria-labelledby=#{id}[^>]*>(.*?)<\/section>/m, 1]
  assert(section && (section.include?("<ul") || section.include?(empty)), "Article list or honest empty state missing")
end
assert(File.read("public/work/index.html").include?("https://vakarsh.in/projects/"), "Old work route does not redirect to projects")
assert(File.read("public/about/index.html").include?("Hey there 👋🏼"), "About greeting missing")
assert(File.read("public/talks/index.html").include?("No talks listed yet."), "Talks empty state missing")

# Exercise article selection only in an isolated test build, never in site content.
Dir.mktmpdir("vakarsh-home-test-") do |site|
  %w[config.toml content templates static sass].each do |entry|
    FileUtils.cp_r(entry, site) if File.exist?(entry)
  end
  FileUtils.mkdir_p(File.join(site, "themes"))
  FileUtils.ln_s(File.expand_path("themes/apollo"), File.join(site, "themes/apollo"))
  config_path = File.join(site, "config.toml")
  config = File.read(config_path).sub(/highlighted_posts = \[[^\n]*\]/, 'highlighted_posts = ["posts/second.md", "posts/highlight.md", "posts/private.md", "posts/missing.md"]')
  config = config.sub('base_url = "https://vakarsh.in"', 'base_url = "http://127.0.0.1:51769"') if ENV["PREVIEW_FIXTURE"]
  File.write(config_path, config)
  FileUtils.rm_f(Dir.glob(File.join(site, "content/posts/*.md")).reject { |path| File.basename(path) == "_index.md" })
  fixtures = [["highlight", "2025-01-01", false], ["second", "2024-01-01", false], ["recent", "2026-01-01", false], ["private", "2026-02-01", true]]
  fixtures += (1..6).map { |index| ["older-#{index}", "2023-01-0#{index}", false] }
  fixtures.each do |slug, date, draft|
    File.write(File.join(site, "content/posts/#{slug}.md"), "+++\ntitle = \"Fixture #{slug}\"\ndate = #{date}\ndraft = #{draft}\n+++\n\nIsolated test article.\n")
  end
  zola = ENV.fetch("ZOLA", "zola")
  assert(system(zola, "--root", site, "build", out: File::NULL), "Isolated article fixture build failed")
  rendered = File.read(File.join(site, "public/index.html"))
  highlighted = rendered[/<section\b[^>]*aria-labelledby=highlighted-articles[^>]*>(.*?)<\/section>/m, 1]
  recent = rendered[/<section\b[^>]*aria-labelledby=recent-articles[^>]*>(.*?)<\/section>/m, 1]
  assert(highlighted && recent, "Article sections not rendered")
  assert(highlighted.include?("Fixture highlight") && !highlighted.include?("Fixture recent"), "Curated article selection broken")
  assert(highlighted.index("Fixture second") < highlighted.index("Fixture highlight"), "Highlighted articles do not follow curated order")
  assert(recent.index("Fixture recent") && recent.index("Fixture highlight") && recent.index("Fixture recent") < recent.index("Fixture highlight"), "Recent articles are not newest first")
  assert(!rendered.include?("Fixture private") && !rendered.include?("Fixture missing"), "Draft or missing article leaked into homepage")
  assert(!recent.include?("Read more"), "Homepage should use compact date/title rows")
  assert(recent.scan(/<li>/).length == 5, "Recent articles must show only five entries")
  if ENV["PREVIEW_FIXTURE"]
    destination = ENV.fetch("PREVIEW_FIXTURE")
    assert(destination.start_with?("/private/tmp/vakarsh-fixture-") && !File.exist?(destination), "Fixture preview must use a new, task-specific temporary directory")
    FileUtils.cp_r(File.join(site, "public"), destination)
    puts "Isolated fixture preview: #{destination}"
  end
end
puts "PASS: short intro, ordered article sections, empty states, route redirect and isolated published/draft selection"
