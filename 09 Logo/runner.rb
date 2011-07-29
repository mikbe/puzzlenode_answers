$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/lib"))
$: << '.'

require 'logo'

input = "simple"

commands = File.read("source/#{input}.logo")
parser = Logo::Parser.new
parser.run commands
File.open("output/#{input}.txt", "w") do |file|
  parser.field.each {|line| file.puts line.join(" ")}
end