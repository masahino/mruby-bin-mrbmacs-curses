require File.dirname(__FILE__) + '/test_helper.rb'
assert("isearch_forward") do 
  app = Mrbmacs::TestApp.new
#  assert app.isearch_forward
end

assert("isearch_backward") do
  app = Mrbmacs::TestApp.new
  app.frame.tk.key_buffer.push "C-g"
#  assert app.isearch_backward
end