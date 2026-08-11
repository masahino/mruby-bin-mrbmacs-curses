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

assert('Curses keeps theme colours as RGB values') do
  base16 = Mrbmacs::Base16DefaultDarkTheme.new
  solarized = Mrbmacs::SolarizedDarkTheme.new

  assert_true base16.foreground_color > 0xff
  assert_true base16.background_color > 0xff
  assert_true solarized.foreground_color > 0xff
  assert_true solarized.background_color > 0xff
end
