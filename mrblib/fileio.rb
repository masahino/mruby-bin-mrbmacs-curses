module Scimre
  class << self
    def load_file(app, filename)
      view_win = app.frame.view_win
      file_encodings = app.file_encodings
      current_buffer = app.current_buffer
      begin
        file_encoding = "utf-8"
        text = File.open(filename).read
        file_encodings.each do |from|
          tmp_text = ""
          begin
            tmp_text = Iconv.conv("utf-8", from, text)
          rescue
            next
          end
          if tmp_text.size != text.size
            file_encoding = from
          end
          break
        end
        if file_encoding != "utf-8"
	  $stderr.puts file_encoding
          text = Iconv.conv("utf-8", file_encoding, text)
          current_buffer.encoding = file_encoding
        end
        view_win.sci_set_text(text)
        view_win.sci_set_savepoint
      rescue
        # new file
	$stderr.puts $!
        $stderr.puts "error load file"
      end
    end

    def save_buffer(app)
      all_text = app.frame.view_win.sci_get_text(app.frame.view_win.sci_get_length+1)
      if app.current_buffer.encoding != "utf-8"
        all_text = Iconv.conv(app.current_buffer.encoding, "utf-8", all_text)
      end
      #    $stderr.print all_text
      #      File.open(app.filename, "w") do |f|
      File.open(app.current_buffer.filename, "w") do |f|
        f.write all_text
      end
      app.frame.view_win.sci_set_save_point
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
        view_win.sci_add_refdocument(app.current_buffer.docpointer)
        view_win.sci_set_docpointer(nil)
        new_buffer.docpointer = view_win.sci_get_docpointer
#         new_buffer.docpointer = view_win.create_document
        app.buffer_list.push(new_buffer)
        app.prev_buffer = app.current_buffer
        app.current_buffer = new_buffer
        load_file(app, filename)
        mode = Scimre::Mode.set_mode_by_filename(filename)
        view_win.sci_set_lexer_language(mode.name)
        mode.set_style(view_win)
        view_win.sci_set_sel_back(true, 0xff0000)
        view_win.refresh
      end
    end
    
  end
end
