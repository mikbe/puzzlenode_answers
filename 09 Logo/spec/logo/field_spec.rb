require 'spec_helper'

describe Logo::Field do

  let(:field){Logo::Field.new}

  it "should have a size property" do
    field.should respond_to(:size=)
  end

  it "should set up a field given a size" do
    field.size = 3
    field.should == [
                      %w{. . .},
                      %w{. . .},
                      %w{. . .}
                    ]
  end

  it "shoud set up the field if iniitialized wit a size" do
    Logo::Field.new(3).should == [
                                    %w{. . .},
                                    %w{. . .},
                                    %w{. . .}
                                  ]
  end

end
