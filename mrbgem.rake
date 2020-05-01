MRuby::Gem::Specification.new('mruby-bin-mrbmacs-curses') do |spec|
  spec.license = 'MIT'
  spec.author  = 'masahino'
  spec.version = '0.2.0'
#  spec.add_dependency 'mruby-scintilla-curses', :github => 'masahino/mruby-scintilla-curses'
  spec.add_dependency 'mruby-mrbmacs-base', :github => 'masahino/mruby-mrbmacs-base'
  spec.add_dependency 'mruby-termkey', :github => 'masahino/mruby-termkey'
  spec.add_dependency 'mruby-curses', :github => 'jbreeden/mruby-curses'
  spec.add_dependency 'mruby-iconv'
  spec.add_test_dependency 'mruby-require', :github => 'mattn/mruby-require'
  spec.add_test_dependency 'mruby-scintilla-curses'
  spec.bins = %w(mrbmacs-curses)
end
