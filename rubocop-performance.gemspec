# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rubocop/performance/version'

Gem::Specification.new do |s|
  s.name = 'rubocop-performance'
  s.version = RuboCop::Performance::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7.0'
  s.authors = ['Bozhidar Batsov', 'Jonas Arvidsson', 'Yuji Nakayama']
  s.description = <<~DESCRIPTION
    A collection of RuboCop cops to check for performance optimizations
    in Ruby code.
  DESCRIPTION

  s.email = 'rubocop@googlegroups.com'
  s.files = Dir['LICENSE.txt', 'README.md', 'config/**/*', 'lib/**/*']
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.homepage = 'https://github.com/rubocop/rubocop-performance'
  s.licenses = ['MIT']
  s.summary = 'Automatic performance checking tool for Ruby code.'

  s.metadata = {
    'homepage_uri' => 'https://docs.rubocop.org/rubocop-performance/',
    'changelog_uri' => 'https://github.com/rubocop/rubocop-performance/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/rubocop/rubocop-performance/',
    'documentation_uri' => "https://docs.rubocop.org/rubocop-performance/#{RuboCop::Performance::Version.document_version}/",
    'bug_tracker_uri' => 'https://github.com/rubocop/rubocop-performance/issues',
    'rubygems_mfa_required' => 'true'
  }

  s.add_runtime_dependency('rubocop', '>= 1.7.0', '< 2.0')
  s.add_runtime_dependency('rubocop-ast', '>= 1.30.0', '< 2.0')
end
