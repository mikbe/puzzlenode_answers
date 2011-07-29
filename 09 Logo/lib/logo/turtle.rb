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
      bounds_check(new_position)
      mark_field(new_position)
      @position = new_position
    end
  
    private
  
    def mark_field(position)
      @field.reverse[position[:y]][position[:x]] = "X"
    end
  
    def bounds_check(position)
      [:x, :y].each do |axis|
        position[axis] = @field.size - 1 if position[axis] == -1
        position[axis] = 0 if position[axis] == @field.size
      end
    end
  
  end
  
end
