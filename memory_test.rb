#!/usr/bin/env ruby

if ARGV.include?( '-h' ) || ARGV.include?( '--help' )
  puts %q{
This script accepts 3 positional arguments:
  1. REQUIRED: the name of the Ruby implementation used to run this script
  2. OPTIONAL: the implementation of the text editor to use -- DEFAULT is lib/text_edit_naive
  3. OPTIONAL: the final number of characters to attempt to insert -- DEFAULT is 100,000}
  exit 0
end

$:.unshift File.expand_path(File.dirname(__FILE__))
ruby = ARGV.shift
attempt = ARGV.shift || "lib/text_edit_naive"
require attempt

start_time = Time.now

puts "Starting Memory:"
starting_mem = `ps -o rss= -p #{$$}`.to_i
ending_mem = -1
puts starting_mem

doc  = TextEditor::Document.new
msg = "X"

final_number_of_characters = (ARGV.shift || 100_000).to_i
[100, 1_000, 10_000, final_number_of_characters].each do |x|
  puts "Adding #{x} characters, 1 at a time"

  x.times do
    doc.add_text(msg)
  end

  puts "Current memory footprint:"
  ending_mem = `ps -o rss= -p #{$$}`.to_i
  puts ending_mem
end

puts "Took #{Time.now - start_time}s to run"
percentage = ((ending_mem - starting_mem) / 1.0 / starting_mem) * 100
csv_file = File.join(File.dirname(__FILE__), 'analysis', 'memory_test.csv')
File.open(csv_file, 'a') do |f|
  f << "#{`wc -l #{csv_file}`.chomp.to_i},#{ruby},#{final_number_of_characters},#{starting_mem},#{ending_mem},#{percentage}\n"
end
puts "Ending memory increase: %0.2f%" % percentage
