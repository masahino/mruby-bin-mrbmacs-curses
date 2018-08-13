# coding: utf-8
module Mrbmacs
  class EditWindow
     def initialize(frame, buffer, x1, y1, width, height)
      @frame = frame
      @sci = Scintilla::ScintillaCurses.new do |msg|
        if msg == Scintilla::SCN_CHARADDED
          @frame.char_added = true
        end
        if $DEBUG
          $stderr.puts "sci(#{@sci}) callback #{msg}"
        end
      end
      @buffer = buffer
      @x1 = x1
      @y1 = y1
      @x2 = x1 + width
      @y2 = y1 + height
      @width = width
      @height = height
      @sci.resize_window(@height - 1, @width)
      @sci.move_window(@y1, @x1)

      @sci.sci_set_codepage(Scintilla::SC_CP_UTF8)

      @sci.sci_set_margin_widthn(0, @sci.sci_text_width(Scintilla::STYLE_LINENUMBER, "_99999"))
      @sci.sci_set_margin_maskn(0, ~Scintilla::SC_MASK_FOLDERS)
      @sci.sci_set_margin_widthn(1, 1)
      @sci.sci_set_margin_typen(1, 0)
      @sci.sci_set_margin_maskn(1, Scintilla::SC_MASK_FOLDERS)

      @sci.sci_set_marginsensitiven(1, 1)
      @sci.sci_set_automatic_fold(Scintilla::SC_AUTOMATICFOLD_CLICK)
      @sci.sci_set_focus(true)
      @sci.refresh

      set_buffer(buffer)
      @modeline = Curses.newwin(1, width, y1 + height - 1, x1)
      Curses.wbkgd(@modeline, Curses::A_REVERSE)
      Curses.wrefresh(@modeline)
    end

    def delete
      @sci.delete
      Curses.delwin(@modeline)
    end

    def compute_area
      @width = @x2 - @x1
      @height = @y2 - @y1
      @sci.move_window(@y1, @x1)
      @sci.resize_window(@height - 1, @width)
      Curses.mvwin(@modeline, @y2-1, @x1)
      Curses.wresize(@modeline, 1, @width)
     end

    def refresh
      @sci.refresh
      Curses.refresh(@modeline)
    end

    def focus_in()
      @sci.sci_set_focus(true)
      Curses.wbkgd(@modeline,
        Curses.color_pair(Scintilla::ScintillaCurses.color_pair(0, 15)))
      @sci.refresh
    end

    def focus_out()
      @sci.sci_set_focus(false)
      @sci.refresh
      Curses.wbkgd(@modeline,
        Curses.color_pair(Scintilla::ScintillaCurses.color_pair(15, 10)))
      Curses.wrefresh(@modeline)
    end
  end
end