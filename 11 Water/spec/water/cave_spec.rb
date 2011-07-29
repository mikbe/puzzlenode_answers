require 'spec_helper'

describe Water::Cave do

  let(:cave){Water::Cave.new("simple_cave.txt")}

  it "should parse the flow_to value and set it 1 less because the cave already flowed once" do
    cave.flow_to.should == 99
  end
  
  it "should only be the cave text itself" do
    puts
    puts cave.cave
  end

  it 'should count the initial column of water' do
    cave.water.should == %w{1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 }
  end

  it 'should count water still flowing water as "~"' do
    cave.cave[1][1] = "~"
    cave.water.should == %w{1 ~ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 }
  end

  it 'should have tell me what is at a location in the cave' do
    cave.at([0,1]).should == "~"
  end

  it 'should accept a second relative parameter' do
    cave.at([0,0], [0,1]).should == "~"
  end

  it 'should set a position to water' do
    cave.wet([1,1])
    cave.at([1,1]).should == "~"
  end

end
