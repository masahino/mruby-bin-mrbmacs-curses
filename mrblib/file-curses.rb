module Mrbmacs
  # ApplicationCurses
  class ApplicationCurses < Application
    def read_dir_name(prompt, default_directory = nil)
      prefix_text = default_directory
      if prefix_text[-1] != '/'
        prefix_text += '/'
      end
      dirname = @frame.echo_gets(prompt, prefix_text) do |input_text|
        dir_list = []
        len = 0
        if input_text[-1] == '/'
          dir_list = Dir.entries(input_text).select { |f| File.directory?(f) }
        else
          dir = File.dirname(input_text)
          fname = File.basename(input_text)
          qfname = Regexp.quote(fname)
          Dir.foreach(dir) do |item|
            if File.directory?(item) && item =~ /^#{qfname}/
              dir_list.push(item)
            end
          end
          len = fname.length
        end
        [dir_list.sort.join(' '), len]
      end
      @frame.modeline_refresh(self)
      dirname
    end

    def read_file_name(prompt, directory, default_name = nil)
      prefix_text = directory + '/'
      if default_name != nil
        prefix_text += default_name
      end
      filename = @frame.echo_gets(prompt, prefix_text) do |input_text|
        file_list = []
        len = 0
        if input_text[-1] == '/'
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
        [file_list.sort.join(' '), len]
      end
      @frame.modeline_refresh(self)
      filename
    end

    def read_save_file_name(prompt, directory, default_name = nil)
      read_file_name(prompt, directory, default_name)
    end
  end
end
