require 'spec_helper'
require 'input_output'

describe IO do
  before :all do
    @io = InputOutput.new
  end

  before :each do
    @input = StringIO.new('input', 'r+')
    @output = StringIO.new('', 'w')
    @io.setup(@input, @output)
  end

  it "prints a request" do
    @output.should_receive(:print)
    @io.request("request")
  end

  it "accepts any number of arguments" do
    @output.should_receive(:print).with("anything", "something")
    @io.request("anything", "something")
  end

  it "gets string from input" do
    @io.request("").should == "input"
  end

  it "receives valid inputs" do
    @io.valid_input = ['a', 'b']
  end

  it "doesnt accept invalid input" do
    @io.valid_input = ['anything', 'something']
    @input.should_receive(:gets).and_return('nothing','anything')
    @io.request("").should_not == 'nothing'
  end

  it "removes newline characters before checking for valid" do
    @io.valid_input = ['a']
    @input.reopen("a\n", "r")
    @io.request("").should == 'a'
  end

  it "returns true when it's valid" do
    @io.valid_input = ['a', 'b']
    @io.valid_input?('b').should == true
    @io.valid_input?('x').should == false
  end

  it "returns true if input isn't an array" do
    @io.valid_input = nil
    @io.valid_input?("anything").should == true
  end

  it "returns false if input isn't a string" do
    @io.valid_input = nil
    @io.valid_input?(nil).should == false
    @io.valid_input?(1).should == false
    @io.valid_input?(:symbol).should == false
  end

  it "keeps asking until valid input" do
    @output.should_receive(:print).with("request").exactly(4).times
    @input.should_receive(:gets).and_return("anything", "something", "everything", "nothing")
    @io.valid_input = ["nothing"]
    @io.request("request").should == "nothing"
  end
end
