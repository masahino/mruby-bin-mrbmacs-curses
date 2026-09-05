require 'rbconfig'

MRUBY_CONFIG = File.expand_path(ENV['MRUBY_CONFIG'] || 'build_config.rb')
MRUBY_VERSION = ENV['MRUBY_VERSION'] || '4.0.0'
RAKE = "#{RbConfig.ruby} #{Gem.bin_path('rake', 'rake')}"

file :mruby do
  sh 'git clone --depth=1 https://github.com/mruby/mruby.git'
  next if MRUBY_VERSION == 'master'

  Dir.chdir('mruby') do
    sh 'git fetch --tags'
    revision = `git rev-parse #{MRUBY_VERSION}`.chomp
    sh "git checkout #{revision}"
  end
end

desc 'Build mrbmacs curses frontend'
task compile: :mruby do
  sh "cd mruby && #{RAKE} all MRUBY_CONFIG=#{MRUBY_CONFIG}"
end

desc 'Run mrbmacs curses frontend tests'
task test: :mruby do
  sh "cd mruby && #{RAKE} all test MRUBY_CONFIG=#{MRUBY_CONFIG}"
end

desc 'Run mrbmacs curses frontend binary tests'
task bintest: :mruby do
  sh "cd mruby && #{RAKE} all test:bin MRUBY_CONFIG=#{MRUBY_CONFIG}"
end

desc 'Clean generated build files'
task :clean do
  next unless File.directory?('mruby')

  sh "cd mruby && #{RAKE} deep_clean"
end

task default: :compile
