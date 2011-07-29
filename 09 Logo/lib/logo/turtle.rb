require 'forwardable'

module Logo
  
  class Turtle
    
    attr_reader :position, :heading, :field
    
    def initialize(args={})
      @field        = args[:field]    || Field.new(1)
      @heading      = args[:heading]  || 0
      self.position = args[:position] || {x: 0, y: 0}
    end
    
    def RT(angle)
      @heading = (@heading + angle) % 360
    end
    
    def LT(angle)
      RT(angle * -1)
    end
    
    def BK(distance)
      RT(180)
      FD(distance)
      RT(180)
    end
    
    def FD(distance)
      
      radian = (Math::PI / 180) * @heading
      distance.times do
        self.position = {
          x: @position[:x] + Math.sin(radian).round,
          y: @position[:y] + Math.cos(radian).round
        }
      end
    end

    def position=(new_position)
      #raise Exception, "Went null: #{new_position[:y]}" unless @field[new_position[:y]]
      #puts "x: #{new_position[:x]}; y: #{new_position[:x]}"
      @position = new_position
      begin
        @field.reverse[new_position[:y]][new_position[:x]] = "X"
        #puts @field.reverse[new_position[:y]][new_position[:x]]
      rescue Exception
        puts
        puts "x: #{new_position[:x]}; y: #{new_position[:x]}"
        
        puts @field[new_position[:y]].class
        puts @field.length
        puts @field.reverse[new_position[:y]].length
        puts
        abort
      end
      @position
    end
  
  end
  
end
