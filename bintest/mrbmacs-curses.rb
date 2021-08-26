require 'open3'
require 'fileutils'
require 'timeout'
$script_dir = File.dirname(__FILE__) + "/scripts/"

assert('init buffer') do
  stdout, stderr, status = Open3.capture3("#{cmd('mrbmacs-curses')} -l #{$script_dir}init_buffer")
  assert_equal 0, status.to_i
  lines = stderr.split("\n")
  assert_equal "*scratch*", lines[0]
end

assert('split window') do
  stdout, stderr, status = Open3.capture3("#{cmd('mrbmacs-curses')} -q -l #{$script_dir}split_window")
  assert_equal 0, status.to_i
  assert_equal 0, stderr.length
end

assert('split window') do
  stdout, stderr, status = Open3.capture3("#{cmd('mrbmacs-curses')} -q -l #{$script_dir}split_window2")
  assert_equal 0, status.to_i
  lines = stderr.split("\n")
  assert_equal "*scratch*", lines[0]
  assert_equal "*scratch*", lines[1]
end

def run_edit_test(test_name)
  edit_file = File.dirname(__FILE__) + "/#{test_name}.input"
  output_file = "#{$script_dir}#{test_name}.output"
  FileUtils.cp File.dirname(__FILE__) + "/test.input", edit_file
  Timeout.timeout(10) do
    stdout, stderr, status =
    Open3.capture3("#{cmd('mrbmacs-curses')} -q -l #{$script_dir}#{test_name} #{edit_file}")
  end
  assert_true FileUtils.cmp(edit_file, output_file)
  File.delete edit_file
end

assert('beginning-of-buffer') do
  run_edit_test('beginning-of-buffer')
end

assert('end-of-buffer') do
  run_edit_test('end-of-buffer')
end

assert('newline') do
  run_edit_test('newline')
end
  
assert('beginning-of-line') do
end

assert('end-of-line.el') do
end

assert('find-file') do
end

assert('insert-file') do
end

assert('kill-buffer') do
end

assert('kill-line') do
end

assert('isearch-backward') do
end

assert('isearch-forward') do
end

assert('switch-to-buffer') do
end

assert('yank') do
end