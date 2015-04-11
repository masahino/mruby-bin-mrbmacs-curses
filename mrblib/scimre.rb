module Scimre
  class Application
    include Scintilla

    attr_accessor :frame, :mark_pos
    attr_accessor :current_buffer, :buffer_list, :prev_buffer
    attr_accessor :mode
    def initialize(file = nil)
      @frame = Scimre::Frame.new()
      
      @keymap = ViewKeyMap.new(@frame.view_win)
      @command_list = @keymap.command_list
      @echo_keymap = EchoWinKeyMap.new(@frame.echo_win)

      @mode = Mode.new
      @mark_pos = nil
      @buffer_list = []
      @current_buffer = nil
      @filename = nil
      if file != nil
        Scimre::load_file(@frame.view_win, file)
        @mode = Scimre::Mode.set_mode_by_filename(file)
        @frame.view_win.set_lexer_language(@mode.name)
        @mode.set_style(@frame.view_win)
        @frame.view_win.set_sel_back(true, 0xff0000)
        @frame.view_win.refresh
        @filename = file
        buffer = Scimre::Buffer.new(file)
        buffer.docpointer = @frame.view_win.get_docpointer()
        @current_buffer = buffer
        @prev_buffer = buffer
        @buffer_list.push(buffer)
      end
      @frame.modeline(self)
    end

  def extend(command)
    if command.class.to_s == "Fixnum"
      @frame.view_win.send_message(command)
    else
        begin
          instance_eval("Scimre::#{command.gsub("-", "_")}(self)")
        rescue
          $stderr.puts $!
        end
    end
  end

  def doscan(prefix)
    ret, key = @frame.tk.waitkey
    key_str = prefix + @frame.tk.strfkey(key, TermKey::FORMAT_ALTISMETA)
    if $DEBUG
      $stderr.puts '['+key_str+']'
    end
    if @command_list.has_key?(key_str)
      if @command_list[key_str] == "prefix"
        return doscan(key_str + " ")
      else
        return [key, @command_list[key_str]]
      end
    end
    [key, nil]
  end

  def doin()
    key, command = doscan("")
    if $DEBUG
      $stderr.puts command
    end
    if command == nil
      @frame.send_key(key)
    else
      extend(command)
    end
  end

  def run
    command_mode = nil
    prefix_key = ""
    while true do
      doin()
#      if @mark_pos != nil
#        @frame.view_win.set_anchor(@mark_pos)
      #      end
      @frame.view_win.refresh
      @frame.modeline(self)
      next
    end
  end
end
end
