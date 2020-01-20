# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rubocop/performance/version'

Gem::Specification.new do |s|
  s.name = 'rubocop-performance'
  s.version = RuboCop::Performance::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.0'
  s.authors = ['Bozhidar Batsov', 'Jonas Arvidsson', 'Yuji Nakayama']
  s.description = <<~DESCRIPTION
    A collection of RuboCop cops to check for performance optimizations
    in Ruby code.
  DESCRIPTION

  s.email = 'rubocop@googlegroups.com'
  s.files = `git ls-files -z config lib LICENSE.txt README.md`.split("\x0")
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.homepage = 'https://github.com/rubocop-hq/rubocop-performance'
  s.licenses = ['MIT']
  s.summary = 'Automatic performance checking tool for Ruby code.'

  s.metadata = {
    'homepage_uri' => 'https://docs.rubocop.org/projects/performance',
    'changelog_uri' => 'https://github.com/rubocop-hq/rubocop-performance/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/rubocop-hq/rubocop-performance/',
    'documentation_uri' => 'https://docs.rubocop.org/projects/performance',
    'bug_tracker_uri' => 'https://github.com/rubocop-hq/rubocop-performance/issues'
  }

  s.add_runtime_dependency('rubocop', '>= 0.71.0')
  s.add_development_dependency('simplecov')
end
