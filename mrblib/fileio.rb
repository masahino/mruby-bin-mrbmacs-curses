module Scimre
  class << self
    def load_file(view_win, filename)
      begin
        text = File.open(filename).read
#        view_win.set_codepage(Scintilla::SC_CP_UTF8)
        view_win.set_text(text)
        view_win.set_savepoint
      rescue
        # new file
      end
    end

    def save_buffer(app)
      all_text = app.frame.view_win.get_text(app.frame.view_win.get_length+1)
      #    $stderr.print all_text
      #      File.open(app.filename, "w") do |f|
      File.open(app.current_buffer.filename, "w") do |f|
        f.write all_text
      end
      app.frame.view_win.set_save_point
    end

    def find_file(app)
      view_win = app.frame.view_win
      echo_win = app.frame.view_win
      dir = app.current_buffer.directory
      prefix_text = dir + "/"

      filename = app.frame.echo_gets("find file: ", prefix_text) do |input_text|
        file_list = Dir.glob(input_text+"*")
        file_list.map{|f| File.basename(f)}.join(" ")
      end
      if filename != nil
        new_buffer = Buffer.new(filename)
        view_win.add_refdocument(app.current_buffer.docpointer)
        view_win.set_docpointer(nil)
        new_buffer.docpointer = view_win.get_docpointer
#         new_buffer.docpointer = view_win.create_document
        app.buffer_list.push(new_buffer)
        app.prev_buffer = app.current_buffer
        app.current_buffer = new_buffer
        load_file(view_win, filename)
        mode = Scimre::Mode.set_mode_by_filename(filename)
        view_win.set_lexer_language(mode.name)
        mode.set_style(view_win)
        view_win.set_sel_back(true, 0xff0000)
        view_win.refresh
      end
    end
    
  end
end
