module Mrbmacs
  class EditWindowCurses < EditWindow
    def initialize(frame, buffer, left, top, width, height)
      super(frame, buffer, left, top, width, height)
      @sci = Scintilla::ScintillaCurses.new do |scn|
        # code = scn['code']
        # @frame.sci_notifications.delete_if { |n| n['code'] == code }
        @frame.sci_notifications.push(scn)
      end
      @sci.resize_window(@height - 1, @width)
      @sci.move_window(@y1, @x1)
      init_sci_default
      set_margin_curses

      @sci.sci_set_focus(true)
      @sci.refresh
      init_buffer(buffer)

      # create @mode_win
      @mode_win = create_mode_win
      # Curses.newwin(1, width, y1 + height - 1, x1)
      # Curses.keypad(@mode_win, true)
      # Curses.wbkgd(@mode_win, Curses::A_REVERSE)
      # Curses.wrefresh(@mode_win)
    end

    def create_mode_win
      win = Curses.newwin(1, @width, @y1 + @height - 1, @x1)
      Curses.keypad(win, true)
      Curses.wbkgd(win, Curses::A_REVERSE)
      Curses.wrefresh(win)
      return win
    end

    def set_margin_curses
      set_margin
      # @sci.sci_set_margin_widthn(0, @sci.sci_text_width(Scintilla::STYLE_LINENUMBER, "_99999"))
      @sci.sci_set_margin_maskn(MARGIN_LINE_NUMBER, ~Scintilla::SC_MASK_FOLDERS)
      @sci.sci_set_margin_widthn(MARGIN_FOLDING, 1)
      @sci.sci_set_margin_typen(MARGIN_FOLDING, 0)
      # @sci.sci_set_margin_maskn(1, Scintilla::SC_MASK_FOLDERS)
      # @sci.sci_set_marginsensitiven(1, 1)
      # @sci.sci_set_automatic_fold(Scintilla::SC_AUTOMATICFOLD_CLICK)
    end

    def delete
      @sci.delete
      Curses.delwin(@mode_win)
    end

    def compute_area
      @width = @x2 - @x1 + 1
      @height = @y2 - @y1 + 1
      @sci.move_window(@y1, @x1)
      @sci.resize_window(@height - 1, @width)
      Curses.mvwin(@mode_win, @y2, @x1)
      Curses.wresize(@mode_win, 1, @width)
    end

    def refresh
      @sci.refresh
      Curses.wrefresh(@mode_win)
    end

    def focus_in
      @sci.sci_set_focus(true)
      Curses.wbkgd(@mode_win, Curses::A_REVERSE)
      @sci.refresh
    end

    def focus_out
      @sci.sci_set_focus(false)
      @sci.refresh
      Curses.wbkgd(@mode_win, Curses::A_DIM)
      Curses.wrefresh(@mode_win)
    end

    def apply_theme(theme)
      apply_theme_base(theme)
      @sci.sci_set_fold_margin_colour(true, theme.background_color)
      @sci.sci_set_fold_margin_hicolour(true, theme.foreground_color)
      for n in 25..31
        @sci.sci_marker_set_fore(n, theme.foreground_color)
        @sci.sci_marker_set_back(n, theme.background_color)
      end
    end
  end
end
