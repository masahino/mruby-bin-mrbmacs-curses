module Mrbmacs
  class ApplicationCurses < Application
    def copy_region()
      super
      str = @frame.view_win.get_clipboard
      if Scintilla::PLATFORM == :CURSES_WIN32
        IO.popen('clip.exe', 'r+') {|f| f << str}
      else
        # try pbcopy
        ret = `type pbcopy 2>/dev/null`
        if $?.exitstatus == 0
          IO.popen('pbcopy', 'w') {|f| f << str}
        end
      end
    end

    def yank()
      if @frame.view_win.get_clipboard == ""
        ret = `type pbpaste 2>/dev/null`
        if $?.exitstatus == 0
          clipboard_text = `pbpaste`
          @frame.view_win.sci_copytext(clipboard_text.bytesize, clipboard_text)
        end
      end
      @frame.view_win.sci_paste
    end

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
        key_str = @frame.strfkey(key)
        if key_str == "C-s"
          if search_text != ""
            backward = false
            view_win.sci_set_target_start(view_win.sci_get_current_pos)
            end_pos = view_win.sci_get_length
            view_win.sci_set_target_end(end_pos)
          else
            search_text = @last_search_text
            @frame.echo_win.sci_add_text(search_text.bytesize, search_text)
            @frame.echo_win.refresh
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
            search_text = @last_search_text
            @frame.echo_win.sci_add_text(search_text.bytesize, search_text)
            @frame.echo_win.refresh
          end
        elsif key_str == "C-g"
          view_win.sci_goto_pos(orig_pos)
          break
        elsif key_str =~ /^[CM]-/
    #    elsif (key.modifiers & TermKey::KEYMOD_CTRL > 0) or (key.modifiers & TermKey::KEYMOD_ALT > 0)
          break
        else
          @frame.send_key(key, echo_win)
          echo_win.refresh
          search_text = @frame.echo_win.sci_get_text(@frame.echo_win.sci_get_length+1)
          @last_search_text = search_text
        end
        ret = view_win.sci_search_in_target(search_text.bytesize, search_text)
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
