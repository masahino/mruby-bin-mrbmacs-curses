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

# Drops the local clone of any locked gem whose upstream branch has moved, so
# the next build reclones and rebuilds only those -- without a full
# deep_clean, which would refetch and recompile everything (Scintilla
# included) regardless of what actually changed.
#
# git_clone_dependency (mruby/lib/mruby/build/load_gems.rb) skips cloning
# outright when the repo directory already exists, no matter what the lock
# says, so dropping the lock alone would not update anything already checked
# out; the directory itself has to go for the next build to refetch it.
desc 'Drop the local clone of any gem that moved upstream'
task :refresh do
  require 'yaml'

  lock_path = "#{MRUBY_CONFIG}.lock"
  unless File.exist?(lock_path)
    puts 'no lock file yet -- build once first'
    next
  end

  lock = YAML.load_file(lock_path)
  changed = false

  (lock['builds'] || {}).each do |target, gems|
    gems.each do |url, entry|
      repo_dir = "mruby/build/repos/#{target}/#{url[%r{([-\w]+)(\.[-\w]+|)$}, 1]}"
      next unless File.directory?("#{repo_dir}/.git")

      local = `git -C #{repo_dir} rev-parse HEAD`.strip
      remote = `git ls-remote #{url} refs/heads/#{entry['branch'] || 'master'}`.split.first
      next if remote.nil? || remote == local # up to date, no network transfer needed

      puts "#{File.basename(repo_dir)} #{local[0, 7]} -> #{remote[0, 7]}"
      rm_rf repo_dir
      changed = true
    end
  end

  rm_f lock_path if changed
end

task default: :compile
