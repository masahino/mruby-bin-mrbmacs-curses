module Mrbmacs
  class TestApp < ApplicationCurses
    def initialize
      @current_buffer = Buffer.new("*scratch*")
      @frame = Mrbmacs::Frame.new(@current_buffer)
      @buffer_list = []
      @keymap = ViewKeyMap.new
      @command_list = {}
      @recent_keys = []
    end
  end

  class TestFrame
    attr_accessor :view_win, :echo_win, :tk
    def initialize
      @view_win = Scintilla::TestScintilla.new
      @echo_win = Scintilla::TestScintilla.new
      @mode_win = Curses.newwin
    end

    def waitkey(win)
    end

    def strfkey(key)
    end

    def echo_set_prompt(prompt)
    end

    def modeline(app, win = nil)
    end
  end
end

class << Curses
  [
    :initscr, :raw, :curs_set, :newwin, :wbkgd, :wrefresh, :wmove, :waddstr, :noecho, :keypad
    ].each do |name|
    undef_method name
    define_method(name) do |*args|
    end
  end
  undef_method :wgetch
  define_method(:wgetch) do |*args|
    Curses::KEY_MIN + 1
  end
end

module Scintilla
  class ScintillaCurses
    attr_accessor :callback
    attr_accessor :messages
    def initialize(&block)
      @callback = block
      @messages = []
    end

    def send_message(id, *args)
      @messages.push(id)
    end

    def resize_window(height, width)
    end

    def move_window(x, y)
    end

    def refresh
    end

    def sci_set_docpointer(doc)
    end

    def sci_set_lexer_language(lang)
    end

    def send_key(key, mod_shift, mod_ctrl, mod_alt)
    end

    def sci_get_current_pos
      1
    end

    def sci_brace_match(x, y)
      1
    end

    def sci_brace_highlight(x, y)

    end

  end
end

class TermKey
  attr_accessor :key_buffer
  class Key
    attr_accessor :key_str
    def initialize(key = nil)
      if key != nil
        @code =
        if key == "Enter"
          TermKey::SYM_ENTER
        elsif key == "Escape"
          TermKey::SYM_ESCAPE
        else
          key.chr
        end
        @type = TermKey::TYPE_UNICODE
        @modifiers = 0
        @key_str = key
      else
        @code = 0
        @type = TermKey::TYPE_UNKNOWN_CSI
        @modifiers = 0
        @key_str = ""
      end
    end

    def modifiers
      @modifiers
    end

    def type
      @type
    end

    def code
      @code
    end

  end

  def initialize(fd, flag)
    @key_buffer = []
  end

  def waitkey
    if @key_buffer.size > 0
      [TermKey::RES_KEY, TermKey::Key.new(@key_buffer.shift)]
    else
      [TermKey::RES_NONE, TermKey::Key.new]
    end
  end

  def strfkey(key, flag)
    if key.respond_to? :key_str
      return key.key_str
    else
      return ""
    end
  end

  def strpkey(key_str, flag)
    if @key_buffer.size > 0
      TermKey::Key.new(@key_buffer.shift)
    else
      TermKey::Key.new
    end
  end

  def buffer_remaining
    0
  end

  def buffer_size
    0
  end
end
