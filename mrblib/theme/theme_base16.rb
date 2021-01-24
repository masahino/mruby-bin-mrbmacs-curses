module Mrbmacs
  def self.curses_init_color_rgb_hex(n, rgb_hex)
    if Curses.can_change_color == true
      Curses.init_color n,
      rgb_hex[0..1].hex*1000/255,
      rgb_hex[2..3].hex*1000/255,
      rgb_hex[4..5].hex*1000/255
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
      if @color_list != nil
        @color_list.each do |c|
          Mrbmacs::curses_init_color_rgb_hex(c[1], c[2])
        end
      end
    end
  end
end
