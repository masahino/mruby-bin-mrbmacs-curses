module Mrbmacs
  class Base16OneDarkTheme < Base16Theme
    def initialize
      super
      @name = "base16-onedark"
    end

    def set_pallete
      color_list = [
        ["BASE00",  0, "282c34"],
        ["BASE01", 10, "353b45"],
        ["BASE02", 11, "3e4451"],
        ["BASE03",  8, "545862"],
        ["BASE04", 12, "565c64"],
        ["BASE05",  7, "abb2bf"],
        ["BASE06", 13, "b6bdca"],
        ["BASE07", 15, "c8ccd4"],
        ["BASE08",  1, "e06c75"],
        ["BASE09",  9, "d19a66"],
        ["BASE0A",  3, "e5c07b"],
        ["BASE0B",  2, "98c379"],
        ["BASE0C",  6, "56b6c2"],
        ["BASE0D",  4, "61afef"],
        ["BASE0E",  5, "c678dd"],
        ["BASE0F", 14, "be5046"],
      ] 
     color_list.each do |c|
        Mrbmacs::curses_init_color_rgb_hex(c[1], c[2])
      end
    end
  end
end
