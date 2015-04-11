module Scimre
  class << self
    def set_mark(app)
      app.mark_pos = app.frame.view_win.get_current_pos
    end
    
    
    def copy_region(app)
      win = app.frame.view_win
      win.copy_range(app.mark_pos, win.get_current_pos)
      app.mark_pos = nil
    end

    def cut_region(app)
      win = app.frame.view_win
      win.copy_range(app.mark_pos, win.get_current_pos)
      win.delete_range(app.mark_pos, win.get_current_pos - app.mark_pos)
      app.mark_pos = nil
    end

    def kill_line(app)
      win = app.frame.view_win
      current_pos = win.get_current_pos
      line = win.line_from_position(current_pos)
      line_end_pos = win.get_line_end_position(line)
      if win.get_line(line) != "\n"
        win.copy_range(current_pos, line_end_pos)
        win.delete_range(current_pos, line_end_pos-current_pos)
      else
        win.line_cut
      end
    end
    
    def isearch_forward(app)
      prompt = "I-search: "
      view_win = app.frame.view_win
      echo_win = app.frame.echo_win
      echo_win.clear_all
      echo_win.add_text(prompt.length, prompt)
      echo_win.refresh
      view_win.set_target_end(view_win.get_length)
      search_text = ""
      while true
        ret, key = app.frame.tk.waitkey
        key_str = app.frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-s"
          if search_text != ""
            view_win.set_target_start(view_win.get_current_pos)
          else
            next
          end
        elsif (key.modifiers & TermKey::KEYMOD_CTRL > 0) or (key.modifiers & TermKey::KEYMOD_ALT > 0)
          break
        else
          app.frame.send_key(key, echo_win)
          echo_win.refresh
          search_text += key_str #echo_win.get_line(0)[prompt.length..-1]
        end
        ret = view_win.search_in_target(search_text.length, search_text)
        if ret != -1
          view_win.set_sel(view_win.get_target_start, view_win.get_target_end)
          view_win.set_target_end(view_win.get_length)
        end
        view_win.refresh
      end
      echo_win.clear_all
      echo_win.refresh
    end

    def indent(app)
      win = app.frame.view_win
      line = win.line_from_position(win.get_current_pos())
      level = win.get_fold_level(line) & Scintilla::SC_FOLDLEVELNUMBERMASK - Scintilla::SC_FOLDLEVELBASE
      level = app.mode.get_indent_level(win)
      indent = win.get_indent()*level
      win.set_line_indentation(line, indent)
      if win.get_column(win.get_current_pos) < indent
        win.goto_pos(win.position_from_line(line)+indent)
      end
    end

    def beginning_of_buffer(app)
      win = app.frame.view_win
      win.document_start
    end

    def end_of_buffer(app)
      win = app.frame.view_win
      win.document_end
    end

    def newline(app)
      win = app.frame.view_win
      win.new_line
      indent(app)
    end

    def save_buffers_kill_terminal(app)
      app.frame.exit
      exit
    end

  end
end
