module Mrbmacs
  class Application
    def isearch_forward()
      prompt = "I-search: "
      view_win = @frame.view_win
      echo_win = @frame.echo_win
      echo_win.sci_clear_all
      echo_win.sci_add_text(prompt.length, prompt)
      echo_win.refresh
      view_win.sci_set_target_start(view_win.sci_get_current_pos)
      view_win.sci_set_target_end(view_win.sci_get_length)
      search_text = ""
      while true
        ret, key = @frame.waitkey(echo_win)
        key_str = @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-s"
          if search_text != ""
            view_win.sci_set_target_start(view_win.sci_get_current_pos)
          else
            next
          end
        elsif (key.modifiers & TermKey::KEYMOD_CTRL > 0) or (key.modifiers & TermKey::KEYMOD_ALT > 0)
          break
        else
          @frame.send_key(key, echo_win)
          echo_win.refresh
          search_text += key_str #echo_win.get_line(0)[prompt.length..-1]
        end
        ret = view_win.sci_search_in_target(search_text.length, search_text)
        if ret != -1
          view_win.sci_set_sel(view_win.sci_get_target_start, view_win.sci_get_target_end)
          view_win.sci_set_target_end(view_win.sci_get_length)
        end
        view_win.refresh
      end
      echo_win.sci_clear_all
      echo_win.refresh
    end
  end
end
