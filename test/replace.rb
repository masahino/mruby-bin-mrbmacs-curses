module Scintilla
  class ScintillaCurses
    def sci_search_in_target(length, text)
      -1
    end
  end
end

module Mrbmacs
  class Frame
    # TestApp uses a real (uninitialized) curses Frame, so modeline's
    # Curses.getmaxx(edit_win.mode_win) has no real window to measure.
    # replace_string's tests only care about the Scintilla messages sent
    # to view_win, not modeline rendering.
    def modeline(app, edit_win = @edit_win)
    end
  end
end

assert("replace_string") do 
  app = Mrbmacs::TestApp.new
  app.replace_string("a", "b", false)
  assert_equal 2079, app.frame.view_win.messages[-1]
end
