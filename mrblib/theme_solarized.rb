module Scimre
  COLOR_BASE03 = Scintilla::COLOR_BLACK
  COLOR_BASE02 = Scintilla::COLOR_RED
  COLOR_BASE01 = Scintilla::COLOR_GREEN
  COLOR_BASE00 = Scintilla::COLOR_YELLOW
  COLOR_BASE0  = Scintilla::COLOR_BLUE
  COLOR_BASE1  = Scintilla::COLOR_MAGENTA
  COLOR_BASE2  = Scintilla::COLOR_CYAN
  COLOR_BASE3  = Scintilla::COLOR_WHITE
  COLOR_YELLOW = Scintilla::COLOR_LIGHTBLACK
  COLOR_ORANGE = Scintilla::COLOR_LIGHTRED
  COLOR_RED    = Scintilla::COLOR_LIGHTGREEN
  COLOR_MAGENTA = Scintilla::COLOR_LIGHTYELLOW
  COLOR_VIOLET = Scintilla::COLOR_LIGHTBLUE
  COLOR_BLUE   = Scintilla::COLOR_LIGHTMAGENTA
  COLOR_CYAN   = Scintilla::COLOR_LIGHTCYAN
  COLOR_GREEN  = Scintilla::COLOR_LIGHTWHITE
  class << self
    def use_solarized
      color_list = [234, 235, 239, 240, 244, 245, 187, 230,
                    136, 166, 124, 125,  61,  33,  37, 64]
      Scintilla::ScinTerm.set_pallete(color_list)
    end
  end

  class SolarizedDarkTheme
    attr_accessor :style_list
    def initialize
      color_list = [234, 235, 239, 240, 244, 245, 187, 230,
                    136, 166, 124, 125,  61,  33,  37, 64]
      Scintilla::ScinTerm.set_pallete(color_list)
      @style_list= {
        'cpp' => [
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_DEFAULT 0
          {:fore => Scimre::COLOR_BASE01, :italic => true}, # SCE_C_COMMENT 1
          {:fore => Scimre::COLOR_BASE01, :italic => true}, # SCE_C_COMMENTLINE 2
          {:fore => Scimre::COLOR_BASE01, :italic => true}, # SCE_C_COMMENTDOC 3
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_NUMBER 4
          {:fore => Scimre::COLOR_BLUE}, # SCE_C_WORD 5
          {:fore => Scimre::COLOR_CYAN}, # SCE_C_STRING 6
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_CHARACTER 7
          {:fore => Scimre::COLOR_GREEN}, # SCE_C_UUID 8
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_PREPROCESSOR 9
          {:fore => Scimre::COLOR_BLUE}, # SCE_C_OPERATOR 10
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_IDENTIFIER 11
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_STRINGEOL 21
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_VERBATIM 13
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_REGEX 14
          {:fore => Scimre::COLOR_BASE01, :italic => true}, # SCE_C_COMMENTLINEDOC 15
          {:fore => Scimre::COLOR_BLUE}, # SCE_C_WORD2 16
          {:fore => Scimre::COLOR_BASE01}, # SCE_C_COMMENTDOCKEYWORD 17
          {:fore => Scimre::COLOR_BASE01}, # SCE_C_COMMENTDOCKEYWORDERROR 18
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_GLOBALCLASS 19
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_STRINGRAW 20
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_TRIPLEVERBATIM 21
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_HASHQUOTEDSTRING 22
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_PREPROCESSORCOMMENT 23
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_PREPROCESSORCOMMENTDOC 24
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_USERLITERAL 25
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_TASKMARKER 26
          {:fore => Scimre::COLOR_BASE0}, # SCE_C_ESCAPESEQUENCE 27
        ],
        'ruby' => [
          {:fore => COLOR_BASE0}, # SCE_RB_DEFAULT 0
          {:back => COLOR_RED}, # SCE_RB_ERROR 1 
          {:fore => COLOR_BASE01, :italic => true}, # SCE_RB_COMMENTLINE 2
          {}, # SCE_RB_POD 3
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
      }
    end
  end
end

