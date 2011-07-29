$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/lib"))
$: << '.'

require 'switches'

circuit = File.readlines("source/complex_circuits.txt")

builder = Switches::Builder.new(circuit)
results = builder.results
puts results

File.open("complex.txt", "w") do |file|
  results.each {|result| file.puts result}
end