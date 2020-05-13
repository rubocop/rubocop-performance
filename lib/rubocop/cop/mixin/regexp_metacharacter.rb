# frozen_string_literal: true

module RuboCop
  module Cop
    # Common functionality for handling regexp metacharacters.
    module RegexpMetacharacter
      def literal_at_start?(regex_str)
        # is this regexp 'literal' in the sense of only matching literal
        # chars, rather than using metachars like `.` and `*` and so on?
        # also, is it anchored at the start of the string?
        # (tricky: \s, \d, and so on are metacharacters, but other characters
        #  escaped with a slash are just literals. LITERAL_REGEX takes all
        #  that into account.)
        regex_str =~ /\A(\\A|\^)(?:#{Util::LITERAL_REGEX})+\z/
      end

      def literal_at_end?(regex_str)
        # is this regexp 'literal' in the sense of only matching literal
        # chars, rather than using metachars like . and * and so on?
        # also, is it anchored at the end of the string?
        regex_str =~ /\A(?:#{Util::LITERAL_REGEX})+(\\z|\$)\z/
      end

      def drop_start_metacharacter(regexp_string)
        if regexp_string.start_with?('\\A')
          regexp_string[2..-1] # drop `\A` anchor
        else
          regexp_string[1..-1] # drop `^` anchor
        end
      end

      def drop_end_metacharacter(regexp_string)
        if regexp_string.end_with?('\\z')
          regexp_string.chomp('\z') # drop `\z` anchor
        else
          regexp_string.chop # drop `$` anchor
        end
      end
    end
  end
end
