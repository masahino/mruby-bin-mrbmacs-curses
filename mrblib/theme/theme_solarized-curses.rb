module Mrbmacs
  def self.curses_init_color_rgb(n, r, g, b)
    if Curses.can_change_color == true
      Curses.init_color n, r * 1000 / 255, g * 1000 / 255, b * 1000 / 255
    end
  end

  class SolarizedTheme < Theme
    def set_pallete
      @@base03 = Scintilla::COLOR_LIGHTBLACK
      @@base02 = Scintilla::COLOR_BLACK
      @@base01 = Scintilla::COLOR_LIGHTGREEN
      @@base00 = Scintilla::COLOR_LIGHTYELLOW
      @@base0  = Scintilla::COLOR_LIGHTBLUE
      @@base1  = Scintilla::COLOR_LIGHTCYAN
      @@base2  = Scintilla::COLOR_WHITE
      @@base3  = Scintilla::COLOR_LIGHTWHITE
      @@yellow = Scintilla::COLOR_YELLOW
      @@orange = Scintilla::COLOR_LIGHTRED
      @@red    = Scintilla::COLOR_RED
      @@magenta = Scintilla::COLOR_MAGENTA
      @@violet = Scintilla::COLOR_LIGHTMAGENTA
      @@blue   = Scintilla::COLOR_BLUE
      @@cyan   = Scintilla::COLOR_CYAN
      @@green  = Scintilla::COLOR_GREEN

      solarized_color_list = [
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
        [ 2, 133, 153,   0]
      ]
      solarized_color_list.each do |c|
        Mrbmacs.curses_init_color_rgb(c[0], c[1], c[2], c[3])
      end
    end
  end
end
