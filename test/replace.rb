require File.dirname(__FILE__) + '/test_helper.rb'
module Scintilla
  class ScintillaCurses
    def sci_search_in_target(length, text)
      -1
    end
  end
end

assert("replace_string") do 
  app = Mrbmacs::TestApp.new
  app.replace_string("a", "b", false)
  assert_equal 2079, app.frame.view_win.messages[-1]
end
