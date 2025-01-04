# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/performance'
require_relative 'rubocop/performance/version'

# FIXME: When RuboCop Rails requires RuboCop 1.72.0+ only, the following compatibility code can be removed.
if RuboCop.const_defined?(:Plugin)
  require_relative 'rubocop/performance/plugin'
else
  # NOTE: Until the plugin stabilizes, an option to use the older version of RuboCop is provided.
  # The plugin will be unified in the future.
  require_relative 'rubocop/performance/inject'

  RuboCop::Performance::Inject.defaults!
end

require_relative 'rubocop/cop/performance_cops'

RuboCop::Cop::Lint::UnusedMethodArgument.singleton_class.prepend(
  Module.new do
    def autocorrect_incompatible_with
      super.push(RuboCop::Cop::Performance::BlockGivenWithExplicitBlock)
    end
  end
)
