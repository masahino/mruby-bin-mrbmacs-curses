def gem_config(conf)
  conf.gembox 'default'
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-eval"
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-exit"
  conf.gem :github => 'masahino/mruby-iconv', :branch => 'add_iconvlist' do |g|
    g.linker.libraries.delete 'iconv'
  end
#  conf.gem :github => 'gromnitsky/mruby-dir-glob'
  conf.gem :github => 'masahino/mruby-mrbmacs-base' do |g|
    g.add_test_dependency 'mruby-scinterm',  :github => 'masahino/mruby-scinterm'
  end
  conf.gem :github => 'masahino/mruby-scinterm' do |g|
    g.download_scintilla
  end
  conf.gem :github => 'masahino/mruby-termkey' do |g|
    g.download_libtermkey
  end

  conf.gem File.expand_path(File.dirname(__FILE__))
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_debug
  conf.enable_cxx_abi

  conf.enable_bintest
  conf.enable_test

  gem_config(conf)
  conf.gem :github => 'iij/mruby-regexp-pcre'
  conf.gem :github => 'mattn/mruby-require'
end

MRuby::CrossBuild.new('x86_64-pc-linux-gnu') do |conf|
  toolchain :gcc

  conf.enable_cxx_abi

  gem_config(conf)
  conf.gem :github => 'iij/mruby-regexp-pcre'
  conf.gem :github => 'mattn/mruby-require'
end

MRuby::CrossBuild.new('i386-pc-linux-gnu') do |conf|
  toolchain :gcc

  [conf.cc, conf.cxx, conf.linker].each do |cc|
    cc.flags << "-m32"
  end

  conf.enable_cxx_abi

  gem_config(conf)
  conf.gem :github => 'iij/mruby-regexp-pcre'
  conf.gem :github => 'mattn/mruby-require'
end

MRuby::CrossBuild.new('x86_64-apple-darwin14') do |conf|
  toolchain :clang

  conf.enable_cxx_abi
  [conf.cc, conf.linker].each do |cc|
    cc.command = 'x86_64-apple-darwin14-clang'
  end
  conf.cxx.command      = 'x86_64-apple-darwin14-clang++'
  conf.archiver.command = 'x86_64-apple-darwin14-ar'

  conf.build_target     = 'x86_64-pc-linux-gnu'
  conf.host_target      = 'x86_64-apple-darwin14'

  conf.linker.libraries << 'iconv'
  conf.linker.libraries << 'stdc++'
  conf.gem :github => 'masahino/mruby-iconv', :branch => 'add_iconvlist' do |g|
    g.cc.flags << '-DHAVE_ICONVLIST'
  end
  gem_config(conf)
  conf.gem :github => 'iij/mruby-regexp-pcre'
  conf.gem :github => 'mattn/mruby-require'
end

#MRuby::CrossBuild.new('i386-apple-darwin14') do |conf|
#  toolchain :clang
#
#  conf.enable_cxx_abi
#  [conf.cc, conf.linker].each do |cc|
#    cc.command = 'i386-apple-darwin14-clang'
#  end
#  conf.cxx.command      = 'i386-apple-darwin14-clang++'
#  conf.archiver.command = 'i386-apple-darwin14-ar'
#
#  conf.build_target     = 'i386-pc-linux-gnu'
#  conf.host_target      = 'i386-apple-darwin14'
#
#  conf.linker.libraries << 'iconv'
#  conf.linker.libraries << 'stdc++'
#  gem_config(conf)
#  conf.gem :github => 'iij/mruby-regexp-pcre'
#  conf.gem :github => 'mattn/mruby-require'
#end

MRuby::CrossBuild.new('i686-w64-mingw32') do |conf|
  toolchain :gcc

  [conf.cc, conf.linker].each do |cc|
    cc.command = 'i686-w64-mingw32-gcc'
  end
  conf.cxx.command      = 'i686-w64-mingw32-g++'
  conf.archiver.command = 'i686-w64-mingw32-gcc-ar'
  conf.exts.executable  = ".exe"

  conf.build_target     = 'i686-pc-linux-gnu'
  conf.host_target      = 'i686-w64-mingw32'

  conf.gem :github => 'masahino/mruby-iconv', :branch => 'add_iconvlist' do |g|
    g.cc.flags << '-DHAVE_ICONVLIST'
  end
  conf.gem :github => 'iij/mruby-regexp-pcre' do |g|
    g.cc.flags << '-DPCRE_STATIC'
  end
  gem_config(conf)
  conf.cc.include_paths << '/usr/i686-w64-mingw32/include/ncurses'
  conf.linker.flags << '-static'
  conf.linker.libraries << 'iconv'
  conf.linker.libraries << 'stdc++'
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

  conf.gem :github => 'masahino/mruby-iconv', :branch => 'add_iconvlist' do |g|
    g.cc.flags << '-DHAVE_ICONVLIST'
  end
  conf.gem :github => 'iij/mruby-regexp-pcre' do |g|
    g.cc.flags << '-DPCRE_STATIC'
  end
  gem_config(conf)
  conf.cc.include_paths << '/usr/x86_64-w64-mingw32/include/ncurses'
  conf.linker.flags << '-static'
  conf.linker.libraries << 'iconv'
  conf.linker.libraries << 'stdc++'
end

