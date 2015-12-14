module Scimre
  class Application
    include Scintilla

    attr_accessor :frame, :mark_pos
    attr_accessor :current_buffer, :buffer_list, :prev_buffer
    attr_accessor :mode
    attr_accessor :file_encodings
    def initialize(init_filename, opts = nil)
      @frame = Scimre::Frame.new()  
      @keymap = ViewKeyMap.new(@frame.view_win)
      @command_list = @keymap.command_list
      @echo_keymap = EchoWinKeyMap.new(@frame.echo_win)
      @style_list = {}
      @mode = Mode.new
      @theme = SolarizedDarkTheme.new
      @mark_pos = nil
      @buffer_list = []
      @current_buffer = nil
      @filename = nil

      @file_encodings = []
      load_init_file(init_filename)
    end

    def load_init_file(init_filename)
      begin
        File.open(init_filename, "r") do |f|
          init_str = f.read()
          instance_eval(init_str)
        end
      rescue
        $stderr.puts $!
      end
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

    def run(file = nil)
      if file != nil
        buffer = Scimre::Buffer.new(file)
        @current_buffer = buffer
        Scimre::load_file(self, file)
        @mode = Scimre::Mode.set_mode_by_filename(file)
        @frame.view_win.sci_set_lexer_language(@mode.name)
        if $DEBUG
          $stderr.puts "["+@frame.view_win.sci_get_lexer_language()+"]"
        end
        @mode.set_style(@frame.view_win, @theme)
        @frame.view_win.sci_set_sel_back(true, 0xff0000)
        @frame.view_win.refresh
        @filename = file
      else
        buffer = Scimre::Buffer.new(nil)
        @current_buffer = buffer
      end
      buffer.docpointer = @frame.view_win.sci_get_docpointer()
      @prev_buffer = buffer
      @buffer_list.push(buffer)
      @frame.modeline(self)

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
