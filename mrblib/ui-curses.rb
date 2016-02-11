# coding: utf-8
module Mrbmacs
  class Frame
    include Scintilla
    attr_accessor :view_win, :echo_win, :tk

    def initialize
      print "\033[?1000h" # enable mouse
      @tk = TermKey.new(0, TermKey::FLAG_UTF8)
      Curses::initscr
      Curses::raw
      Curses::curs_set(0)
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


      @view_win = ScinTerm.new do |msg|
        if $DEBUG
          $stderr.puts "sci callback #{msg}"
        end
#        if msg == SCN_CHARADDED
#          pos = @view_win.brace_match(@view_win.get_current_pos, 0)
#          if pos != -1
#            @view_win.brace_highlight(pos, @view_win.get_current_pos)
#          end
#        end
      end
      @view_win.resize_window(Curses::lines - 2, Curses::cols)

      @view_win.sci_set_codepage(Scintilla::SC_CP_UTF8)

      @view_win.sci_set_margin_widthn(0, @view_win.sci_text_width(Scintilla::STYLE_LINENUMBER, "_99999"))
      @view_win.sci_set_margin_maskn(0, ~Scintilla::SC_MASK_FOLDERS)
      @view_win.sci_set_margin_widthn(1, 1)
      @view_win.sci_set_margin_typen(1, 0)
      @view_win.sci_set_margin_maskn(1, Scintilla::SC_MASK_FOLDERS)
      
      @view_win.sci_set_focus(true)
      @view_win.refresh

      @mode_win = Curses::Window.new(1, Curses::cols, Curses::lines-2, 0)
      @mode_win.bkgd(Curses::A_REVERSE)
      @mode_win.refresh 
      @echo_win = ScinTerm.new do |msg|
#        $stderr.puts "echo win callback #{msg}"
      end
      @echo_win.sci_set_codepage(Scintilla::SC_CP_UTF8)
      @echo_win.resize_window(1, Curses::cols)
      @echo_win.move_window(Curses::lines-1, 0)
      @echo_win.sci_style_set_fore(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_WHITE)
      @echo_win.sci_style_set_back(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_BLACK)
      @echo_win.sci_style_clear_all()
      @echo_win.sci_set_focus(false)
      @echo_win.sci_auto_cset_choose_single(1)
      @echo_win.sci_auto_cset_auto_hide(false)
      @echo_win.refresh
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
        if $DEBUG
          $stderr.puts "ev = #{ev}, button = #{button}, line = #{line}, col = #{col}"
        end
        win.send_mouse(ev, 0, button, line-1, col-1, mod_shift, mod_ctrl, mod_alt)
        return
      end
      win.send_key(c, mod_shift, mod_ctrl, mod_alt)
#      win.refresh
      pos1 = win.sci_brace_match(win.sci_get_current_pos()-1, 0)
      # $stderr.puts "cur = #{@view_win.get_current_pos()}, pos1 = #{pos1}"
      if pos1 != -1 and c == ')'.ord or c == ']'.ord or c == '}'.ord or c == '>'.ord
        win.sci_brace_highlight(pos1, win.sci_get_current_pos()-1)
      else
        win.sci_brace_highlight(-1, -1)
      end
    end

    def modeline(app)
      @mode_win.clear()
      @mode_win.move(0, 0)
      @mode_win.addstr(get_mode_str(app))
      @mode_win.refresh
    end

    def echo_gets(prompt, text = "", &block)
      @view_win.sci_set_focus(false)
      @view_win.refresh
      @echo_win.sci_set_focus(true)
      @echo_win.sci_clear_all
      prefix_text = prompt + text
      @echo_win.sci_add_text(prefix_text.length, prefix_text)
      @echo_win.refresh
      input_text = nil
      while true
        ret, key = @tk.waitkey
        key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-g"
          @echo_win.sci_clear_all
          @echo_win.sci_add_text("Quit")
          input_text = nil
          break
        end
        case key.code
        when TermKey::SYM_ENTER
          if @echo_win.sci_autoc_active == 0
            @echo_win.sci_autoc_cancel
            input_text = @echo_win.sci_get_line(0)[prompt.length..-1]
            break
          else
#            cur_text = @echo_win.sci_autoc_get_current_text()
#            if cur_text != nil
#              @echo_win.sci_add_text(cur_text.length, cur_text)
#            end
#            @echo_win.sci_autoc_cancel
#            @view_win.refresh
#            @mode_win.refresh
            send_key(key, echo_win)
          end
        when TermKey::SYM_TAB
          if @echo_win.sci_autoc_active == 0
            input_text = @echo_win.sci_get_line(0)[prompt.length..-1]
            if block != nil
              comp_list, len = block.call(input_text)
#              len = input_text.length - text.length
#              if len < 0
#                len = input_text.length
#                len = 0
#              end
              @echo_win.sci_autoc_cancel
              @view_win.refresh
              @mode_win.refresh
              @echo_win.sci_autoc_show(len, comp_list)
            end
          else
            send_key(key, echo_win)
          end
        else
          send_key(key, echo_win)
#          if @echo_win.autoc_active != 0
 #           @echo_win.autoc_cancel()
#            $stderr.puts "autoc_active = #{@echo_win.autoc_active}"
#          end
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

    def read_buffername(prompt)
      echo_gets(prompt)
    end

    def exit
      @view_win.delete
      Curses::noraw
      Curses::curs_set(1)
      Curses::endwin
      print "\033[?1000l" # disable mouse
    end
  end
end
