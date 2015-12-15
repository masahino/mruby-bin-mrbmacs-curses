module Mrbmacs
  def Mrbmacs::get_default_style_list
    style = Hash.new
    style["ruby"] = [
    {:fore => 0xffffff}, # SCE_RB_DEFAULT 0
    {:back => 0xff0000}, # SCE_RB_ERROR 1 
    {:fore => 0x000080, :italic => true}, # SCE_RB_COMMENTLINE 2
    {}, # SCE_RB_POD 3
    {:fore => 0x0000ff}, # SCE_RB_NUMBER 4
    {:fore => 0xff00ff}, # SCE_RB_WORD 5
    {:fore => 0x008000}, # SCE_RB_STRING 6
    {}, # SCE_RB_CHARACTER 7
    {:fore => 0x00ff00}, # SCE_RB_CLASSNAME 8
    {:fore => 0xff0000}, # SCE_RB_DEFNAME 9
    {}, # SCE_RB_OPERATOR 10
    {}, # SCE_RB_IDENTIFIER 11
    {}, # SCE_RB_REGEX 12
    {:fore => 0x800000}, # SCE_RB_GLOBAL 13
    {}, # SCE_RB_SYMBOL 14
    {:fore => 0x00ff00}, # SCE_RB_MODULE_NAME 15
    {:fore => 0x008080}, # SCE_RB_INSTANCE_VAR 16
    {:fore => 0x008000}, # SCE_RB_CLASS_VAR 17
    {:fore => 0x000080}, # SCE_RB_BACKTICKS 18
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
    {:fore => 0x008000}, # SCE_RB_WORD_DEMOTED 29
    {}, # SCE_RB_STDIN 30
    {}, # SCE_RB_STDOUT 31
    {}, # SCE_RB_STDERR 40
    {}, # SCE_RB_UPPER_BOUND 41
    ]
    style["cpp"] = [
      {:fore => 0xffffff}, # SCE_C_DEFAULT 0
      {:fore => 0x000080, :italic => true}, # SCE_C_COMMENT 1
      {:fore => 0x000080, :italic => true}, # SCE_C_COMMENTLINE 2
      {:fore => 0x000080, :italic => true}, # SCE_C_COMMENTDOC 3
      {:fore => 0xff0000}, # SCE_C_NUMBER 4
      {:fore => 0xff00ff}, # SCE_C_WORD 5
      {:fore => 0x008000}, # SCE_C_STRING 6
      {}, # SCE_C_CHARACTER 7
      {}, # SCE_C_UUID 8
      {:fore => 0x0000ff}, # SCE_C_PREPROCESSOR 9
      {}, # SCE_C_OPERATOR 10
      {:fore => 0x800080}, # SCE_C_IDENTIFIER 11
      {}, # SCE_C_STRINGEOL 12
      {}, # SCE_C_VERBATIM 13
      {}, # SCE_C_REGEX 14
      {:fore => 0x000080, :italic => true}, # SCE_C_COMMENTLINEDOC 15
      {}, # SCE_C_WORD2 16
      {}, # SCE_C_COMMENTDOCKEYWORD 17
      {}, # SCE_C_COMMENTDOCKEYWORDERROR 18
      {}, # SCE_C_GLOBALCLASS 19
      {}, # SCE_C_STRINGRAW 20
      {}, # SCE_C_TRIPLEVERBATIM 21
      {}, # SCE_C_HASHQUOTEDSTRING 22
      {}, # SCE_C_PREPROCESSORCOMMENT 23
      {}, # SCE_C_PREPROCESSORCOMMENTDOC 24
      {}, # SCE_C_USERLITERAL 25
      {}, # SCE_C_TASKMARKER 26
      {}, # SCE_C_ESCAPESEQUENCE 27
    ]
    style
  end
end
