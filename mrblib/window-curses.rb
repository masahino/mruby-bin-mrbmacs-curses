# coding: utf-8
module Mrbmacs
  class EditWindow
    attr_accessor :sci, :frame
    attr_accessor :buffer, :x1, :y1, :width, :height
    def initialize(frame, buffer, x1, y1, width, height)
      @frame = frame
      @sci = Scintilla::ScinTerm.new do |msg|
        if msg == Scintilla::SCN_CHARADDED
          @frame.char_added = true
        end
        if $DEBUG
          $stderr.puts "sci callback #{msg}"
        end
      end
      @buffer = buffer
      @x1 = x1
      @y1 = y1
      @width = width
      @height = height
      @sci.resize_window(height, width)
      @sci.move_window(x1, y1)

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
    end
  end
end