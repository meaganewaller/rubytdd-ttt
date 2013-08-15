require 'spec_helper'
require 'input_output'

describe InputOutput do
  before :all do
    @io = InputOutput.new
  end

  before :each do
    @in = StringIO.new('message', 'r+')
    @out = StringIO.new('', 'w')
    @io.setup(@in, @out)
  end

  it "prints a message" do
    @out.should_receive(:print)
    @io.request("Hello")
  end

  it "can accept multiple messages to print" do
    @out.should_receive(:print).with("hello", "world")
    @io.request("hello", "world")
  end

  it "receives input" do
    @io.request("").should == "message"
  end

  it "has valid input" do
    @io.valid_input = ['x', 'y']
  end

  it "doesn't allow invalid input" do
    @io.valid_input = ['x', 'y']
    @in.should_receive(:gets).and_return('c', 'x')
    @io.request("").should_not == 'c'
  end

  it "allows any input if valid input is nil" do
    @io.valid_input = nil
    @in.reopen("anything", "r+")
    @io.request("").should == "anything"
  end

  it "returns true when input matches #valid_input" do
    @io.valid_input = ['x', 'y']
    @io.valid_input?('x').should be_true
    @io.valid_input?('p').should be_false
  end

  it "returns true if #valid_input is not Array" do
    @io.valid_input = nil
    @io.valid_input?(":anything!").should be_true
  end

  it "returns false if #valid_input is not a String" do
    @io.valid_input = nil
    @io.valid_input?(nil).should be_false
    @io.valid_input?(1).should be_false
  end

  it "repeats #request until valid input" do
    @out.should_receive(:print).with("request").exactly(3).times
    @in.should_receive(:gets).and_return("ugh", "stop", "YES")
    @io.valid_input = ["YES"]
    @io.request("request").should == "YES"
  end

  it "#request new line before valid" do
    @io.valid_input = ['x']
    @in.reopen("x\n", 'r')
    @io.request("").should == "x"
  end
end
