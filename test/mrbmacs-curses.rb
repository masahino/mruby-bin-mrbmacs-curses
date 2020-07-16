require File.dirname(__FILE__) + '/test_helper.rb'

assert('doscan') do
  app = Mrbmacs::TestApp.new
  app.frame.tk.key_buffer.push 'a'
  assert_equal nil, app.doscan('')
end