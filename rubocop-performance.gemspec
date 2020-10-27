# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'rubocop/performance/version'

Gem::Specification.new do |s|
  s.name = 'rubocop-performance'
  s.version = RuboCop::Performance::Version::STRING
  s.platform = Gem::Platform::RUBY

  # Using EOL Ruby versions is (gem, application) users choice
  # (of course, not recommended).
  # We will support them for one year after EOL for migration.
  # Ruby 2.4 support will end at March 31, 2021:
  # https://www.ruby-lang.org/en/news/2020/04/05/support-of-ruby-2-4-has-ended/
  s.required_ruby_version = '>= 2.4.0'

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
    'homepage_uri' => 'https://docs.rubocop.org/rubocop-performance/',
    'changelog_uri' => 'https://github.com/rubocop-hq/rubocop-performance/blob/master/CHANGELOG.md',
    'source_code_uri' => 'https://github.com/rubocop-hq/rubocop-performance/',
    # rubocop:disable Layout/LineLength
    'documentation_uri' => "https://docs.rubocop.org/rubocop-performance/#{RuboCop::Performance::Version.document_version}/",
    # rubocop:enable Layout/LineLength
    'bug_tracker_uri' => 'https://github.com/rubocop-hq/rubocop-performance/issues'
  }

  s.add_runtime_dependency('rubocop', '~> 0.93.1')
  s.add_development_dependency('rubocop-rspec', '~> 1.44')
  s.add_development_dependency('simplecov', '~> 0.18.0')
end
