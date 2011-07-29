module Logo
  
  class Parser
    
    attr_accessor :field, :turtle

    def run(code)
    
      code_lines  = code.split("\n")
      size        = code_lines.shift.to_i
      middle      = (size / 2)

      @field = Logo::Field.new(size)
      code_lines.shift

      @turtle = Logo::Turtle.new(
        field: @field, 
        direction: 0, 
        position: {x: middle, y: middle}
      )
      
      code_lines.each do |line|
        line.strip!
        
        _, count, whole_code = line.match(/REPEAT (\d+) \[ (.*) \]/).to_a
        count      ||= 1
        whole_code ||= line
        code_parts   = whole_code.scan(/\w+ \d+/)
        
        count.to_i.times do
          code_parts.each do |code_pair|
            command, value = code_pair.split
            @turtle.send command.to_sym, value.to_i
          end
        end
      end

    end

  end
   
end

