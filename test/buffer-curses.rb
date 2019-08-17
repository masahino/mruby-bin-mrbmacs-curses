require File.dirname(__FILE__) + '/test_helper.rb'

assert("update_buffer_window") do
  app = Mrbmacs::TestApp.new
  new_buffer = Mrbmacs::Buffer.new
  app.buffer_list.push(new_buffer)
  app.update_buffer_window(new_buffer)
end
