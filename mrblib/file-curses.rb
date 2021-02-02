module Mrbmacs
  class Application
    def read_file_name(prompt, directory)
      prefix_text = directory + "/"
      filename = @frame.echo_gets(prompt, prefix_text) do |input_text|
        file_list = []
        len = 0
        if input_text[-1] == "/"
          file_list = Dir.entries(input_text)
        else
          dir = File.dirname(input_text)
          fname = File.basename(input_text)
          qfname = Regexp.quote(fname)
          Dir.foreach(dir) do |item|
            if item =~ /^#{qfname}/
              file_list.push(item)
            end
          end
          len = fname.length
        end
        [file_list.sort.join(" "), len]
      end
      return filename
    end
    def read_save_file_name(prompt, directory)
      read_file_name(prompt, directory)
    end
  end
end