$:.unshift File.join( File.dirname(__FILE__), "..", "lib")
require 'data_kitten'
require 'pp'

if ARGV.length == 0
  puts "Usage: data_kitten <access_url>"
  exit 1
end

dataset = DataKitten::Dataset.new(access_url: ARGV[0])

if dataset.publishing_format == nil
  puts "Unable to determine format for dataset metadata"
  exit 1
end

(dataset.public_methods - Object.public_methods).sort.delete_if {|x| x.to_s =~ /=/ }.each do |method|
    puts "#{method}: #{dataset.send(method).pretty_inspect}"
end

