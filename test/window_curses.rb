require File.dirname(__FILE__) + '/test_helper.rb'
assert('duplicate notification') do
  app = Mrbmacs::TestApp.new
  assert_equal 0, app.frame.sci_notifications.length
  app.frame.view_win.callback.call({ 'code' => Scintilla::SCN_CHARADDED, 'ch' => 100 })
  assert_equal 1, app.frame.sci_notifications.length
  app.frame.view_win.callback.call({ 'code' => Scintilla::SCN_MODIFIED })
  assert_equal 2, app.frame.sci_notifications.length
  app.frame.view_win.callback.call({ 'code' => Scintilla::SCN_CHARADDED, 'ch' => 99 })
  assert_equal 3, app.frame.sci_notifications.length
  assert_equal Scintilla::SCN_CHARADDED, app.frame.sci_notifications[-1]['code']
  assert_equal 99, app.frame.sci_notifications[-1]['ch']
end
