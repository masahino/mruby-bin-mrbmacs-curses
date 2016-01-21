module Mrbmacs
  COLOR_BASE03 = Scintilla::COLOR_LIGHTBLACK
  COLOR_BASE02 = Scintilla::COLOR_BLACK
  COLOR_BASE01 = Scintilla::COLOR_LIGHTGREEN
  COLOR_BASE00 = Scintilla::COLOR_LIGHTYELLOW
  COLOR_BASE0  = Scintilla::COLOR_LIGHTBLUE
  COLOR_BASE1  = Scintilla::COLOR_LIGHTCYAN
  COLOR_BASE2  = Scintilla::COLOR_WHITE
  COLOR_BASE3  = Scintilla::COLOR_LIGHTWHITE
  COLOR_YELLOW = Scintilla::COLOR_YELLOW
  COLOR_ORANGE = Scintilla::COLOR_LIGHTRED
  COLOR_RED    = Scintilla::COLOR_RED
  COLOR_MAGENTA = Scintilla::COLOR_MAGENTA
  COLOR_VIOLET = Scintilla::COLOR_LIGHTMAGENTA
  COLOR_BLUE   = Scintilla::COLOR_BLUE
  COLOR_CYAN   = Scintilla::COLOR_CYAN
  COLOR_GREEN  = Scintilla::COLOR_GREEN
  class << self
    def set_pallete
      color_list = [235, 160, 64, 136, 33, 125, 37, 254,
                    234, 166, 240, 241, 244, 61, 245, 230]
      Scintilla::ScinTerm.set_pallete(color_list)
    end
  end

end
