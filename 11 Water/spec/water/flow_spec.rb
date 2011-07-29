require 'spec_helper'

describe Water::Flow do

  let(:cave){Water::Cave.new("simple_cave.txt")}
  let(:flow){Water::Flow.new(cave)}

  it "should have a size property" do
    flow.should respond_to(:position)
  end
  it "should have a size property" do
    flow.position.should == [0,1]
  end

  it "should flow right if there is no rock" do
    expect{flow.go}.should change(flow, :position).
      from([0,1]).
      to([1,1])
  end

  it "should leave water where it flows" do
    flow.go
    cave.at([1,1]).should == "~"
  end
  
  it "should flow down first if there's no rock below" do
    2.times {flow.go}
    cave.at([1,2]).should == "~"
  end

  it "should start flowing from the lowest point when it hits a wall" do
    14.times {flow.go}
    flow.go
    cave.at([8,5]).should == "~"
  end

  it "should work" do
    cave.flow_to.times {flow.go}
    # puts
    # puts cave.cave
    # puts %w{1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0}.join(" ")
    # puts cave.water.join(" ")
    cave.water.should == %w{1 2 2 4 4 4 4 6 6 6 1 1 1 1 4 3 3 4 4 4 4 5 5 5 5 5 2 2 1 1 0 0}
    
  end


end
