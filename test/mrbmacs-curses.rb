require File.dirname(__FILE__) + '/test_helper.rb'

assert('doscan') do
  app = Mrbmacs::TestApp.new
  app.frame.tk.key_buffer.push 'a'
  assert_equal nil, app.doscan('')
end

assert('doscan 2') do
  app = Mrbmacs::TestApp.new
  app.frame.tk.key_buffer.push 'f'
  assert_equal Scintilla::SCI_WORDRIGHT, app.doscan('M-').pop
end