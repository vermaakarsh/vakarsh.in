html = File.read("public/about/index.html")
timeline = html[/<ol\b[^>]*class=life-timeline[^>]*>(.*?)<\/ol>/m, 1]
abort "Timeline missing" unless timeline
entries = timeline.scan(/<li\b[^>]*>.*?(?=<li\b|\z)/m)
abort "Timeline should stay compact at seven entries" unless entries.length == 7
abort "Current employer missing from Now" unless entries.first.include?("XCaliber Health") && entries.first.include?(">Now<")
career = entries.find { |entry| entry.include?("2018 - 2024") }
abort "2018-2024 grouping incorrect" unless career && %w[Home Thoucentric Kimberly-Clark].all? { |name| career.include?(name) } && !career.include?("XCaliber")
abort "Education and Ford durations changed" unless timeline.include?("2007 - 2011") && timeline.include?("Four years") && timeline.include?("2011 - 2018") && timeline.include?("Seven years")
abort "Highlighted fatherhood milestone missing" unless entries.any? { |entry| entry.include?("2020") && entry.include?("Became a dad") && entry.include?("journey-highlight") }
abort "Birth should be the final Hello world entry" unless entries.last.include?("25 August 1989") && entries.last.include?("Hello, world")
abort "QuantLab description not updated" unless html.include?("agents and financial engineering") && !html.include?("for Python and markets")
puts "PASS: reverse timeline, birth date, education/Ford periods, career grouping, fatherhood and channel description"
