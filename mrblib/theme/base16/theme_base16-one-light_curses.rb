module Mrbmacs
  class Base16OneLightTheme < Base16Theme
    def initialize
      super
      @name = "base16-one-light"
    end

    def set_pallete
      color_list = [
        ["BASE00",  0, "fafafa"],
        ["BASE01", 10, "f0f0f1"],
        ["BASE02", 11, "e5e5e6"],
        ["BASE03",  8, "a0a1a7"],
        ["BASE04", 12, "696c77"],
        ["BASE05",  7, "383a42"],
        ["BASE06", 13, "202227"],
        ["BASE07", 15, "090a0b"],
        ["BASE08",  1, "ca1243"],
        ["BASE09",  9, "d75f00"],
        ["BASE0A",  3, "c18401"],
        ["BASE0B",  2, "50a14f"],
        ["BASE0C",  6, "0184bc"],
        ["BASE0D",  4, "4078f2"],
        ["BASE0E",  5, "a626a4"],
        ["BASE0F", 14, "986801"],
      ] 
     color_list.each do |c|
        Mrbmacs::curses_init_color_rgb_hex(c[1], c[2])
      end
    end
  end
end
