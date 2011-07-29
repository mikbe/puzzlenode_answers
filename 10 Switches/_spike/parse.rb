
x = Proc.new { |a, b| a || b }

puts x.call(true, false)