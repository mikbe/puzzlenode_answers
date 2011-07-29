$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "/lib"))
$: << '.'

require 'water'

cave = Water::Cave.new("simple_cave.txt")
flow = Water::Flow.new(cave)
puts
puts cave.cave

cave.flow_to.times do 
  system('clear')
  puts cave.cave
  sleep(0.03)
  flow.go
end
# puts %w{1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0}.join(" ")
# puts cave.water.join(" ")
# cave.water.should == %w{1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0}

# File.open("complex.txt", "w") { |file| file.write cave.water.join(" ") }
