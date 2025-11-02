module Mrbmacs
  # ApplicationCurses
  class ApplicationCurses < ApplicationTerminal
    def add_buffer_to_frame(buffer)
    end

    def doscan(prefix)
      ret, key = @frame.waitkey(@frame.view_win)
      return if ret != TermKey::RES_KEY

      key_str = @frame.strfkey(key)
      if $DEBUG
        $stderr.puts "[#{key_str}]"
      end

      add_recent_key(key_str)
      key_str = prefix + key_str
      key_str.gsub!(/^Escape /, 'M-')
      command = key_scan(key_str)

      if command.nil?
        @frame.send_key(key)
      elsif command.is_a?(Integer)
        @frame.view_win.send_message(command, nil, nil)
      elsif command == 'prefix'
        doscan("#{key_str} ")
      else
        extend(command)
      end
    end

    def keyin
      loop do
        doscan('')
        break if @frame.tk.buffer_remaining == @frame.tk.buffer_size
      end
    end

    def editloop
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

        if Scintilla::PLATFORM == :CURSES_WIN32
          keyin
        else
          # IO event
          readable, _writable = IO.select(@readings)
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
