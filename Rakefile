require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "tests"
  t.test_files = FileList['tests/test*.rb', 'tests/pre_dojo/test*.rb']
  t.verbose = true
end