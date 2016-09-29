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
        x = @frame.view_win.sci_point_x_from_position(0, @frame.view_win.sci_get_current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, @frame.view_win.sci_get_current_pos)
        @frame.view_win.setpos(y, x)
        @frame.view_win.sci_set_empty_selection(@frame.view_win.sci_get_current_pos)
        doin()
        if @mark_pos != nil
          @frame.view_win.sci_set_anchor(@mark_pos)
        end
        if @frame.tk.buffer_remaining == @frame.tk.buffer_size
          @frame.view_win.refresh
          @frame.modeline(self)
        end
      end
    end
  end
end
