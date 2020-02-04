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

  SOLARIZED_COLOR_LIST = [
    [8,   0,  43,  54],
    [0,   7,  54,  66],
    [10,  88, 110, 117],
    [11, 101, 123, 131],
    [12, 131, 148, 150],
    [14, 147, 161, 161],
    [ 7, 238, 232, 213],
    [15, 253, 246, 227],
    [ 3, 181, 137,   0],
    [ 9, 203,  75,  22],
    [ 1, 220,  50,  47],
    [ 5, 211,  54, 130],
    [13, 108, 113, 196],
    [ 4,  38, 139, 210],
    [ 6,  42, 161, 152],
    [ 2, 133, 153,   0],
    ]

  def self.curses_init_color_rgb(n, r, g, b)
    Curses.init_color n, r*1000/255, g*1000/255, b*1000/255
  end

  class SolarizedDarkTheme < Theme
    def set_pallete
      SOLARIZED_COLOR_LIST.each do |c|
        Mrbmacs::curses_init_color_rgb(c[0], c[1], c[2], c[3])
      end
    end
  end

  class SolarizedLightTheme < Theme
    def set_pallete
      SOLARIZED_COLOR_LIST.each do |c|
        Mrbmacs::curses_init_color_rgb(c[0], c[1], c[2], c[3])
      end
    end
  end
end
