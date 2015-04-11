module Scimre
  COLOR_BASE03 = Scintilla::COLOR_BLACK
  COLOR_BASE02 = Scintilla::COLOR_RED
  COLOR_BASE01 = Scintilla::COLOR_GREEN
  COLOR_BASE00 = Scintilla::COLOR_YELLOW
  COLOR_BASE0  = Scintilla::COLOR_BLUE
  COLOR_BASE1  = Scintilla::COLOR_MAGENTA
  COLOR_BASE2  = Scintilla::COLOR_CYAN
  COLOR_BASE3  = Scintilla::COLOR_WHITE
  COLOR_YELLOW = Scintilla::COLOR_LIGHTBLACK
  COLOR_ORANGE = Scintilla::COLOR_LIGHTRED
  COLOR_RED    = Scintilla::COLOR_LIGHTGREEN
  COLOR_MAGENTA = Scintilla::COLOR_LIGHTYELLOW
  COLOR_VIOLET = Scintilla::COLOR_LIGHTBLUE
  COLOR_BLUE   = Scintilla::COLOR_LIGHTMAGENTA
  COLOR_CYAN   = Scintilla::COLOR_LIGHTCYAN
  COLOR_GREEN  = Scintilla::COLOR_LIGHTWHITE
  class << self
    def use_solarized
      color_list = [234, 235, 239, 240, 244, 245, 187, 230,
                    136, 166, 124, 125,  61,  33,  37, 64]
      Scintilla::ScinTerm.set_pallete(color_list)
    end
  end
end
