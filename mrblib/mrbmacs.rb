module Mrbmacs
  class Application
    include Scintilla

    def doscan(prefix)
      ret, key = @frame.waitkey(@frame.view_win)
      if ret != TermKey::RES_KEY
        return [nil, nil]
      end
      key_str = prefix + @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
      if $DEBUG
        $stderr.puts '['+key_str+']'
      end
      key_str.gsub!(/^Escape /, "M-")

      if @command_list.has_key?(key_str)
        if @command_list[key_str] == "prefix"
          return doscan(key_str + " ")
        else
          return [key, @command_list[key_str]]
        end
      end
      [key, nil]
    end

    def editloop()
      @frame.view_win.refresh
      while true do
        current_pos = @frame.view_win.sci_get_current_pos
        x = @frame.view_win.sci_point_x_from_position(0, current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, current_pos)
        @frame.view_win.setpos(y, x)
        @frame.view_win.sci_set_empty_selection(current_pos)
        doin()
        if @frame.tk.buffer_remaining == @frame.tk.buffer_size
          current_pos = @frame.view_win.sci_get_current_pos
          pos1 = @frame.view_win.sci_bracematch(current_pos, 0)
          if pos1 != -1
            @frame.view_win.sci_brace_highlight(pos1, current_pos)
          end
          if @mark_pos != nil
            @frame.view_win.sci_set_anchor(@mark_pos)
          end
          # autocomp
          if @frame.view_win.sci_autoc_active == 0 and @frame.char_added == true
            len, candidates = @current_buffer.mode.get_completion_list(@frame.view_win)
            if len > 0
              @frame.view_win.sci_autoc_show(len, candidates)
            end
            @frame.char_added = false
          end
          @frame.view_win.refresh
          @frame.modeline(self)
        end
      end
    end
  end
end
