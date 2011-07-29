require 'spec_helper'

describe Switches::Builder do
  
  it "should find a lightbulb" do
    text = [
            "|",
            "|",  
            "O-@",
            "|"
           ]
    builder = Switches::Builder.new(text)
    builder.bulbs.should == [[2,2]]
  end

  it "should find multiple lightbulbs" do
    text = [
            "|",
            "|",  
            "O-@",
            "|",
            " ",
            "|",
            "A-@",
            " ",
            "@"
           ]
    builder = Switches::Builder.new(text)
    builder.bulbs.should == [[2,2], [2,6], [0,8]]
  end

  context "when traversing the map" do
    it "should go left and return a switch position" do
      text = [
               "--|",
               "  |",
               "  O---------@",
               "  |",
               "--|",
              ]
      builder = Switches::Builder.new(text)
      builder.go_left([10,2]).should == {switch:"O", position: [2,2]}
    end
  
    it "should go left and return a true or false" do
      text = [
               "",
               "",
               "0---@",
               "",
               "",
              ]
      builder = Switches::Builder.new(text)
      builder.go_left([4,2]).should == false
    
    end
  
    it "should go up from a switch to find a turn" do
      text = [
               "  |",
               "--|",
               "   ",
               "--|",
               "  |",
               "  O---------@",
               "  |",
               "--|",
              ]
      builder = Switches::Builder.new(text)
      builder.go_up([2,5]).should == [2,3]
    end
  
    it "should not go up if there is no circuit" do
      text = [
               "  |",
               "--|",
               "   ",
               "   ",
               "   ",
               "  O---------@", 
               "  |",
               "--|",
              ]
      builder = Switches::Builder.new(text)
      builder.go_up([2,5]).should == nil
    end

    it "should go down from from a switch to find a turn" do
      text = [
               "  |",
               "--|",
               "   ",
               "--|",
               "  |",
               "  O---------@",
               "  |",
               "--|",
              ]
      builder = Switches::Builder.new(text)
      builder.go_down([2,5]).should == [2,7]
    end

    it "should not go down if there is no circuit" do
      text = [
               "  |",
               "--|",
               "   ",
               "--|",
               "  |",
               "  O---------@", 
               "   ",
               "   ",
              ]
      builder = Switches::Builder.new(text)
      builder.go_down([2,5]).should == nil
    end
  end
  
  context "when building formulas " do

    it "should build formulas recursively" do
      
text = """
0--|
   O--|
1--|  |
      X--@
1--|  |
   N--|
"""
      text_lines = text.split("\n")
      builder = Switches::Builder.new(text_lines)
      builder.results.first.should == "on"
    end

    context "when building gates" do
      
      it "should build an OR gate" do
        builder = Switches::Builder.new("")
        gate = builder.gate("O")
        
        gate.call(true,false).should    == true
        gate.call(true,true).should     == true
        gate.call(false,true).should    == true
        gate.call(false,false).should   == false
      end

      it "should build an XOR gate" do
        builder = Switches::Builder.new("")
        gate = builder.gate("X")
        
        gate.call(true,false).should    == true
        gate.call(true,true).should     == false
        gate.call(false,true).should    == true
        gate.call(false,false).should   == false
      end

      it "should build an AND gate" do
        builder = Switches::Builder.new("")
        gate = builder.gate("A")
        
        gate.call(true,false).should    == false
        gate.call(true,true).should     == true
        gate.call(false,true).should    == false
        gate.call(false,false).should   == false
      end
      
      it "should build an NOT gate" do
        builder = Switches::Builder.new("")
        gate = builder.gate("N")
        
        gate.call(true,nil).should    == false
        gate.call(false,nil).should   == true
        gate.call(nil,true).should    == false
        gate.call(nil,false).should   == true
      end


      
    end

  end
  
end










