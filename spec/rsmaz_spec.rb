require File.dirname(__FILE__) + '/spec_helper.rb'

describe RSmaz do
  
  it "should compress 'the' to one byte" do
    RSmaz.compress("the").length.should == 1
  end
  
  it "should compress 'thex' to three bytes" do
    RSmaz.compress("thex").length.should == 3
  end
  
  it "should compress and decompress strings back to the same string" do
    [
      "This is a test.",
      "This is a test",
      "this is a test",
      "Let's try a SlIgHtLy Funkie938R str1ng!?!?x",
      "What about a long one?" * 100
    ].each { |str| RSmaz.decompress(RSmaz.compress(str)).should == str }    
  end
  
  it "should properly decode a reference compression (so the internal coding doesn't change)" do
    RSmaz.decompress("\020\230`A\376o\f\026\030").should == "hello world"
  end
end
