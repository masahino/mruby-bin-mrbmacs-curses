module Scimre
  class CppMode < Mode
    include Scintilla
    def initialize
      super.initialize
      @name = "cpp"
      @keyword_list = "and and_eq asm auto bitand bitor bool break case catch char class compl const const_cast constexpr continue default delete do double dynamic_cast else enum explicit export extern false float for friend goto if inline int long mutable namespace new not not_eq operator or or_eq private protected public register reinterpret_cast return short signed sizeof static static_cast struct switch template this throw true try typedef typeid typename union unsigned using virtual void volatile wchar_t while xor xor_eq"
      @style = [
        {:fore => COLOR_BASE0}, # SCE_C_DEFAULT 0
        {:fore => COLOR_BASE01, :italic => true}, # SCE_C_COMMENT 1
        {:fore => COLOR_BASE01, :italic => true}, # SCE_C_COMMENTLINE 2
        {:fore => COLOR_BASE01, :italic => true}, # SCE_C_COMMENTDOC 3
        {:fore => COLOR_BASE0}, # SCE_C_NUMBER 4
        {:fore => COLOR_BLUE}, # SCE_C_WORD 5
        {:fore => COLOR_CYAN}, # SCE_C_STRING 6
        {:fore => COLOR_BASE0}, # SCE_C_CHARACTER 7
        {:fore => COLOR_GREEN}, # SCE_C_UUID 8
        {:fore => COLOR_BASE0}, # SCE_C_PREPROCESSOR 9
        {:fore => COLOR_BLUE}, # SCE_C_OPERATOR 10
        {:fore => COLOR_BASE0}, # SCE_C_IDENTIFIER 11
        {:fore => COLOR_BASE0}, # SCE_C_STRINGEOL 21
        {:fore => COLOR_BASE0}, # SCE_C_VERBATIM 13
        {:fore => COLOR_BASE0}, # SCE_C_REGEX 14
        {:fore => COLOR_BASE01, :italic => true}, # SCE_C_COMMENTLINEDOC 15
        {:fore => COLOR_BLUE}, # SCE_C_WORD2 16
        {:fore => COLOR_BASE01}, # SCE_C_COMMENTDOCKEYWORD 17
        {:fore => COLOR_BASE01}, # SCE_C_COMMENTDOCKEYWORDERROR 18
        {:fore => COLOR_BASE0}, # SCE_C_GLOBALCLASS 19
        {:fore => COLOR_BASE0}, # SCE_C_STRINGRAW 20
        {:fore => COLOR_BASE0}, # SCE_C_TRIPLEVERBATIM 21
        {:fore => COLOR_BASE0}, # SCE_C_HASHQUOTEDSTRING 22
        {:fore => COLOR_BASE0}, # SCE_C_PREPROCESSORCOMMENT 23
        {:fore => COLOR_BASE0}, # SCE_C_PREPROCESSORCOMMENTDOC 24
        {:fore => COLOR_BASE0}, # SCE_C_USERLITERAL 25
        {:fore => COLOR_BASE0}, # SCE_C_TASKMARKER 26
        {:fore => COLOR_BASE0}, # SCE_C_ESCAPESEQUENCE 27
      ]
    end
    def get_indent_level(view_win)
      line = view_win.line_from_position(view_win.get_current_pos())
      level = view_win.get_fold_level(line) & Scintilla::SC_FOLDLEVELNUMBERMASK - Scintilla::SC_FOLDLEVELBASE
      cur_line = view_win.get_curline()[0]
      if level > 0 and cur_line =~/^\s+}.*$/
        level -= 1
      end
      return level
    end
  end
end
