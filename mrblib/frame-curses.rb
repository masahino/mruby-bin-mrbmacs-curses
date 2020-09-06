# coding: utf-8
module Mrbmacs
  class Frame
    include Scintilla
    attr_accessor :view_win, :echo_win, :tk, :char_added
    attr_accessor :edit_win, :mode_win
    attr_accessor :edit_win_list

    def initialize(buffer)
      if ENV['TERM'] == nil
        ENV['TERM'] = 'xterm-256color'
      end
      print "\033[?1000h" # enable mouse
#      @tk = TermKey.new(0, TermKey::FLAG_UTF8 | TermKey::FLAG_SPACESYMBOL)
      @tk = TermKey.new(0, TermKey::FLAG_UTF8)
      Curses::initscr
      Curses::raw
      Curses::noecho
      Curses::curs_set(0)
      Curses::keypad(Curses::stdscr, true)
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
                  0,0,
                  Scintilla::SCK_INSERT,
                  Scintilla::SCK_DELETE,
                  0,
                  Scintilla::SCK_PRIOR,
                  Scintilla::SCK_NEXT,
                  Scintilla::SCK_HOME,
                  Scintilla::SCK_END]
      @sci_notifications = []
      @edit_win = EditWindowCurses.new(self, buffer, 0, 0, Curses.COLS, Curses.LINES-1)
      @view_win = @edit_win.sci
      @mode_win = @edit_win.mode_win
      @echo_win = new_echowin
      @edit_win_list = [@edit_win]
      @char_added = false
    end

    def new_editwin(buffer, x, y, width, height)
      EditWindowCurses.new(self, buffer, x, y, width, height)
    end

    def new_echowin
      echo_win = ScintillaCurses.new do |msg|
#        $stderr.puts "echo win callback #{msg}"
      end
      echo_win.sci_set_codepage(Scintilla::SC_CP_UTF8)
      echo_win.resize_window(1, Curses.COLS)
      echo_win.move_window(Curses.LINES-1, 0)
      echo_win.sci_style_set_fore(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_WHITE)
      echo_win.sci_style_set_back(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_BLACK)
      echo_win.sci_style_clear_all()
      echo_win.sci_set_focus(false)
      echo_win.sci_autoc_set_choose_single(1)
      echo_win.sci_autoc_set_auto_hide(false)
      echo_win.sci_set_margin_typen(3, 4)
      echo_win.refresh

      return echo_win
    end

    def delete_other_window
      @edit_win_list.each do |w|
        if w != @edit_win
          w.delete
        end
      end
      @edit_win_list.delete_if { |w| w != @edit_win }
      @edit_win.x1 = 0
      @edit_win.x2 = Curses.COLS
      @edit_win.y1 = 0
      @edit_win.y2 = Curses.LINES-1
      @edit_win.compute_area
      @edit_win.refresh
    end

    def get_edit_win_from_pos(line, col)
      @edit_win_list.each do |w|
        if line >= w.y1 and line <= w.y2 and col >= w.x1 and col <= w.x2
          return w
        end
      end
      return nil
    end

    def waitkey(win)
      if Scintilla::PLATFORM == :CURSES_WIN32
        c = Curses::wgetch(@mode_win)
        if c >= Curses::KEY_MIN and c <= Curses::KEY_MAX
          keyname = Curses::keyname(c).sub("KEY_", "").tr("()", "").capitalize
          return [TermKey::RES_KEY, @tk.strpkey(keyname, 0)]
        end
        @tk.push_bytes(c.chr("UTF-8"))
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
      if win == nil
        win = @view_win
      end
      mod_shift = (key.modifiers & TermKey::KEYMOD_SHIFT > 0)? true : false;
      mod_ctrl = (key.modifiers & TermKey::KEYMOD_CTRL > 0)? true : false;
      mod_alt = (key.modifiers & TermKey::KEYMOD_ALT > 0)? true : false;
      case key.type
      when TermKey::TYPE_UNICODE
        c = key.code
      when TermKey::TYPE_FUNCTION
      when TermKey::TYPE_KEYSYM
        c = @keysyms[key.code]
      when TermKey::TYPE_MOUSE
        ev, button, line, col = @tk.interpret_mouse(key)
        time = Time.now
        millis = (time.to_i * 1000 + time.usec/1000).to_i
        tmp_win = get_edit_win_from_pos(line, col)
        if tmp_win.sci != win and tmp_win != nil
          switch_window(tmp_win)
          win = tmp_win.sci
        end
        if $DEBUG
          $stderr.puts "ev = #{ev}, millis = #{millis}, button = #{button}, line = #{line-1}, col = #{col-1}"
          $stderr.puts "shift = #{mod_shift}, ctrl = #{mod_ctrl}, alt = #{mod_alt}"
        end
        win.send_mouse(ev, millis, button, line-1, col-1, mod_shift, mod_ctrl, mod_alt)
        return
      end
      win.send_key(c, mod_shift, mod_ctrl, mod_alt)
      if @tk.buffer_remaining == @tk.buffer_size
        pos1 = win.sci_brace_match(win.sci_get_current_pos() - 1, 0)
        if pos1 != -1 and (c == ')'.ord or c == ']'.ord or c == '}'.ord or c == '>'.ord)
          win.sci_brace_highlight(pos1, win.sci_get_current_pos() - 1)
        else
          win.sci_brace_highlight(-1, -1)
        end
      end
    end

    def modeline(app, win = @mode_win)
#      @mode_win.clear()
      mode_str = get_mode_str(app)
      if mode_str.length < Curses.getmaxx(win) - 1
        mode_str += "-" * (Curses.getmaxx(win) - mode_str.length - 1)
      else
        mode_str[Curses.getmaxx(win) - 1] = " "
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
      echo_set_prompt("[Message]")
      if text != nil
        @echo_win.sci_add_text(text.length, text)
      end
      @echo_win.refresh
    end

    def echo_gets(prompt, text = "", &block)
      @view_win.sci_set_focus(false)
      @view_win.refresh
      @echo_win.sci_set_focus(true)
      @echo_win.sci_clear_all
      echo_set_prompt(prompt)
      prefix_text = text
      @echo_win.sci_add_text(prefix_text.length, prefix_text)
      @echo_win.refresh
      input_text = nil
      last_input = nil
      while true
        ret, key = waitkey(@echo_win)
        if ret != TermKey::RES_KEY
          break
        end
        key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-g"
          @echo_win.sci_clear_all
          @echo_win.sci_add_text("Quit")
          input_text = nil
          break
        end
        if key_str == "C-k"
          @echo_win.send_message(SCI_DELLINERIGHT)
          echo_set_prompt(prompt)
          @echo_win.refresh
          next
        end
        case key.code
        when TermKey::SYM_ENTER, TermKey::SYM_INSERT
          if @echo_win.sci_autoc_active == 0
            @echo_win.sci_autoc_cancel
            input_text = @echo_win.sci_get_line(0)
            break
          else
            send_key(key, @echo_win)
          end
        when TermKey::SYM_TAB
          input_text = @echo_win.sci_get_line(0)
          if input_text != last_input or @echo_win.sci_autoc_active == 0
            if block != nil
              comp_list, len = block.call(input_text)
              @echo_win.sci_autoc_cancel
              @view_win.refresh
              Curses.wrefresh(@mode_win)
              @echo_win.sci_autoc_show(len, comp_list)
            end
          else
            current = @echo_win.sci_autoc_get_current
            @echo_win.sci_linedown
            if current == @echo_win.sci_autoc_get_current
              @echo_win.sci_vchome
            end
          end
        else
          send_key(key, @echo_win)
        end
        @echo_win.refresh
      end
      @echo_win.sci_clear_all
      @echo_win.sci_set_focus(false)
      @echo_win.refresh
      @view_win.sci_set_focus(true)
      @view_win.refresh
      return input_text
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
      if $DEBUG
        $stderr.puts prompt
      end
      @echo_win.sci_clear_all
      echo_set_prompt(prompt)
      ret, key = waitkey(@echo_win)
      key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
      echo_set_prompt("")
      if key_str == "Y" or key_str == "y"
        return true
      elsif key_str == "C-g"
        return false
      else
        return false
      end
    end

    def set_buffer_name(buffer_name)
    end

    def select_buffer(default_buffername, buffer_list)
      echo_text = "Switch to buffer: (default #{default_buffername}) "
      buffername = echo_gets(echo_text, "") do |input_text|
        list = buffer_list.select{|b| b[0, input_text.length] == input_text}
        [list.join(" "), input_text.length]
      end
      return buffername
    end

    def restore_colors
      default_color = [
        [0, 0, 0],
        [680, 0, 0],
        [0, 680, 0],
        [680, 680, 0],
        [0, 0, 680],
        [680, 0, 680],
        [0, 680, 680],
        [680, 680, 680],
        [0, 0, 0],
        [1000, 0, 0],
        [0, 1000, 0],
        [1000, 1000, 0],
        [0, 0, 1000],
        [1000, 0, 1000],
        [0, 1000, 1000],
        [1000, 1000, 1000]
        ]
      for i in 0..15
        Curses.init_color(i, default_color[i][0], default_color[i][1], default_color[i][2])
      end
    end

    def exit
      @view_win.delete
      restore_colors
      Curses::noraw
      Curses::curs_set(1)
      Curses::endwin
      @tk.destroy
      print "\033[?1000l" # disable mouse
    end
  end
end
