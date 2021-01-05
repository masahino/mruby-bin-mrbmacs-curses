module Mrbmacs
  class Application
    include Scintilla

    def add_buffer_to_frame(buffer)
    end

    def doscan(prefix)
      ret, key = @frame.waitkey(@frame.view_win)
      if ret != TermKey::RES_KEY
        return
      end
      key_str = prefix + @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
      key_str.gsub!(/^Escape /, "M-")
      if $DEBUG
        $stderr.puts '['+key_str+']'
      end
      command = key_scan(key_str)
      if command != nil
        if command.is_a?(Integer)
          return @frame.view_win.send_message(command, nil, nil)
        end
        if command == "prefix"
          return doscan(key_str + " ")
        else
          return extend(command)
        end
      end
      @frame.send_key(key)
    end

    def keyin()
      mod_mask = @frame.view_win.sci_get_mod_event_mask
      @frame.view_win.sci_set_mod_event_mask(0)
      loop do
        doscan("")
        break if @frame.tk.buffer_remaining == @frame.tk.buffer_size
      end
      @frame.view_win.sci_set_mod_event_mask(mod_mask)
      current_pos = @frame.view_win.sci_get_current_pos
      pos1 = @frame.view_win.sci_bracematch(current_pos, 0)
      if pos1 != -1
        @frame.view_win.sci_brace_highlight(pos1, current_pos)
      end
      pos1 = @frame.view_win.sci_bracematch(current_pos - 1, 0)
      if pos1 != -1
        @frame.view_win.sci_brace_highlight(pos1, current_pos - 1)
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
          if $DEBUG
            $stderr.puts e['code']
          end
          call_sci_event(e)
        end
        @frame.view_win.refresh
        # set cursor pos for IME
        current_pos = @frame.view_win.sci_get_current_pos
        x = @frame.view_win.sci_point_x_from_position(0, current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, current_pos)
        @frame.view_win.setpos(y, x)
#        @frame.view_win.sci_set_empty_selection(current_pos)

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
