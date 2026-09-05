MRuby::Gem::Specification.new('mruby-bin-mrbmacs-curses') do |spec|
  spec.license = 'MIT'
  spec.author  = 'masahino'
  spec.version = '1.0.0'

  version_text = File.join(spec.build_dir, 'version.txt')
  generated_version = File.join(spec.build_dir, 'generated_version.rb')

  file version_text => __FILE__ do
    FileUtils.mkdir_p(spec.build_dir)
    File.open(version_text, 'w') { |file| file.puts spec.version }
  end

  file generated_version => version_text do
    version = File.read(version_text).strip
    File.open(generated_version, 'w') do |file|
      file.puts 'module Mrbmacs'
      file.puts '  class Application'
      file.puts "    Version = #{version.inspect}"
      file.puts '  end'
      file.puts 'end'
    end
  end

  spec.rbfiles << generated_version

  spec.add_dependency 'mruby-scintilla-curses', github: 'masahino/mruby-scintilla-curses'
  spec.add_dependency 'mruby-mrbmacs-base', github: 'masahino/mruby-mrbmacs-base'
  spec.add_dependency 'mruby-termkey', github: 'masahino/mruby-termkey'
  spec.add_dependency 'mruby-curses', github: 'jbreeden/mruby-curses'
  spec.bins = %w[mrbmacs-curses]
end
