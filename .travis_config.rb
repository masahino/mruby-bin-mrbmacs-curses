MRuby::Build.new do |conf|
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  enable_debug

  conf.cc.defines = %w[MRB_ENABLE_ALL_SYMBOLS]
  conf.cc.defines << %w[MRB_UTF8_STRING]

  conf.gembox 'default'

  conf.gem github: 'mattn/mruby-iconv' do |g|
    g.linker.libraries.delete 'iconv' if RUBY_PLATFORM.include?('linux')
  end
  if RUBY_PLATFORM.downcase =~ /msys|mingw/
    conf.cc.include_paths << "#{MRUBY_ROOT}/../misc"
    conf.cc.include_paths << "#{ENV['MINGW_PREFIX']}/include/pdcurses"
    conf.cc.flags << '-DPDC_WIDE'
    conf.cc.flags << '-DPDC_FORCE_UTF8'
  end
  conf.gem github: 'masahino/mruby-mrbmacs-lsp'

  conf.gem "#{MRUBY_ROOT}/.."
  conf.linker.libraries << 'stdc++'
  conf.linker.libraries << 'pthread'
  if RUBY_PLATFORM.downcase =~ /msys|mingw/
    conf.linker.libraries << 'pdcurses'
    conf.linker.libraries.delete 'panel'
    conf.linker.libraries.delete 'ncurses'
  end

  # bintest
  conf.enable_bintest
  conf.enable_test
end
