MRuby::Gem::Specification.new('mruby-bin-mrbmacs-curses') do |spec|
  spec.license = 'MIT'
  spec.author  = 'masahino'
  spec.add_dependency('mruby-scinterm')
  spec.add_dependency('mruby-iconv')
  spec.add_dependency('mruby-mrbmacs-base')
  spec.bins = %w(mrbmacs-curses)
end
