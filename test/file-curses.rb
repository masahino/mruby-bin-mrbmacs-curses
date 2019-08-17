require File.dirname(__FILE__) + '/test_helper.rb'
assert("read_file_name") do
  app = Mrbmacs::TestApp.new
  app.read_file_name("test", "./")
end
