module Logo
  
  class Parser
    
    attr_accessor :field, :turtle

    def run(code)
    
      code_lines = code.split("\n")
      #puts code_lines
      
      size = code_lines.shift.to_i
      mid  = (size / 2)
      @field = Logo::Field.new(size)
      code_lines.shift
      @turtle = Logo::Turtle.new(field: @field, direction: 0, position: {x: mid, y: mid})
      
      code_lines.each do |line|
        line.strip!
        unless line.match /REPEAT/
          command, value = line.split
          @turtle.send command.to_sym, value.to_i if command
        else
          line, count, whole_code = line.match(/REPEAT (\d+) \[ (.*) \]/).to_a
          code_parts = whole_code.scan(/(\w+ \d+)/)
          count.to_i.times do
            code_parts.each do |code_pair|
              #puts code_pair
              command, value = code_pair.first.split
              @turtle.send command.to_sym, value.to_i if command
              raise Exeption, "Went null" unless @field.reverse[305] 
            end
          end
        end
      end

    end

  end
   
end

