module Mrbmacs
  def self.curses_init_color_rgb_hex(n, bgr_hex)
    if Curses.can_change_color == true
      Curses.init_color n,
      (bgr_hex >> 16)*1000/255,
      ((bgr_hex & 0x00ff00) >> 8)*1000/255,
      (bgr_hex & 0x0000ff)*1000/255
    end
  end

  class Base16Theme
    def curses_init
      @@base00 = Scintilla::COLOR_BLACK #0
      @@base08 = Scintilla::COLOR_RED #1
      @@base0B = Scintilla::COLOR_GREEN #2
      @@base0A = Scintilla::COLOR_YELLOW #3
      @@base0D = Scintilla::COLOR_BLUE #4
      @@base0E = Scintilla::COLOR_MAGENTA #5
      @@base0C = Scintilla::COLOR_CYAN #6
      @@base05 = Scintilla::COLOR_WHITE #7
      @@base03 = Scintilla::COLOR_LIGHTBLACK #8
      @@base09 = Scintilla::COLOR_LIGHTRED #9
      @@base01 = Scintilla::COLOR_LIGHTGREEN #10
      @@base02 = Scintilla::COLOR_LIGHTYELLOW #11
      @@base04 = Scintilla::COLOR_LIGHTBLUE #12
      @@base06 = Scintilla::COLOR_LIGHTMAGENTA #13
      @@base0F = Scintilla::COLOR_LIGHTCYAN #14
      @@base07 = Scintilla::COLOR_LIGHTWHITE #15
    end

    def set_pallete
      Mrbmacs::curses_init_color_rgb_hex( 0, @@base00)
      Mrbmacs::curses_init_color_rgb_hex(10, @@base01)
      Mrbmacs::curses_init_color_rgb_hex(11, @@base02)
      Mrbmacs::curses_init_color_rgb_hex( 8, @@base03)
      Mrbmacs::curses_init_color_rgb_hex(12, @@base04)
      Mrbmacs::curses_init_color_rgb_hex( 7, @@base05)
      Mrbmacs::curses_init_color_rgb_hex(13, @@base06)
      Mrbmacs::curses_init_color_rgb_hex(15, @@base07)
      Mrbmacs::curses_init_color_rgb_hex( 1, @@base08)
      Mrbmacs::curses_init_color_rgb_hex( 9, @@base09)
      Mrbmacs::curses_init_color_rgb_hex( 3, @@base0A)
      Mrbmacs::curses_init_color_rgb_hex( 2, @@base0B)
      Mrbmacs::curses_init_color_rgb_hex( 6, @@base0C)
      Mrbmacs::curses_init_color_rgb_hex( 4, @@base0D)
      Mrbmacs::curses_init_color_rgb_hex( 5, @@base0E)
      Mrbmacs::curses_init_color_rgb_hex(14, @@base0F)
      curses_init
    end
  end
end
