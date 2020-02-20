module Mrbmacs
  BASE16_BASE00 = Scintilla::COLOR_BLACK #0
  BASE16_BASE08 = Scintilla::COLOR_RED #1
  BASE16_BASE0B = Scintilla::COLOR_GREEN #2
  BASE16_BASE0A = Scintilla::COLOR_YELLOW #3
  BASE16_BASE0D = Scintilla::COLOR_BLUE #4
  BASE16_BASE0E = Scintilla::COLOR_MAGENTA #5
  BASE16_BASE0C = Scintilla::COLOR_CYAN #6
  BASE16_BASE05 = Scintilla::COLOR_WHITE #7
  BASE16_BASE03 = Scintilla::COLOR_LIGHTBLACK #8
  BASE16_BASE09 = Scintilla::COLOR_LIGHTRED #9
  BASE16_BASE01 = Scintilla::COLOR_LIGHTGREEN #10
  BASE16_BASE02 = Scintilla::COLOR_LIGHTYELLOW #11
  BASE16_BASE04 = Scintilla::COLOR_LIGHTBLUE #12
  BASE16_BASE06 = Scintilla::COLOR_LIGHTMAGENTA #13
  BASE16_BASE0F = Scintilla::COLOR_LIGHTCYAN #14
  BASE16_BASE07 = Scintilla::COLOR_LIGHTWHITE #15

  def self.curses_init_color_rgb_hex(n, rgb_hex)
    if Curses.can_change_color == true
      Curses.init_color n,
      rgb_hex[0..1].hex*1000/255,
      rgb_hex[2..3].hex*1000/255,
      rgb_hex[4..5].hex*1000/255
    end
  end
end
