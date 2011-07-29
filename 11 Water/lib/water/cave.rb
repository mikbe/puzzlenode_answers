module Water
  
  class Cave
    
    attr_accessor :cave, :flow_to, :height, :width
    
    def initialize(file)
      
      lines = File.readlines(file)
      @flow_to = lines.shift.to_i - 1
      lines.shift
      @cave = lines.collect {|line| line.chomp!}
      @height = @cave.length
      @width = @cave[0].length
    end
    
    def water
      count = []
      width.times do |col|
        water_count = 0
        height.times do |row|
          if water_count > 0 and cave[row][col] == " "
            water_count = "~"
            break
          end
          water_count += cave[row][col] == "~" ? 1 : 0
        end
        count << water_count.to_s
      end
      count
    end
    
    def at(position, relative=[0,0])
      cave[position[1] + relative[1]][position[0] + relative[0]]
    end
    
    def wet(position)
      @cave[position[1]][position[0]] = "~"
    end
    
  end
  
end