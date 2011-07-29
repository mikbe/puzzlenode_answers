module Water
  
  class Flow
    
    attr_accessor :position, :cave
    
    def initialize(cave)
      @cave = cave
      @position = [0,1]
      @last_down_flow = []
    end
    
    def go
      # flow down
      if cave.at(position, [0,1]) == " "
        @last_down_flow << position.clone
        position[1] += 1
      # flow right
      elsif cave.at(position, [1,0]) == " "
        position[0] += 1
      else
        # puts "too much water"
        @position = @last_down_flow.pop
        go
        return
      end
      cave.wet(position)
    end
    
  end
  
end