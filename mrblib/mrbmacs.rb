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

    def keyin()
      loop do
        doin()
        break if @frame.tk.buffer_remaining == @frame.tk.buffer_size
      end
      current_pos = @frame.view_win.sci_get_current_pos
      pos1 = @frame.view_win.sci_bracematch(current_pos, 0)
      if pos1 != -1
        @frame.view_win.sci_brace_highlight(pos1, current_pos)
      end
      pos1 = @frame.view_win.sci_bracematch(current_pos - 1, 0)
      if pos1 != -1
        @frame.view_win.sci_brace_highlight(pos1, current_pos - 1)
      end
      if @mark_pos != nil
        @frame.view_win.sci_set_anchor(@mark_pos)
      end
    end

    def editloop()
      add_io_read_event(STDIN) { |app, io| keyin }
      @frame.view_win.refresh
      loop do
        while @frame.sci_notifications.length > 0
          e = @frame.sci_notifications.shift
          if @sci_handler[e['code']] != nil
            @sci_handler[e['code']].call(self, e)
          end
        end
        @frame.view_win.refresh
        # set cursor pos for IME
        current_pos = @frame.view_win.sci_get_current_pos
        x = @frame.view_win.sci_point_x_from_position(0, current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, current_pos)
        @frame.view_win.setpos(y, x)
        @frame.view_win.sci_set_empty_selection(current_pos)

        readable, writable = IO.select(@readings)
        readable.each do |ri|
          if @io_handler[ri] != nil
            @io_handler[ri].call(self, ri)
          end
        end

        @frame.view_win.refresh
        @frame.modeline(self)
      end
    end
  end
end
