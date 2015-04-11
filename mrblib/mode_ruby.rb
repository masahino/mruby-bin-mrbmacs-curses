module Scimre
  class RubyMode < Mode
    def initialize
      super.initialize
      @name = "ruby"
      @keyword_list = "attr_accessor attr_reader attr_writer module_function begin break elsif module retry unless end case next return until class ensure nil self when def false not super while alias defined? for or then yield and do if redo true else in rescue undef"
      @style = [
        {:fore => COLOR_BASE0}, # SCE_RB_DEFAULT 0
        {:back => COLOR_RED}, # SCE_RB_ERROR 1 
        {:fore => COLOR_BASE01, :italic => true}, # SCE_RB_COMMENTLINE 2
        {}, # SCE_
        {:fore => COLOR_BASE0}, # SCE_RB_NUMBER 4
        {:fore => COLOR_YELLOW}, # SCE_RB_WORD 5
        {:fore => COLOR_CYAN}, # SCE_RB_STRING 6
        {:fore => COLOR_CYAN}, # SCE_RB_CHARACTER 7
        {:fore => COLOR_YELLOW}, # SCE_RB_CLASSNAME 8
        {:fore => COLOR_BLUE}, # SCE_RB_DEFNAME 9
        {:fore => COLOR_BASE0}, # SCE_RB_OPERATOR 10
        {:fore => COLOR_BASE0}, # SCE_RB_IDENTIFIER 11
        {:fore => COLOR_RED}, # SCE_RB_REGEX 12
        {:fore => COLOR_BLUE}, # SCE_RB_GLOBAL 13
        {:fore => COLOR_BLUE}, # SCE_RB_SYMBOL 14
        {:fore => COLOR_ORANGE}, # SCE_RB_MODULE_NAME 15
        {:fore => COLOR_BLUE}, # SCE_RB_INSTANCE_VAR 16
        {:fore => COLOR_BLUE}, # SCE_RB_CLASS_VAR 17
        {:fore => COLOR_RED}, # SCE_RB_BACKTICKS 18 
        {}, # SCE_RB_DATASECTION 19
        {}, # SCE_RB_HERE_DELIM 20
        {}, # SCE_RB_HERE_Q 21
        {}, # SCE_RB_HERE_QQ 22
        {}, # SCE_RB_HERE_QX 23
        {}, # SCE_RB_STRING_Q 24
        {}, # SCE_RB_STRING_QQ 25
        {}, # SCE_RB_STRING_QX 26
        {}, # SCE_RB_STRING_QR 27
        {}, # SCE_RB_STRING_QW 28
        {:fore => COLOR_BLUE}, # SCE_RB_WORD_DEMOTED 29
        {:fore => COLOR_BASE0}, # SCE_RB_STDIN 30
        {}, # SCE_RB_STDOUT 31
        {}, # 32
        {}, # 33
        {}, # 34
        {}, # 35
        {}, # 36
        {}, # 37
        {}, # 38
        {}, # 39
        {}, # SCE_RB_STDERR 40
        {:fore => COLOR_YELLOW}, # SCE_RB_UPPER_BOUND 41
      ]
    end
    
    def get_indent_level(view_win)
      line = view_win.line_from_position(view_win.get_current_pos())
      level = view_win.get_fold_level(line) & Scintilla::SC_FOLDLEVELNUMBERMASK - Scintilla::SC_FOLDLEVELBASE
      cur_line = view_win.get_curline()[0]
      if level > 0 and cur_line =~/^\s+(end|}).*$/
        level -= 1
      end
      return level
    end
  end
end
