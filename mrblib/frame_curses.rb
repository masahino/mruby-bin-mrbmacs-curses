# Mrbmacs module
module Mrbmacs
  def self.find_common_prefix(comp_list)
    len = comp_list.map(&:length).min
    return nil if len.nil?

    (1..len).reverse_each do |i|
      if comp_list.map { |f| f[0..i] }.sort.uniq.size == 1
        return comp_list[0][0..i]
      end
    end
    nil
  end

  # Frame
  class Frame
    attr_reader :tk

    def initialize(buffer)
      ENV['TERM'] = 'xterm-256color' if ENV['TERM'].nil?
      print "\033[?1000h" # enable mouse
      #      @tk = TermKey.new(0, TermKey::FLAG_UTF8 | TermKey::FLAG_SPACESYMBOL)
      @tk = TermKey.new(0, TermKey::FLAG_UTF8)
      Curses.initscr
      Curses.raw
      Curses.noecho
      Curses.curs_set(0)
      Curses.keypad(Curses.stdscr, true)
      @keysyms = [0,
                  Scintilla::SCK_BACK,
                  Scintilla::SCK_TAB,
                  Scintilla::SCK_RETURN,
                  Scintilla::SCK_ESCAPE,
                  0,
                  Scintilla::SCK_BACK,
                  Scintilla::SCK_UP,
                  Scintilla::SCK_DOWN,
                  Scintilla::SCK_LEFT,
                  Scintilla::SCK_RIGHT,
                  0, 0,
                  Scintilla::SCK_INSERT,
                  Scintilla::SCK_DELETE,
                  0,
                  Scintilla::SCK_PRIOR,
                  Scintilla::SCK_NEXT,
                  Scintilla::SCK_HOME,
                  Scintilla::SCK_END]
      @sci_notifications = []
      @edit_win = EditWindowCurses.new(self, buffer, 0, 0, Curses.COLS, Curses.LINES - 1)
      @view_win = @edit_win.sci
      @mode_win = @edit_win.mode_win
      @echo_win = new_echowin
      @edit_win_list = [@edit_win]
    end

    def new_editwin(buffer, left, top, width, height)
      EditWindowCurses.new(self, buffer, left, top, width, height)
    end

    def new_echowin
      echo_win = Scintilla::ScintillaCurses.new do |msg|
        #        $stderr.puts "echo win callback #{msg}"
      end
      echo_win.sci_set_codepage(Scintilla::SC_CP_UTF8)
      echo_win.resize_window(1, Curses.COLS)
      echo_win.move_window(Curses.LINES - 1, 0)
      echo_win.sci_style_set_fore(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_WHITE)
      echo_win.sci_style_set_back(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_BLACK)
      echo_win.sci_style_clear_all
      echo_win.sci_set_focus(false)
      echo_win.sci_autoc_set_choose_single(1)
      echo_win.sci_autoc_set_auto_hide(false)
      echo_win.sci_set_margin_typen(3, 4)
      echo_win.sci_set_caretstyle Scintilla::CARETSTYLE_BLOCK_AFTER |
                                  Scintilla::CARETSTYLE_OVERSTRIKE_BLOCK |
                                  Scintilla::CARETSTYLE_BLOCK
      echo_win.sci_set_wrap_mode(Scintilla::SC_WRAP_CHAR)
      echo_win.sci_autoc_set_max_height(16) if Scintilla::PLATFORM != :CURSES_WIN32
      echo_win.refresh

      echo_win
    end

    def delete_other_window
      @edit_win_list.each do |w|
        w.delete if w != @edit_win
      end
      @edit_win_list.delete_if { |w| w != @edit_win }
      @edit_win.x1 = 0
      @edit_win.x2 = Curses.COLS - 1
      @edit_win.y1 = 0
      @edit_win.y2 = Curses.LINES - 1 - 1
      @edit_win.compute_area
      @edit_win.refresh
    end

    def get_edit_win_from_pos(line, col)
      @edit_win_list.each do |w|
        if line >= w.y1 && line <= w.y2 && col >= w.x1 && col <= w.x2
          return w
        end
      end
      nil
    end

    def waitkey(_win)
      if Scintilla::PLATFORM == :CURSES_WIN32
        c = Curses.wgetch(@mode_win)
        if c >= Curses::KEY_MIN && c <= Curses::KEY_MAX
          keyname = Curses.keyname(c).sub('KEY_', '').tr('()', '').capitalize
          return [TermKey::RES_KEY, @tk.strpkey(keyname, 0)]
        end
        @tk.push_bytes(c.chr('UTF-8'))
        ret, key = @tk.getkey
        if ret == TermKey::RES_AGAIN
          @tk.getkey
        else
          [ret, key]
        end
      else
        @tk.waitkey
      end
    end

    def strfkey(key)
      @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
    end

    def send_key(key, win = nil)
      win = @view_win if win.nil?

      mod_shift = (key.modifiers & TermKey::KEYMOD_SHIFT) > 0
      mod_ctrl = (key.modifiers & TermKey::KEYMOD_CTRL) > 0
      mod_alt = (key.modifiers & TermKey::KEYMOD_ALT) > 0
      case key.type
      when TermKey::TYPE_UNICODE
        c = key.code
      when TermKey::TYPE_FUNCTION
      when TermKey::TYPE_KEYSYM
        c = @keysyms[key.code]
      when TermKey::TYPE_MOUSE
        ev, button, line, col = @tk.interpret_mouse(key)
        time = Time.now
        millis = (time.to_i * 1000 + time.usec / 1000).to_i
        tmp_win = get_edit_win_from_pos(line, col)
        if tmp_win.sci != win && tmp_win != nil
          switch_window(tmp_win)
          win = tmp_win.sci
        end
        if $DEBUG
          $stderr.puts "ev = #{ev}, millis = #{millis}, button = #{button}, line = #{line - 1}, col = #{col - 1}"
          $stderr.puts "shift = #{mod_shift}, ctrl = #{mod_ctrl}, alt = #{mod_alt}"
        end
        win.send_mouse(ev, millis, button, line - 1, col - 1, mod_shift, mod_ctrl, mod_alt)
        return
      end
      win.send_key(c, mod_shift, mod_ctrl, mod_alt)
    end

    def modeline(app, edit_win = @edit_win)
      #      @mode_win.clear()
      win = edit_win.mode_win
      mode_str = get_mode_str(app)
      if mode_str.length < Curses.getmaxx(win) - 1
        mode_str += '-' * (Curses.getmaxx(win) - mode_str.length)
      else
        mode_str[Curses.getmaxx(win) - 1] = ' '
      end
      Curses.wmove(win, 0, 0)
      Curses.waddstr(win, mode_str)
      Curses.wrefresh(win)
    end

    def modeline_refresh(app)
      Curses.wclear(@mode_win)
      modeline(app)
    end

    def echo_puts(text)
      @echo_win.sci_clear_all
      echo_set_prompt('[Message]')
      if text != nil
        @echo_win.sci_add_text(text.bytesize, text)
      end
      @echo_win.refresh
    end

    def echo_gets(prompt, text = '', &block)
      @view_win.sci_set_focus(false)
      @view_win.refresh
      @echo_win.sci_set_focus(true)
      @echo_win.sci_clear_all
      echo_set_prompt(prompt)
      prefix_text = text
      @echo_win.sci_add_text(prefix_text.bytesize, prefix_text)
      @echo_win.refresh
      input_text = nil
      loop do
        ret, key = waitkey(@echo_win)
        break if ret != TermKey::RES_KEY

        key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == 'C-g'
          @echo_win.sci_clear_all
          @echo_win.sci_add_text('Quit')
          input_text = nil
          break
        end
        #        if key_str == "C-k"
        #          @echo_win.send_message(SCI_DELLINERIGHT)
        #          echo_set_prompt(prompt)
        #          @echo_win.refresh
        #          next
        #        end
        case key.code
        when TermKey::SYM_ENTER, TermKey::SYM_INSERT
          if !@echo_win.sci_autoc_active
            @echo_win.sci_autoc_cancel
            input_text = @echo_win.sci_get_line(0)
            break
          else
            send_key(key, @echo_win)
          end
        when TermKey::SYM_TAB
          input_text = @echo_win.sci_get_line(0)
          if !@echo_win.sci_autoc_active
            if block != nil
              @echo_win.sci_autoc_cancel
              @view_win.refresh
              Curses.wrefresh(@mode_win)
              comp_list, len = block.call(input_text)
              @echo_win.sci_autoc_show(len, comp_list)
            end
          else
            @echo_win.sci_autoc_cancel
            @view_win.refresh
            Curses.redrawwin(@mode_win)
            Curses.wrefresh(@mode_win)
            comp_list, len = block.call(input_text)
            common_str = Mrbmacs.find_common_prefix(comp_list.split(@echo_win.sci_autoc_get_separator.chr))
            if common_str != nil
              @echo_win.sci_autoc_cancel
              @echo_win.sci_add_text(common_str[len..-1].bytesize, common_str[len..-1])
              @echo_win.refresh
              len = common_str.length
            end
            @echo_win.sci_autoc_show(len, comp_list)

          end
        else
          send_key(key, @echo_win)
        end
        if @echo_win.sci_margin_get_text(0) == ''
          $stderr.puts 'lost echo prompt'
          echo_set_prompt(prompt)
        end
        @echo_win.refresh
      end
      @echo_win.sci_clear_all
      @echo_win.sci_set_focus(false)
      @echo_win.refresh
      @view_win.sci_set_focus(true)
      @view_win.refresh
      input_text
    end

    def echo_set_prompt(prompt)
      @echo_win.sci_set_margin_widthn(3, @echo_win.sci_text_width(Scintilla::STYLE_DEFAULT, prompt))
      @echo_win.sci_margin_set_text(0, prompt)
      @echo_win.refresh
    end

    def read_buffername(prompt)
      echo_gets(prompt)
    end

    def y_or_n(prompt)
      $stderr.puts prompt if $DEBUG
      @echo_win.sci_clear_all
      echo_set_prompt(prompt)
      _ret, key = waitkey(@echo_win)
      key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
      echo_set_prompt('')
      if key_str == 'Y' || key_str == 'y'
        true
      elsif key_str == 'C-g'
        false
      else
        false
      end
    end

    def select_buffer(default_buffername, buffer_list)
      echo_text = "Switch to buffer: (default #{default_buffername}) "
      buffername = echo_gets(echo_text, '') do |input_text|
        list = buffer_list.select { |b| b[0, input_text.length] == input_text }
        [list.join(@echo_win.sci_autoc_get_separator.chr), input_text.length]
      end
      buffername
    end

    def exit
      @view_win.delete
      Curses.noraw
      Curses.curs_set(1)
      Curses.endwin
      @tk.destroy
      print "\033[?1000l" # disable mouse
    end
  end
end
