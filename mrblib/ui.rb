# coding: utf-8
module Scimre
  class Frame
    include Scintilla
    attr_accessor :view_win, :echo_win, :tk

    def initialize
      Curses::initscr
      Curses::raw
      Curses::curs_set(0)
      @tk = TermKey.new(0, TermKey::FLAG_UTF8)
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
      Scimre::use_solarized
      @view_win.resize_window(Curses::lines - 2, Curses::cols)

      @view_win.set_codepage(Scintilla::SC_CP_UTF8)

      #      @view_win.style_set_fore(Scintilla::STYLE_DEFAULT, COLOR_WHITE)
      @view_win.style_set_fore(Scintilla::STYLE_DEFAULT, COLOR_BASE0)
      #      @view_win.style_set_back(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_BLACK)
      @view_win.style_set_back(Scintilla::STYLE_DEFAULT, COLOR_BASE03)
      @view_win.style_clear_all()
      @view_win.set_margin_widthn(0, @view_win.text_width(Scintilla::STYLE_LINENUMBER, "_99999"))
      @view_win.style_set_fore(Scintilla::STYLE_LINENUMBER, COLOR_BASE0)
      @view_win.style_set_back(Scintilla::STYLE_LINENUMBER, COLOR_BASE02)
      @view_win.set_margin_maskn(0, ~Scintilla::SC_MASK_FOLDERS)
      @view_win.set_margin_widthn(1, 1)
      @view_win.set_margin_typen(1, 0)
      @view_win.set_margin_maskn(1, Scintilla::SC_MASK_FOLDERS)
      
      @view_win.style_set_back(STYLE_BRACELIGHT, COLOR_LIGHTCYAN)
      
      @view_win.set_focus(true)
      @view_win.refresh

      @mode_win = Curses::Window.new(1, Curses::cols, Curses::lines-2, 0)
      @mode_win.bkgd(Curses::A_REVERSE)
      @mode_win.refresh 
      @echo_win = ScinTerm.new do |msg|
#        $stderr.puts "echo win callback #{msg}"
      end
      @echo_win.set_codepage(Scintilla::SC_CP_UTF8)
      @echo_win.resize_window(1, Curses::cols)
      @echo_win.move_window(Curses::lines-1, 0)
      @echo_win.style_set_fore(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_WHITE)
      @echo_win.style_set_back(Scintilla::STYLE_DEFAULT, Scintilla::COLOR_BLACK)
      @echo_win.style_clear_all()
      @echo_win.set_focus(false)
      @echo_win.auto_cset_choose_single(1)
      @echo_win.auto_cset_auto_hide(false)
      @echo_win.refresh
    end

    def send_key(key, win = nil)
      mod_shift = (key.modifiers & TermKey::KEYMOD_SHIFT > 0)? true : false;
      mod_ctrl = (key.modifiers & TermKey::KEYMOD_CTRL > 0)? true : false;
      mod_alt = (key.modifiers & TermKey::KEYMOD_ALT > 0)? true : false;
      case key.type
      when TermKey::TYPE_UNICODE
        c = key.code
      when TermKey::TYPE_FUNCTION
      when TermKey::TYPE_KEYSYM
        c = @keysyms[key.code]
      end
      if win == nil
        @view_win.send_key(c, mod_shift, mod_ctrl, mod_alt)
      else
        win.send_key(c, mod_shift, mod_ctrl, mod_alt)
      end
    end

    def modeline(app)
      @mode_win.clear()
      @mode_win.move(0, 0)
      mode_text = " -:"
      if @view_win.get_modify != 0
        mode_text += "**-"
      else
        mode_text += "---"
      end
      mode_text += sprintf("    %-20s", app.current_buffer.name)
      x = @view_win.get_column(@view_win.get_current_pos)+1
      y = @view_win.line_from_position(@view_win.get_current_pos)+1
      mode_text += sprintf("%-10s", "(#{x},#{y})")
      mode_text += "["+app.mode.name+"]"
      @mode_win.addstr(mode_text)
      @mode_win.refresh
    end

    def echo_gets(prompt, text = "", &block)
      @view_win.set_focus(false)
      @view_win.refresh
      @echo_win.set_focus(true)
      @echo_win.clear_all
      prefix_text = prompt + text
      @echo_win.add_text(prefix_text.length, prefix_text)
      @echo_win.refresh
      input_text = nil
      while true
        ret, key = @tk.waitkey
        key_str = @tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
        if key_str == "C-g"
          @echo_win.clear_all
          @echo_win.add_text("Quit")
          break
        end
        case key.code
        when TermKey::SYM_ENTER
          if @echo_win.autoc_active == 0
            @echo_win.autoc_cancel
            input_text = @echo_win.get_line(0)[prompt.length..-1]
            break
          else
            cur_text = @echo_win.autoc_get_current_text()
            if cur_text != nil
              @echo_win.add_text(cur_text.length, cur_text)
            end
            @echo_win.autoc_cancel
            @view_win.refresh
            @mode_win.refresh
#            send_key(key, echo_win)
          end
        when TermKey::SYM_TAB
          if @echo_win.autoc_active == 0
            input_text = @echo_win.get_line(0)[prompt.length..-1]
            if block != nil
              comp_list = block.call(input_text)
              len = input_text.length - text.length
              if len < 0
                len = input_text.length
              end
              @echo_win.autoc_cancel
              @view_win.refresh
              @mode_win.refresh
              @echo_win.autoc_show(len, comp_list)
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
      @echo_win.clear_all
      @echo_win.set_focus(false)
      @echo_win.refresh
      @view_win.set_focus(true)
      @view_win.refresh
      return input_text
    end

    def read_buffername(prompt)
      echo_gets(prompt)
    end

    def exit
      Curses::noraw
      Curses::curs_set(1)
      Curses::endwin
    end
  end
end
