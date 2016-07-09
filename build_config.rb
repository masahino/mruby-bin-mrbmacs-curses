def gem_config(conf)
  conf.gembox 'default'
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-eval"
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-exit"
  conf.gem :github => 'iij/mruby-regexp-pcre'
  conf.gem :github => 'mattn/mruby-iconv' do |g|
    g.linker.libraries.delete 'iconv'
  end
  conf.gem :github => 'gromnitsky/mruby-dir-glob'
  conf.gem :github => 'masahino/mruby-mrbmacs-base'
  conf.gem :github => 'masahino/mruby-scinterm' do |g|
    g.download_scintilla
  end
  conf.gem :github => 'masahino/mruby-termkey' do |g|
    g.download_libtermkey
  end

  conf.gem File.expand_path(File.dirname(__FILE__))
  conf.gem :github => 'mattn/mruby-require'
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_debug
  conf.enable_cxx_abi

  conf.enable_bintest
  conf.enable_test

  gem_config(conf)
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
  gem_config(conf)
end
