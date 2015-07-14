module Scimre
  $mode_list = {
	# ruby-mode
	".rb" => "ruby",
	".c" => "cpp",
	".h" => "cpp",
	".cpp" => "cpp",
	".cxx" => "cpp",
        ".txt" => "fundamental",
        "" => "fundamental",
      }
    
  class Mode
    def self.get_mode_by_suffix(suffix)
      if $mode_list.has_key?(suffix)
        $mode_list[suffix]
      else
        "fundamental"
      end
    end

    def self.set_mode_by_filename(filename)
      cur_mode = get_mode_by_suffix(File.extname(filename))
      mode = Scimre.const_get(cur_mode.capitalize+"Mode").new
      return mode
    end
      
    attr_accessor :name
    def initialize
      @name = "default"
      @keyword_list = ""
      @style = {}
      @indent = 2
    end
    
    def set_style(view_win)
      for i in 0..@style.length-1
        if @style[i][:fore]
          view_win.sci_style_set_fore(i, @style[i][:fore])
        end
        if @style[i][:back]
          view_win.sci_style_set_back(i, @style[i][:back])
        end
        if @style[i][:italic]
          view_win.sci_style_set_italic(i, @style[i][:italic])
        end
      end
      view_win.sci_set_keywords(0, @keyword_list)
      view_win.sci_set_property("fold", "1")
      view_win.sci_set_tab_width(@indent)
      view_win.sci_set_use_tabs(false)
      view_win.sci_set_tab_indents(true)
      view_win.sci_set_back_space_un_indents(true)
      view_win.sci_set_indent(@indent)
      view_win.sci_set_wrap_mode(Scintilla::SC_WRAP_CHAR)
    end
    def config
    end
    
    def get_indent_level(view_win)
$stderr.puts "get_indent_level"
    end
  end

  class FundamentalMode < Mode
    def initialize
      @name = "fundamental"
      @keyword_list = ""
      @style = {}
    end
  end
end
