require 'open3'
require 'fileutils'
require 'timeout'

$script_dir = "#{File.dirname(__FILE__)}/scripts/"
$capture_file = "#{File.dirname(__FILE__)}/.capture"

def curses_run(args, timeout: 30)
  stdout = stderr = status = nil
  Timeout.timeout(timeout) do
    stdout, stderr, status = Open3.capture3("#{cmd('mrbmacs-curses')} #{args}")
  end
  [stdout, stderr, status]
end

def assert_run_ok(status, stderr)
  assert_true status.to_i == 0,
              "mrbmacs-curses did not exit cleanly: #{status.inspect}\n#{stderr}"
end

# Run a -l script that reports lines through ENV['MRBMACS_BINTEST_OUT'].
# Scripts are shared with the termbox frontend, which needs a file because its
# PTY merges every stream, so the same channel is used here.
def curses_capture(script)
  File.delete($capture_file) if File.exist?($capture_file)
  ENV['MRBMACS_BINTEST_OUT'] = $capture_file
  _stdout, stderr, status = curses_run("-q -l #{$script_dir}#{script}")
  assert_run_ok(status, stderr)
  File.exist?($capture_file) ? File.read($capture_file).split("\n") : []
end

# Copy +input_file+ aside, let +test_name+ edit and save it, then compare the
# saved bytes with the recorded expectation.
def run_edit_test(test_name, input_file = 'test.input')
  edit_file = "#{File.dirname(__FILE__)}/#{test_name}.input"
  output_file = "#{$script_dir}#{test_name}.output"
  FileUtils.cp "#{File.dirname(__FILE__)}/#{input_file}", edit_file
  _stdout, stderr, status = curses_run("-q -l #{$script_dir}#{test_name} #{edit_file}")
  assert_run_ok(status, stderr)
  assert_equal File.read(output_file), File.read(edit_file)
  File.delete edit_file
end

assert('report the generated frontend version') do
  version_file = File.join(
    ENV.fetch('BUILD_DIR'), 'mrbgems', GEMNAME, 'version.txt'
  )
  expected_version = File.read(version_file).strip
  stdout, stderr, status = Open3.capture3(
    "#{cmd('mrbmacs-curses')} --version"
  )

  assert_equal 0, status.to_i
  assert_equal '', stderr
  assert_equal expected_version, stdout.strip
end

assert('every non-interactive command runs against the real Scintilla') do
  lines = curses_capture('all-commands')

  failures = lines.select { |line| line.start_with?('NG ') }
  assert_equal [], failures
  # A base command in neither the allow nor the skip list needs a decision.
  undecided = lines.select { |line| line.start_with?('UNLISTED ') }
  assert_equal [], undecided
  # Without the trailing marker the script stopped early; the last line names
  # the command it was running.
  assert_true lines.include?('done'),
              "all-commands stopped at: #{lines.last.inspect}"
end

assert('edit-japanese') do
  run_edit_test('edit-japanese')
end

assert('rectangle') do
  run_edit_test('rectangle')
end

assert('comment') do
  run_edit_test('comment', 'test2.input')
end

assert('eol-crlf') do
  run_edit_test('eol-crlf', 'test-utf8-dos.input')
end

assert('encoding-cp932') do
  run_edit_test('encoding-cp932')
end

assert('window') do
  # The script reports any ERROR line logged while splitting and closing.
  assert_equal [], curses_capture('window')
end
