module Mrbmacs
  class Application
    def read_file_name(prompt, directory)
      prefix_text = directory + "/"
      filename = @frame.echo_gets(prompt, prefix_text) do |input_text|
        file_list = Dir.glob(input_text+"*")
        len = if input_text[-1] == "/"
          0
        else
          input_text.length - File.dirname(input_text).length - 1
        end
        [file_list.map{|f| File.basename(f)}.join(" "), len]
      end
      return filename
    end
  end
end