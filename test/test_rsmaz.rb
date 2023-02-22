require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

describe RSmaz do

  #before(:each) do
  #  # Do some memory leak checking
  #  puts "\nMemory used: #{memory_usage}K"
  #end
  #
  #after(:each) do
  #  puts "\nMemory used: #{memory_usage}K"
  #end
  
  it "should compress 'the' to one byte" do
    _(RSmaz.compress("the").length).must_equal 1
  end
  
  it "should compress 'thex' to two bytes" do
    _(RSmaz.compress("thex").length).must_equal 2
  end
  
  it "should compress and decompress strings back to the same string" do
    [
      "This is a test.",
      "This is a test",
      "this is a test",
      "Let's try a SlIgHtLy Funkie938R str1ng!?!?x",
      "What about a long one?" * 100
    ].each do |str|
      result = RSmaz.decompress(RSmaz.compress(str))
      _(result).must_equal str
    end
  end
  
  it "should properly decode a reference compression (so the internal coding doesn't change)" do
    _(RSmaz.decompress("\020\230`A\376o\f\026\030")).must_equal "hello world"
  end
  
  it "should compress to the same extent as the reference smaz implementation" do
    _(RSmaz.compress("foobar").length).must_equal 4
    _(RSmaz.compress("Nel mezzo del cammin di nostra vita, mi ritrovai in una selva oscura").length).must_equal 46
  end
  
  it "should compress and decompress lots of random strings without issues" do
    100.times do
      str = (1..100).map { |a| (rand(26)+97).chr }.join
      _(RSmaz.decompress(RSmaz.compress(str)).length).must_equal str.length
    end
  end

  it "should compress and decompress lots of random strings without issues (again)" do
    100.times do
      str = (1..100).map { |a| (rand(26)+97).chr }.join
      _(RSmaz.decompress(RSmaz.compress(str)).length).must_equal str.length
    end
  end
  
  if ''.respond_to?(:encoding)
    # U+2603 = Unicode snowman
    
    it "should be able to compress strings with arbitrary encodings" do
      _(RSmaz.decompress(RSmaz.compress("\u2603")).force_encoding('utf-8')).must_equal "\u2603"
    end
    
    it "should return binary strings upon compressing" do
      _(RSmaz.compress("\u2603").encoding).must_equal Encoding.find('binary')
    end
    
    it "should return binary strings upon decompressing" do
      _(RSmaz.decompress(RSmaz.compress("\u2603")).encoding).must_equal Encoding.find('binary')
    end
  end
end

