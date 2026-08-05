# frozen_string_literal: true

module RuboCop
  module Cop
    # Autoloads mixin modules included by cops. Mixins are autoloaded to reduce the number of requires
    # because they're used only when the relevant cop class is loaded.
    autoload :RegexpMetacharacter, "#{__dir__}/mixin/regexp_metacharacter"
    autoload :SortBlock, "#{__dir__}/mixin/sort_block"
  end
end
