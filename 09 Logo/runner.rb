$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/lib"))
$: << '.'

require 'logo'

commands = File.read("source/complex.logo")
parser = Logo::Parser.new
parser.run commands
File.open("test2.txt", "w") do |file|
  parser.field.each {|line| file.puts line.join(" ")}
end