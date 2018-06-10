# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rubocop-performance/version'

Gem::Specification.new do |s|
  s.name = 'rubocop-performance'
  s.version = RuboCopPerformance::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.1.0'
  s.authors = ['Bozhidar Batsov', 'Jonas Arvidsson', 'Yuji Nakayama']
  s.description = <<-DESCRIPTION
    A RuboCop plugin to check for performance optimizations in Ruby code.
  DESCRIPTION

  s.email = 'rubocop@googlegroups.com'
  s.files = `git ls-files config lib LICENSE.txt README.md`.split($RS)
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.homepage = 'https://github.com/rubocop-hq/rubocop-performance'
  s.licenses = ['MIT']
  s.summary = 'Automatic Ruby code performance checking tool.'

  s.metadata = {
    'homepage_uri' => 'https://rubocop-performance.readthedocs.io/',
    'changelog_uri' => 'https://github.com/rubocop-hq/rubocop-performance/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/rubocop-hq/rubocop-performance/',
    'documentation_uri' => 'https://rubocop-performance.readthedocs.io/',
    'bug_tracker_uri' => 'https://github.com/rubocop-hq/rubocop-performance/issues'
  }

  s.add_runtime_dependency('rubocop', '>= 0.57')
  s.add_development_dependency('bundler', '~> 1.3')
  s.add_development_dependency('rspec', '~> 3.7')
  s.add_development_dependency('rubocop-rspec', '~> 1.26')
end
