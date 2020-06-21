module Mrbmacs
  class Application
    include Scintilla

    def add_buffer_to_frame(buffer)
    end

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
      mod_mask = @frame.view_win.sci_get_mod_event_mask
      @frame.view_win.sci_set_mod_event_mask(0)
      loop do
        doin()
        break if @frame.tk.buffer_remaining == @frame.tk.buffer_size
      end
      @frame.view_win.sci_set_mod_event_mask(mod_mask)
      current_pos = @frame.view_win.sci_get_current_pos
      pos1 = @frame.view_win.sci_bracematch(current_pos, 0)
      if pos1 != -1
        @frame.view_win.sci_brace_highlight(pos1, current_pos)
      else
        pos1 = @frame.view_win.sci_bracematch(current_pos - 1, 0)
        if pos1 != -1
          @frame.view_win.sci_brace_highlight(pos1, current_pos - 1)
        end
      end
      if @mark_pos != nil
        @frame.view_win.sci_set_anchor(@mark_pos)
      end
    end

    def editloop()
      if Scintilla::PLATFORM != :CURSES_WIN32
        add_io_read_event(STDIN) { |app, io| keyin }
      end
      @frame.view_win.refresh
      loop do
        # notification event
        while @frame.sci_notifications.length > 0
          e = @frame.sci_notifications.shift
          if @sci_handler[e['code']] != nil
            begin
              @sci_handler[e['code']].call(self, e)
            rescue => e
              @logger.error e.to_s
              @logger.error e.backtrace
              @frame.echo_puts e.to_s
            end
          end
        end
        @frame.view_win.refresh
        # set cursor pos for IME
        current_pos = @frame.view_win.sci_get_current_pos
        x = @frame.view_win.sci_point_x_from_position(0, current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, current_pos)
        @frame.view_win.setpos(y, x)
        @frame.view_win.sci_set_empty_selection(current_pos)

        if Scintilla::PLATFORM == :CURSES_WIN32
          keyin
        else
        # IO event
          readable, writable = IO.select(@readings)
          readable.each do |ri|
            if @io_handler[ri] != nil
              begin
                @io_handler[ri].call(self, ri)
              rescue => e
                @logger.error e.to_s
                @logger.error e.backtrace
                @frame.echo_puts(e.to_s)
              end
            end
          end
        end

        @frame.view_win.refresh
        @frame.modeline(self)
      end
    end
  end
end
