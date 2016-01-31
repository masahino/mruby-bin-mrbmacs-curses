module Mrbmacs
  class Application
    include Scintilla

    def doscan(prefix)
      ret, key = @frame.tk.waitkey
      key_str = prefix + @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
      if $DEBUG
        $stderr.puts '['+key_str+']'
      end
      if @command_list.has_key?(key_str)
        if @command_list[key_str] == "prefix"
          return doscan(key_str + " ")
        else
          return [key, @command_list[key_str]]
        end
      end
      [key, nil]
    end

    def run(file = nil)
      if file != nil
        buffer = Mrbmacs::Buffer.new(file)
        @current_buffer = buffer
        Mrbmacs::load_file(self, file)
        @mode = Mrbmacs::Mode.set_mode_by_filename(file)
        @frame.view_win.sci_set_lexer_language(@mode.name)
        if $DEBUG
          $stderr.puts "["+@frame.view_win.sci_get_lexer_language()+"]"
        end
        @frame.view_win.sci_style_set_fore(Scintilla::STYLE_DEFAULT, @theme.foreground_color)
        @frame.view_win.sci_style_set_back(Scintilla::STYLE_DEFAULT, @theme.background_color)
        @frame.view_win.sci_style_clear_all
        @mode.set_style(@frame.view_win, @theme)
        @frame.view_win.sci_set_sel_back(true, 0xff0000)
        @frame.view_win.refresh
        @filename = file
      else
        buffer = Mrbmacs::Buffer.new(nil)
        @current_buffer = buffer
      end
      buffer.docpointer = @frame.view_win.sci_get_docpointer()
      @prev_buffer = buffer
      @buffer_list.push(buffer)
      @frame.modeline(self)

      command_mode = nil
      prefix_key = ""
      while true do
        x = @frame.view_win.sci_point_x_from_position(0, @frame.view_win.sci_get_current_pos)
        y = @frame.view_win.sci_point_y_from_position(0, @frame.view_win.sci_get_current_pos)
        @frame.view_win.setpos(y, x)
        doin()
              if @mark_pos != nil
                @frame.view_win.sci_set_anchor(@mark_pos)
              end
        @frame.view_win.refresh
        @frame.modeline(self)
        next
      end
    end
  end
end
