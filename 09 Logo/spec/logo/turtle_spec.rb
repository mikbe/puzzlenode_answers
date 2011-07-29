require 'spec_helper'

describe Logo::Turtle do

  let(:turtle) {Logo::Turtle.new}
  
  it "should have a position" do
    turtle.should respond_to(:position)
  end
  
  it "should have a default position of 0,0" do
    turtle = Logo::Turtle.new
    turtle.position.should == {x: 0, y: 0}
  end
  
  it "should have a heading" do
    turtle.should respond_to(:heading)
  end
  
  it "should have a default heading of 0" do
    turtle = Logo::Turtle.new
    turtle.heading.should == 0
  end

  it "should have a field property" do
    turtle.should respond_to(:field)
  end

  it "should set parameters based on a hash" do
    turtle = Logo::Turtle.new(heading: 0)
    turtle.heading.should == 0
  end

  it "should change its heading when turning" do
    turtle = Logo::Turtle.new(heading: 90)
    expect{turtle.RT 90}.should change(turtle, :heading).
      from(90). 
      to(180)
  end

  it "should change its heading when turning" do
    expect{turtle.RT 135}.should change(turtle, :heading).
      from(0).
      to(135)
  end

  it "should change its position when moving" do
    field = Logo::Field.new(11)
    turtle = Logo::Turtle.new(field: field)
    expect{turtle.FD 5}.should change(turtle, :position).
      from({x: 0, y: 0}).
      to({x: 0, y: 5})
  end

  it "should move on angles" do
    field = Logo::Field.new(11)
    turtle = Logo::Turtle.new(field: field, position: {x: 5, y: 5})
    turtle.RT 135
    turtle.FD 5
    turtle.position.should == {x: 10, y: 0}
  end


  it "should mark every field position it is on" do
    field = Logo::Field.new(3)
    turtle = Logo::Turtle.new(position: {x: 1, y: 1}, field: field)
    turtle.field.should ==  [
                              %w{. . .},
                              %w{. X .},
                              %w{. . .}
                            ]
  end

  it "should mark every field position it travels across" do
    field = Logo::Field.new(3)
    turtle = Logo::Turtle.new(position: {x: 0, y: 0}, field: field)
    turtle.RT 45
    turtle.FD 2 
    turtle.field.should ==  [
                              %w{. . X},
                              %w{. X .},
                              %w{X . .}
                            ]
  end


end





