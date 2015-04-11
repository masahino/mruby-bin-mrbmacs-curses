module Scimre
  class Buffer
    attr_accessor :filename, :directory, :docpointer, :name
    def initialize(filename = nil)
      if filename != nil
        @filename = File.expand_path(filename)
        @name = File.basename(@filename)
        @directory = File.dirname(@filename)
      else
        @filename = ""
        @name = ""
        @directory = Dir.getwd
      end
      text = ""
      @docpointer = nil
    end 
  end

  class << self
    def get_buffer_from_name(buffer_list, name)
      buffer_list.each do |b|
        if b.name == name
          return b
        end
      end
      return nil
    end

    def switch_to_buffer(app)
      view_win = app.frame.view_win
      echo_win = app.frame.view_win
      echo_text = "Switch to buffer: (default #{app.prev_buffer.name}) "
      buffername = app.frame.echo_gets(echo_text, "") do |input_text|
        buffer_list = app.buffer_list.collect{|b| b.name}.select{|b| b =~ /^#{input_text}/}
        buffer_list.join(" ")
      end
      if buffername != nil
        if buffername == ""
          buffername = app.prev_buffer.name
        end
        if buffername == app.current_buffer.name
          echo_win.set_focus(false)
          view_win.set_focus(true)
          return
        end
        new_buffer = get_buffer_from_name(app.buffer_list, buffername)
        if new_buffer != nil
          tmp_p = view_win.get_docpointer
          view_win.add_refdocument(app.current_buffer.docpointer)
          view_win.set_docpointer(new_buffer.docpointer)
          app.prev_buffer = app.current_buffer
          app.current_buffer = new_buffer
        end
        echo_win.set_focus(false)
        echo_win.refresh
        view_win.set_focus(true)
        
#        mode = Scimre::Mode.set_mode_by_filename(filename)
#        view_win.set_lexer_language(mode.name)
#        mode.set_style(view_win)
#        view_win.set_sel_back(true, 0xff0000)
        view_win.refresh
      end
    end

    def kill_buffer(app)
      echo_text = "kill-buffer (default #{app.current_buffer.name}): "
      buffername = app.frame.echo_gets(echo_text, "") do |input_text|
      end
      if echo_text == nil
        buffername = app.current_buffer.name
      end
    end
  end
end
