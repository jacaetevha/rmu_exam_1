require 'csv'
require 'ostruct'
THIS_DIR = File.dirname(__FILE__)

ruby_versions = {}
CSV.foreach(File.join(THIS_DIR, 'memory_test.csv')) do |row|
  next if row[0] == 'Run'
  key = [row[1], row[2].to_i]
  (ruby_versions[key] ||= []) << OpenStruct.new
  os = ruby_versions[key].last
  os.starting_mem = row[3].to_i
  os.ending_mem = row[4].to_i
  os.percent_change = row[5].to_i
end

categories = ruby_versions.keys.sort
average = lambda do |key, category|
  sum = ruby_versions[category].inject(0) { |mem, os|  mem + os.send(key)}
  sum * 1.0 / ruby_versions[category].size
end

average_starting_mem = categories.collect &average.curry[:starting_mem]
average_ending_mem = categories.collect &average.curry[:ending_mem]
average_percent_change = categories.collect &average.curry[:percent_change]

html_output = File.expand_path File.join(THIS_DIR, "index.html")
File.open(html_output, 'w') do |file|
  template = File.read(File.join(THIS_DIR, "index.html.template"))
  html = template % [Date.today.to_s,
                      categories.collect{|e| "#{e[0]} @ #{e[1]} Max Chars (#{ruby_versions[e].size} runs)"}.to_s, 
                      average_starting_mem.inspect, 
                      average_percent_change.inspect, 
                      average_ending_mem.inspect]
  file << html
end
puts "Now open #{html_output}"