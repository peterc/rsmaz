begin
  require 'minitest/spec'
rescue LoadError
  require 'rubygems'
  gem 'minitest'
  require 'minitest/spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rsmaz'

def memory_usage
  `ps -Orss #{Process.pid} | tail -1`.scan(/\d+/)[1].to_i rescue 0
end

MiniTest::Unit.autorun