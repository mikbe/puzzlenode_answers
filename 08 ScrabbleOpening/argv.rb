def x(a="a" , b="b", c="c")
  puts "a: #{a}"
  puts "b: #{b}"
  puts "c: #{c}"
end


x(*ARGV)