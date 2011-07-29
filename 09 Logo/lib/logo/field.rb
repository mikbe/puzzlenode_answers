require 'forwardable'

module Logo
  
  class Field
    extend Forwardable
    
    attr_accessor :size

    def_delegators :@field, *Array.instance_methods(false)
    
    def initialize(size=0)
      self.size = size
    end
    
    def size=(size)
      @size = size
      @field = (0...size).collect {("." * size).split("")}
    end
    
  end
  
end