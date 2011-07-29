require 'spec_helper'

describe Logo::Parser do

  let(:parser){Logo::Parser.new}

  it "should have a run command" do
    parser.should respond_to(:run)
  end

  it "should create a field given the first line" do
    parser.run """3
    """
    parser.field.should == [[".", ".", "."], [".", "X", "."], [".", ".", "."]]
  end

  it "should create a turtle and put it in the middle of the grid" do
    parser.run """3
    """
    parser.turtle.position.should == {x:1,y:1}
  end

  it "should parse standard turtle commands" do
    parser.run """11

                  RT 45
                  FD 2
                  """
    parser.turtle.position.should == {x:7,y:7}
  end
  
  
  it "should repeat commands" do
    parser.run """11
    
                  REPEAT 2 [ RT 45 FD 2 ]
                  """
    parser.turtle.position.should == {x:9,y:7}
    
  end

  it "should draw the logo" do
    parser.run """61

                  RT 135
                  FD 5
                  REPEAT 2 [ RT 90 FD 15 ]
                  RT 90
                  FD 5
                  RT 45
                  FD 20
                  """
    parser.turtle.position.should == {:x=>30, :y=>30}

  end
  
end


  
  
  
