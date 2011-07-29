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

  it "should set its position when initialized" do
    field  = Logo::Field.new(100)
    turtle = Logo::Turtle.new(position: {x: 50, y: 60}, field: field)
    turtle.position.should == {x: 50, y: 60}
  end

  it "should set its heading when initialized" do
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
    field  = Logo::Field.new(11)
    turtle = Logo::Turtle.new(field: field)
    expect{turtle.FD 5}.should change(turtle, :position).
      from({x: 0, y: 0}).
      to({x: 0, y: 5})
  end

  it "should move on an angle" do
    field  = Logo::Field.new(11)
    turtle = Logo::Turtle.new(field: field, position: {x: 5, y: 5})
    turtle.RT 135
    turtle.FD 5
    turtle.position.should == {x: 10, y: 0}
  end


  it "should mark the field position it is placed on with an X" do
    field  = Logo::Field.new(3)
    turtle = Logo::Turtle.new(position: {x: 1, y: 1}, field: field)
    turtle.field.should ==  [
                              %w{. . .},
                              %w{. X .},
                              %w{. . .}
                            ]
  end

  it "should mark every field position it travels across with an X" do
    field  = Logo::Field.new(3)
    turtle = Logo::Turtle.new(position: {x: 0, y: 0}, field: field)
    turtle.RT 45
    turtle.FD 2
    turtle.field.should ==  [
                              %w{. . X},
                              %w{. X .},
                              %w{X . .}
                            ]
  end

  # these are features I added afterwards because I thought they would be cool

  it "should wrap around left-to-right when moving out of bounds" do
    field  = Logo::Field.new(5)
    turtle = Logo::Turtle.new(position: {x: 0, y: 0}, field: field)
    turtle.LT 90
    turtle.FD 1
    turtle.position.should == {x: 4, y: 0}
  end

  it "should wrap around right-to-left when moving out of bounds" do
    field  = Logo::Field.new(5)
    turtle = Logo::Turtle.new(position: {x: 4, y: 0}, field: field)
    turtle.RT 90
    turtle.FD 1
    turtle.position.should == {x: 0, y: 0}
  end

  it "should wrap around bottom-to-top when moving out of bounds" do
    field  = Logo::Field.new(5)
    turtle = Logo::Turtle.new(position: {x: 0, y: 0}, field: field)
    turtle.RT 180
    turtle.FD 1
    turtle.position.should == {x: 0, y: 4}
  end

  it "should wrap around bottom-to-top when moving out of bounds" do
    field  = Logo::Field.new(5)
    turtle = Logo::Turtle.new(position: {x: 0, y: 4}, field: field)
    turtle.FD 1
    turtle.position.should == {x: 0, y: 0}
  end

end





