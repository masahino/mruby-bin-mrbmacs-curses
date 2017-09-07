module Mrbmacs
  class Application
    def isearch_forward()
      isearch("I-search: ", false)#, @frame.view_win.sci_get_length)
    end

    def isearch_backward()
      isearch("I-search backward: ", true) #0)
    end

    def isearch(prompt, backward = false)
      view_win = @frame.view_win
      echo_win = @frame.echo_win

      start_pos = view_win.sci_get_current_pos
      orig_pos = start_pos
      end_pos = backward == false ? view_win.sci_get_length : 0
      echo_win.sci_clear_all
      @frame.echo_set_prompt(prompt)
      echo_win.refresh
      view_win.sci_set_target_start(start_pos)
      view_win.sci_set_target_end(end_pos)
      search_text = ""
      while true
        ret, key = @frame.waitkey(echo_win)
        key_str = @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-s"
          if search_text != ""
            backward = false
            view_win.sci_set_target_start(view_win.sci_get_current_pos)
            end_pos = view_win.sci_get_length
            view_win.sci_set_target_end(end_pos)
          else
            next
          end
        elsif key_str == "C-r"
          if search_text != ""
            backward = true
            start_pos = view_win.sci_get_current_pos-search_text.length
            view_win.sci_set_target_start(start_pos)
            end_pos = 0
            view_win.sci_set_target_end(end_pos)
          else
            next
          end
        elsif key_str == "C-g"
          view_win.sci_goto_pos(orig_pos)
          break
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
          if backward == true
            view_win.sci_set_target_start(start_pos)
          end
          view_win.sci_set_target_end(end_pos)
        else
          if backward == true
            view_win.sci_goto_pos(view_win.sci_get_length)
          else
            view_win.sci_goto_pos(0)
          end
        end
        view_win.refresh
      end
      echo_win.sci_clear_all
      echo_win.refresh
    end
  end
end
