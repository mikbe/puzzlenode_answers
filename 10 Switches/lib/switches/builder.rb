require 'forwardable'

module Switches

  class Builder
    attr_accessor :text_lines

    def initialize(text_lines)
      @text_lines = text_lines
    end

    def bulbs
      @bulbs ||= begin
        bulbs = []

        @text_lines.each_with_index do |line_text, y|
          bulb_x = line_text.index("@")
          bulbs << [bulb_x, y] if bulb_x
        end

        bulbs
      end
    end

    def go_left(start_position)
      return unless start_position
      start_x, start_y = start_position

      (start_x).downto(0) do |x|
        test_item = text_lines[start_y][x]

        if ["0", "1"].include? test_item
          return [false, true][test_item.to_i]
        end

        if %w{O A X N}.include? text_lines[start_y][x]
          return {switch: test_item, position: [x,start_y]}
        end
      end
      nil
    end

    def go_up(start_position)
      return unless start_position
      start_x, start_y = start_position

      (start_y).downto(0) do |y|
        return if text_lines[y][start_x] == " "
        return [start_x, y] if text_lines[y][start_x - 1] == "-"
      end
      nil
    end

    def go_down(start_position)
      return unless start_position
      start_x, start_y = start_position

      (start_y).upto(text_lines.length-1) do |y|
        return if text_lines[y][start_x] == " "
        return [start_x, y] if text_lines[y][start_x - 1] == "-"
      end
      nil
    end

    def results
      self.bulbs.map{|bulb| result(bulb) ? "on" : "off"}
    end

    def result(position)
      return unless position

      left_value = go_left(position)
      return left_value if [true, false].include? left_value

      gate(
        left_value[:switch]).call(
          result(go_up(left_value[:position])),
          result(go_down(left_value[:position]))
      )

    end

    def gate(type)

      case type
        when "O"
          Proc.new {|a,b| a || b}
        when "A"
          Proc.new {|a,b| a && b}
        when "X"
          Proc.new {|a,b| a ^ b}
        when "N"
          Proc.new {|a,b| a ? !a : !b}
        else
          raise Exception, "Unknown gate type"
      end

    end

  end

end
