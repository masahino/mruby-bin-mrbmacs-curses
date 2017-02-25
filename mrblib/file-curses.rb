module Mrbmacs
  class Application
    def find_file(filename = nil)
      view_win = @frame.view_win

      if filename == nil
        dir = @current_buffer.directory
        prefix_text = dir + "/"

        filename = @frame.echo_gets("find file: ", prefix_text) do |input_text|
          file_list = Dir.glob(input_text+"*")
          len = if input_text[-1] == "/"
            0
          else
            input_text.length - File.dirname(input_text).length - 1
          end
          [file_list.map{|f| File.basename(f)}.join(" "), len]
        end
      end
      if filename != nil
        @current_buffer.pos = view_win.sci_get_current_pos
        new_buffer = Buffer.new(filename, @buffer_list.map{|b| b.name})
        view_win.sci_add_refdocument(@current_buffer.docpointer)
        view_win.sci_set_docpointer(nil)
        new_buffer.docpointer = view_win.sci_get_docpointer
#         new_buffer.docpointer = view_win.create_document
        @buffer_list.push(new_buffer)
        @prev_buffer = @current_buffer
        @current_buffer = new_buffer
        load_file(filename)
        view_win.sci_set_lexer_language(@current_buffer.mode.name)
        @current_buffer.mode.set_style(view_win, @theme)
        view_win.sci_set_sel_back(true, 0xff0000)
#        view_win.sci_refresh
      end
    end
  end
end