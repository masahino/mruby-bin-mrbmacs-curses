def gem_config(conf)
  conf.gembox 'default'
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-eval"
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-exit"
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-bin-mrbc"
  conf.gem :github => 'mattn/mruby-onig-regexp'
  conf.gem :github => 'fastly/mruby-optparse'
  conf.gem :github => 'mattn/mruby-iconv' do |g|
    g.linker.libraries.delete 'iconv'
  end
  conf.gem :github => 'masahino/mruby-termkey' do |g|
    g.download_libtermkey
  end
  conf.gem :github => 'masahino/mruby-scintilla-base' do |g|
    g.download_scintilla
  end
  conf.gem :github => 'masahino/mruby-scintilla-curses' do |g|
    g.download_scintilla
  end
  conf.gem :github => 'masahino/mruby-mrbmacs-base' do |g|
    g.add_test_dependency 'mruby-scintilla-curses',  :github => 'masahino/mruby-scintilla-curses'
  end

  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.cc.defines = %w(MRB_ENABLE_ALL_SYMBOLS)
  conf.cc.defines = %w(MRB_UTF8_STRING)

  conf.linker.libraries << 'stdc++'
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_debug

  gem_config(conf)
  conf.enable_bintest
  conf.enable_test
end

MRuby::CrossBuild.new('x86_64-pc-linux-gnu') do |conf|
  toolchain :gcc

  gem_config(conf)
end

MRuby::CrossBuild.new('x86_64-apple-darwin19') do |conf|
  toolchain :clang

  [conf.cc, conf.linker].each do |cc|
    cc.command = 'x86_64-apple-darwin19-clang'
  end
  conf.cxx.command      = 'x86_64-apple-darwin19-clang++'
  conf.archiver.command = 'x86_64-apple-darwin19-ar'

  conf.build_target     = 'x86_64-pc-linux-gnu'
  conf.host_target      = 'x86_64-apple-darwin19'

  gem_config(conf)
  conf.gem :github => 'jbreeden/mruby-curses' do |g|
    g.linker.flags_before_libraries = []
  end
  conf.linker.libraries << 'iconv'
end

MRuby::CrossBuild.new('x86_64-w64-mingw32') do |conf|
  toolchain :gcc

  [conf.cc, conf.linker].each do |cc|
    cc.command = 'x86_64-w64-mingw32-gcc'
  end
  conf.cxx.command      = 'x86_64-w64-mingw32-g++'
  conf.archiver.command = 'x86_64-w64-mingw32-gcc-ar'
  conf.exts.executable  = ".exe"

  conf.build_target     = 'x86-pc-linux-gnu'
  conf.host_target      = 'x86_64-w64-mingw32'

  conf.cc.include_paths << '/usr/x86_64-w64-mingw32/include/pdcurses'
  gem_config(conf)
  conf.gem :github => 'jbreeden/mruby-curses' do |g|
    g.linker.flags_before_libraries = []
  end
  conf.linker.flags << '-static'
  conf.linker.libraries << 'iconv'
  conf.linker.libraries.delete 'ncurses'
  conf.linker.libraries.delete 'panel'
  conf.linker.libraries << 'pdcurses'
  conf.linker.libraries << 'gdi32'
  conf.linker.libraries << 'comdlg32'
end

MRuby::CrossBuild.new('arm-linux-gnueabihf') do |conf|
  toolchain :gcc

  [conf.cc, conf.linker].each do |cc|
    cc.command = 'arm-linux-gnueabihf-gcc'
  end
  conf.cxx.command      = 'arm-linux-gnueabihf-g++'
  conf.archiver.command = 'arm-linux-gnueabihf-ar'

  conf.build_target     = 'x86-pc-linux-gnu'
  conf.host_target      = 'arm-linux-gnueabihf'

  conf.cc.include_paths << '/usr/arm-linux-gnueabihf/include/ncurses'
  gem_config(conf)
  conf.gem :github => 'jbreeden/mruby-curses' do |g|
    g.linker.flags_before_libraries = []
  end
end
