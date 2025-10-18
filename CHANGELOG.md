# Change log

<!---
  Do NOT edit this CHANGELOG.md file by hand directly, as it is automatically updated.

  Please add an entry file to the https://github.com/rubocop/rubocop-performance/blob/master/changelog/
  named `{change_type}_{change_description}.md` if the new code introduces user-observable changes.

  See https://github.com/rubocop/rubocop-performance/blob/master/CONTRIBUTING.md#changelog-entry-format for details.
-->

## master (unreleased)

## 1.26.1 (2025-10-18)

### Bug fixes

* [#517](https://github.com/rubocop/rubocop-performance/issues/517): Fix false positives for `Performance/RedundantStringChars` when using `str.chars[0, 2]`. ([@koic][])

### Changes

* [#520](https://github.com/rubocop/rubocop-performance/issues/520): Disable `Performance/BigDecimalWithNumericArgument` by default. ([@earlopain][])

## 1.26.0 (2025-09-06)

### Bug fixes

* [#444](https://github.com/rubocop/rubocop-performance/issues/444): Fix an incorrect autocorrect for `Performance/BlockGivenWithExplicitBlock` when using `Naming/BlockForwarding`'s autocorrection together. ([@a-lavis][])
* [#500](https://github.com/rubocop/rubocop-performance/issues/500): Mark `Performance/MapCompact` cop as unsafe. ([@jbpextra][])
* [#498](https://github.com/rubocop/rubocop-performance/pull/498): Fix `Performance/Count` cop error on empty selector block. ([@viralpraxis][])
* [#504](https://github.com/rubocop/rubocop-performance/pull/504): Fix autocorrection syntax error for `Performance/Count` with multiline calls. ([@lovro-bikic][])

### Changes

* [#512](https://github.com/rubocop/rubocop-performance/issues/512): Detect negated conditions like `!foo.start_with('bar') && !foo.start_with('baz')` with `Performance/DoubleStartEndWith`. ([@earlopain][])

## 1.25.0 (2025-04-01)

### New features

* [#496](https://github.com/rubocop/rubocop-performance/pull/496): Support `it` block parameter in `Performance` cops. ([@koic][])

### Bug fixes

* [#494](https://github.com/rubocop/rubocop-performance/pull/494): Fix `Performance/FixedSize` false positive when `count` is called with a `numblock`. ([@dvandersluis][])
* [#492](https://github.com/rubocop/rubocop-performance/issues/492): Fix false positives for `Performance/StringIdentifierArgument` when using interpolated string argument. ([@koic][])

### Changes

* [#482](https://github.com/rubocop/rubocop-performance/issues/482): Change `Performance/CollectionLiteralInLoop` to not register offenses for `Array#include?` that are optimized directly in Ruby. ([@earlopain][])

## 1.24.0 (2025-02-16)

### New features

* [#490](https://github.com/rubocop/rubocop-performance/pull/490): Pluginfy RuboCop Performance. ([@koic][])
* [#462](https://github.com/rubocop/rubocop-performance/pull/462): Add new `Performance/ZipWithoutBlock` cop that checks patterns like `.map { |id| [id] }` or `.map { [_1] }` and can replace them with `.zip`. ([@corsonknowles][])

### Bug fixes

* [#484](https://github.com/rubocop/rubocop-performance/pull/484): Fix `Performance/CaseWhenSplat` cop error on `when` node without body. ([@viralpraxis][])

## 1.23.1 (2025-01-04)

### Bug fixes

* [#478](https://github.com/rubocop/rubocop-performance/pull/478): Fix `Performance/RedundantStringChars` cop error in case of implicit receiver. ([@viralpraxis][])
* [#480](https://github.com/rubocop/rubocop-performance/pull/480): Fix `Performance/Squeeze` cop error on frozen AST string node value. ([@viralpraxis][])

## 1.23.0 (2024-11-14)

### New features

* [#474](https://github.com/rubocop/rubocop-performance/pull/474): Add new `Performance/StringBytesize` cop. ([@viralpraxis][])

## 1.22.1 (2024-09-17)

### Bug fixes

* [#468](https://github.com/rubocop/rubocop-performance/issues/468): Fix false positives for `Performance/BigDecimalWithNumericArgument` when using float argument for `BigDecimal`. ([@koic][])

## 1.22.0 (2024-09-16)

### Bug fixes

* [#454](https://github.com/rubocop/rubocop-performance/issues/454): Fix false positives for `Performance/BigDecimalWithNumericArgument` when using BigDecimal 3.1+. ([@koic][])

### Changes

* [#385](https://github.com/rubocop/rubocop-performance/issues/385): Disable `Performance/BlockGivenWithExplicitBlock` by default. ([@earlopain][])
* [#407](https://github.com/rubocop/rubocop-performance/issues/407): Make `Performance/DoubleStartEndWith` aware of safe navigation. ([@earlopain][])

## 1.21.1 (2024-06-16)

### Bug fixes

* [#452](https://github.com/rubocop/rubocop-performance/pull/452): Fix an error for `Performance/RedundantEqualityComparisonBlock` when the block is empty. ([@earlopain][])

## 1.21.0 (2024-03-30)

### New features

* [#446](https://github.com/rubocop/rubocop-performance/pull/446): Support Prism as a Ruby parser (experimental). ([@koic][])

### Bug fixes

* [#437](https://github.com/rubocop/rubocop-performance/issues/437): Fix a false positive for `Performance/ChainArrayAllocation` when using `select` with block argument after `select`. ([@koic][])
* [#448](https://github.com/rubocop/rubocop-performance/issues/448): Fix a false positive for `Performance/RedundantBlockCall` when using `block.call` with block argument. ([@koic][])

### Changes

* [#240](https://github.com/rubocop/rubocop-performance/issues/240): Disable `Performance/Casecmp` cop by default. ([@parkerfinch][])

## 1.20.2 (2024-01-08)

### Bug fixes

* [#425](https://github.com/rubocop/rubocop-performance/issues/425): Fix a false positive for `Performance/StringIdentifierArgument` when using string interpolation with methods that don't support symbols with `::` inside them. ([@earlopain][])

## 1.20.1 (2023-12-25)

### Bug fixes

* [#428](https://github.com/rubocop/rubocop-performance/pull/428): Fix false negatives for `Performance/StringIdentifierArgument` when using multiple string arguments. ([@koic][])

## 1.20.0 (2023-12-16)

### New features

* [#384](https://github.com/rubocop/rubocop-performance/issues/384): Support optimized `String#dup` for `Performance/UnfreezeString` when Ruby 3.3+. ([@koic][])

### Bug fixes

* [#374](https://github.com/rubocop/rubocop-performance/issues/374): Fix an error for `Performance/MapMethodChain` when using `map` method chain without receiver. ([@koic][])
* [#386](https://github.com/rubocop/rubocop-performance/issues/386): Fix a false negative for `Performance/StringIdentifierArgument` when using string interpolation. ([@earlopain][])
* [#419](https://github.com/rubocop/rubocop-performance/pull/419): Make `Performance/Count`, `Performance/FixedSize`, `Performance/FlatMap`, `Performance/InefficientHashSearch`, `Performance/RangeInclude`, `Performance/RedundantSortBlock`, `Performance/ReverseFirst`, `Performance/SelectMap`, `Performance/Size`, `Performance/SortReverse`, and `Performance/TimesMap` cops aware of safe navigation operator. ([@koic][])
* [#390](https://github.com/rubocop/rubocop-performance/issues/390): Fix a false negative for `Performance/ReverseEach` when safe navigation is between `reverse` and `each`. ([@fatkodima][])
* [#401](https://github.com/rubocop/rubocop-performance/issues/401): Make `Performance/Sum` aware of safe navigation operator. ([@koic][])

### Changes

* [#389](https://github.com/rubocop/rubocop-performance/issues/389): Improve `Performance/MapCompact` to handle more safe navigation calls. ([@fatkodima][])
* [#395](https://github.com/rubocop/rubocop-performance/issues/395): Enhance `Performance/StringInclude` to handle `===` method. ([@fatkodima][])
* [#388](https://github.com/rubocop/rubocop-performance/pull/388): Require RuboCop 1.30+ as runtime dependency. ([@koic][])
* [#380](https://github.com/rubocop/rubocop-performance/pull/380): Require RuboCop AST 1.30.0+. ([@koic][])

## 1.19.1 (2023-09-17)

### Bug fixes

* [#367](https://github.com/rubocop/rubocop-performance/issues/367): Fix an incorrect autocorrect for `Performance/BlockGivenWithExplicitBlock` when using `Lint/UnusedMethodArgument`'s autocorrection together. ([@ymap][])
* [#370](https://github.com/rubocop/rubocop-performance/issues/370): Fix an incorrect autocorrect for `Performance/RedundantMatch` when expressions with lower precedence than `=~` are used as an argument. ([@ymap][])
* [#365](https://github.com/rubocop/rubocop-performance/issues/365): Fix false positives for `Performance/ArraySemiInfiniteRangeSlice` when using `[]` with string literals. ([@koic][])
* [#373](https://github.com/rubocop/rubocop-performance/pull/373): Set target version for `Performance/UnfreezeString`. ([@tagliala][])

## 1.19.0 (2023-08-13)

### New features

* [#364](https://github.com/rubocop/rubocop-performance/pull/364): Add new `Performance/MapMethodChain` cop. ([@koic][])
* [#363](https://github.com/rubocop/rubocop-performance/pull/363): Support safe navigation operator for `Performance/ArraySemiInfiniteRangeSlice`, `Performance/DeletePrefix`, `Performance/DeleteSuffix`, `Performance/Detect`, `Performance/EndWith`, `Performance/InefficientHashSearch`, `Performance/MapCompact`, `Performance/RedundantSplitRegexpArgument`, `Performance/ReverseEach`, `Performance/ReverseFirst`, `Performance/SelectMap`, `Performance/Squeeze`, `Performance/StartWith`, `Performance/StringInclude`, and `Performance/StringReplacement` cops. ([@koic][])

## 1.18.0 (2023-05-21)

### Bug fixes

* [#359](https://github.com/rubocop/rubocop-performance/issues/359): Fix a false positive for `Performance/RedundantEqualityComparisonBlock` when the block variable is used on both sides of `==`. ([@koic][])
* [#351](https://github.com/rubocop/rubocop-performance/issues/351): Fix an incorrect autocorrect for `Performance/ConstantRegexp` and `Performance/RegexpMatch` when autocorrecting both at the same time. ([@fatkodima][])

### Changes

* [#357](https://github.com/rubocop/rubocop-performance/pull/357): Add `sort!` and `minmax` to `Performance/CompareWithBlock`. ([@vlad-pisanov][])
* [#353](https://github.com/rubocop/rubocop-performance/pull/353): **(Breaking)** Drop Ruby 2.6 support. ([@koic][])

## 1.17.1 (2023-04-09)

### Bug fixes

* [#352](https://github.com/rubocop/rubocop-performance/pull/352): Fix the default config for `AllowRegexpMatch` option of `Performance/RedundantEqualityComparisonBlock`. ([@koic][])

## 1.17.0 (2023-04-09)

### New features

* [#347](https://github.com/rubocop/rubocop-performance/pull/347): Add `AllowRegexpMatch` option to `Performance/RedundantEqualityComparisonBlock`. ([@koic][])

### Bug fixes

* [#346](https://github.com/rubocop/rubocop-performance/issues/346): Fix a false positive for `Performance/StringIdentifierArgument` when using a command method with receiver. ([@koic][])
* [#344](https://github.com/rubocop/rubocop-performance/issues/344): Fix `Performance/FlatMap` autocorrection for chained methods on separate lines. ([@fatkodima][])

## 1.16.0 (2023-02-06)

### Changes

* [#332](https://github.com/rubocop/rubocop-performance/pull/332): Register offenses for variables against regexes in `Performance/StringInclude`. ([@fatkodima][])

## 1.15.2 (2022-12-25)

### Bug fixes

* [#313](https://github.com/rubocop/rubocop-performance/issues/313): Fix a false negative for `Performance/RedundantStringChars` when using `str.chars.last` without argument. ([@koic][])
* [#321](https://github.com/rubocop/rubocop-performance/pull/321): Fix a false positive for `Performance/Sum` when using `TargetRubyVersion` is 2.3 or lower. ([@koic][])
* [#314](https://github.com/rubocop/rubocop-performance/issues/314): Fix `Performance/RegexpMatch` to handle `::Regexp`. ([@fatkodima][])

### Changes

* [#318](https://github.com/rubocop/rubocop-performance/issues/318): Extend `Performance/StringInclude` to handle `!~`. ([@fatkodima][])

## 1.15.1 (2022-11-16)

### Bug fixes

* [#309](https://github.com/rubocop/rubocop-performance/issues/309): Fix an error for `Performance/MapCompact` when using `map(&:do_something).compact` and there is a line break after `map.compact` and assigning with `||=`. ([@koic][])

### Changes

* [#307](https://github.com/rubocop/rubocop-performance/pull/307): Support autocorrection even if `reject` is used on `Performance/Count`. ([@r7kamura][])

## 1.15.0 (2022-09-10)

### New features

* [#305](https://github.com/rubocop/rubocop-performance/pull/305): Support numbered parameter for `Performance/RedundantSortBlock`, `Performance/SortReverse`, and `Performance/TimesMap` cops. ([@koic][])

### Bug fixes

* [#299](https://github.com/rubocop/rubocop-performance/pull/299): Fix incorrect documentation URLs when using `rubocop --show-docs-url`. ([@r7kamura][])

### Changes

* [#297](https://github.com/rubocop/rubocop-performance/pull/297): Support autocorrection on `Performance/RedundantMatch` when receiver is a Regexp literal. ([@r7kamura][])

## 1.14.3 (2022-07-17)

### Bug fixes

* [#296](https://github.com/rubocop/rubocop-performance/pull/296): Fix a false negative for `Performance/StringIdentifierArgument` when using `instance_variable_defined?`. ([@koic][])
* [#294](https://github.com/rubocop/rubocop-performance/pull/294): Fix a false negative for `Performance/ChainArrayAllocation` when using `array.first(do_something).uniq`. ([@koic][])

## 1.14.2 (2022-06-08)

### Bug fixes

* [#292](https://github.com/rubocop/rubocop-performance/pull/292): Fix a false positive for `Performance/RegexpMatch` when `TargetRubyVersion: 2.3`. ([@koic][])

## 1.14.1 (2022-06-05)

### Bug fixes

* [#291](https://github.com/rubocop/rubocop-performance/pull/291): Fix `Performance/MapCompact` autocorrect causing invalid syntax when using multiline `map { ... }.compact` as an argument for an assignment method. ([@QQism][])

## 1.14.0 (2022-05-24)

### Bug fixes

* [#289](https://github.com/rubocop/rubocop-performance/issues/289): Fix a false positive for `Performance/StringIdentifierArgument` when using namespaced class string argument. ([@koic][])
* [#288](https://github.com/rubocop/rubocop-performance/pull/288): Recover Ruby 2.4 code analysis using `TargetRubyVersion: 2.4`. ([@koic][])

### Changes

* [#287](https://github.com/rubocop/rubocop-performance/pull/287): **(Compatibility)** Drop Ruby 2.5 support. ([@koic][])

## 1.13.3 (2022-03-05)

### Bug fixes

* [#285](https://github.com/rubocop/rubocop-performance/pull/285): Fix an error for `Performance/MapCompact` when using `map(&:do_something).compact.first` and there is a line break after `map.compact` and receiver. ([@ydah][])

## 1.13.2 (2022-01-16)

### Bug fixes

* [#281](https://github.com/rubocop/rubocop-performance/issues/281): Fix an error for `Performance/BlockGivenWithExplicitBlock` when using Ruby 3.1's anonymous block forwarding. ([@koic][])

## 1.13.1 (2022-01-01)

### Bug fixes

* [#278](https://github.com/rubocop/rubocop-performance/issues/278): Fix a false positive for `Performance/StringIdentifierArgument` when using `attr`. ([@koic][])

## 1.13.0 (2021-12-25)

### New features

* [#276](https://github.com/rubocop/rubocop-performance/pull/276): Add new `Performance/StringIdentifierArgument` cop. ([@koic][])
* [#204](https://github.com/rubocop/rubocop-performance/issues/204): Add `Performance/Sum` option to ignore potential false positives. ([@leoarnold][])
* [#269](https://github.com/rubocop/rubocop-performance/pull/269): Add `#to_d` support to `BigDecimalWithNumericArgument`. ([@leoarnold][])

### Bug fixes

* [#277](https://github.com/rubocop/rubocop-performance/pull/277): Fix an incorrect autocorrect for `Performance/MapCompact` when using `map.compact.first` and there is a line break after `map.compact` and receiver. ([@koic][])
* [#273](https://github.com/rubocop/rubocop-performance/pull/273): Fix an incorrect autocorrect for `Performance/RedundantStringChars` when using `str.chars[0]`. ([@koic][])

### Changes

* [#270](https://github.com/rubocop/rubocop-performance/pull/270): Mark `Performance/Sum` auto-correction as unsafe and extend documentation. ([@leoarnold][])
* [#274](https://github.com/rubocop/rubocop-performance/pull/274): Unmark `AutoCorrect: false` from `Performance/CaseWhenSplat`. ([@koic][])
* [#275](https://github.com/rubocop/rubocop-performance/pull/275): Unmark `AutoCorrect: false` from `Performance/TimesMap`. ([@koic][])

## 1.12.0 (2021-10-31)

### New features

* [#267](https://github.com/rubocop/rubocop-performance/pull/267): Add new `Performance/ConcurrentMonotonicTime` cop. ([@koic][])

### Bug fixes

* [#261](https://github.com/rubocop/rubocop-performance/issues/261): Fix a false negative for `Performance/RedundantBlockCall` when using `block.call` in a class method'. ([@koic][])
* [#264](https://github.com/rubocop/rubocop-performance/pull/264): Fix error in Performance/Sum when method has no brackets. ([@mvz][])

### Changes

* [#263](https://github.com/rubocop/rubocop-performance/pull/263): Unmark `AutoCorrect: false` from `Performance/StringInclude`. ([@koic][])

## 1.11.5 (2021-08-18)

### Bug fixes

* [#255](https://github.com/rubocop/rubocop-performance/issues/255): Fix a false positive for `Performance/RedundantEqualityComparisonBlock` when using block argument is used for an argument of operand. ([@koic][])
* [#257](https://github.com/rubocop/rubocop-performance/issues/257): Fix an incorrect auto-correct for `Performance/MapCompact` when using multi-line `collection.map { ... }.compact` as a method argument. ([@koic][])

## 1.11.4 (2021-07-07)

### Bug fixes

* [#247](https://github.com/rubocop/rubocop-performance/issues/247): Fix an incorrect auto-correct for `Performance/MapCompact` when using multi-line trailing dot method calls. ([@koic][])
* [#249](https://github.com/rubocop/rubocop-performance/issues/249): Fix a false positive for `Performance/RedundantStringChars` when using `str.chars.last` and `str.chars.drop`. ([@koic][])
* [#252](https://github.com/rubocop/rubocop-performance/issues/252): Fix an incorrect auto-correct for `Performance/UnfreezeString` when invoking a method after `String.new` with a string. ([@koic][])

### Changes

* [#245](https://github.com/rubocop/rubocop-performance/issues/245): Mark `Performance/DeletePrefix` and `Performance/DeleteSuffix` as unsafe. ([@koic][])

## 1.11.3 (2021-05-06)

### Bug fixes

* [#242](https://github.com/rubocop/rubocop-performance/issues/242): Fix an error for `Performance/MapCompact` when using multiline `map { ... }.compact` and assigning to return value. ([@koic][])

## 1.11.2 (2021-05-05)

### Bug fixes

* [#238](https://github.com/rubocop/rubocop-performance/issues/238): Fix an incorrect auto-correct for `Performance/MapCompact` when invoking a method after `map { ... }.compact` on the same line. ([@koic][])

## 1.11.1 (2021-05-02)

### Bug fixes

* [#236](https://github.com/rubocop/rubocop-performance/issues/236): Fix an incorrect auto-correct for `Performance/MapCompact` when using multi-line leading dot method calls. ([@koic][])

## 1.11.0 (2021-04-22)

### New features

* [#229](https://github.com/rubocop/rubocop-performance/pull/229): Add new `Performance/MapCompact` cop. ([@koic][])
* [#178](https://github.com/rubocop/rubocop-performance/issues/178): Add new `Performance/SelectMap` cop. ([@koic][])

### Bug fixes

* [#230](https://github.com/rubocop/rubocop-performance/issues/230): Fix a false positive for `Performance/ChainArrayAllocation` when using `Enumerable#lazy`. ([@koic][])

### Changes

* [#228](https://github.com/rubocop/rubocop-performance/pull/228): Mark `Performance/RedundantMerge` as unsafe. ([@dvandersluis][])
* [#232](https://github.com/rubocop/rubocop-performance/pull/232): **(Compatibility)** Drop Ruby 2.4 support. ([@koic][])
* [#235](https://github.com/rubocop/rubocop-performance/pull/235): Require RuboCop 1.7 or higher. ([@koic][])

## 1.10.2 (2021-03-23)

### Bug fixes

* [#162](https://github.com/rubocop/rubocop-performance/issues/162): Fix a false positive for `Performance/RedundantBlockCall` when an optional block that is overridden by block variable. ([@koic][])
* [#36](https://github.com/rubocop/rubocop-performance/issues/36): Fix a false positive for `Performance/ReverseEach` when `each` is called on `reverse` and using the result value. ([@koic][])
* [#224](https://github.com/rubocop/rubocop-performance/pull/224): Fix a false positive for `Style/RedundantEqualityComparisonBlock` when using one argument with comma separator in block argument. ([@koic][])
* [#225](https://github.com/rubocop/rubocop-performance/issues/225): Fix a false positive for `Style/RedundantEqualityComparisonBlock` when using `any?` with `===` comparison block and block argument is not used as a receiver for `===`. ([@koic][])
* [#222](https://github.com/rubocop/rubocop-performance/issues/222): Fix a false positive for `Performance/RedundantSplitRegexpArgument` when `split` method argument is exactly one space regexp `/ /`. ([@koic][])

## 1.10.1 (2021-03-02)

### Bug fixes

* [#214](https://github.com/rubocop/rubocop-performance/issues/214): Fix a false positive for `Performance/RedundantEqualityComparisonBlock` when using multiple block arguments. ([@koic][])
* [#216](https://github.com/rubocop/rubocop-performance/issues/216): Fix a false positive for `Performance/RedundantSplitRegexpArgument` when using split method with ignore case regexp option. ([@koic][])
* [#217](https://github.com/rubocop/rubocop-performance/issues/217): Fix a false positive for `Performance/RedundantEqualityComparisonBlock` when using block argument is used for an argument of `is_a`. ([@koic][])

## 1.10.0 (2021-03-01)

### New features

* [#190](https://github.com/rubocop/rubocop-performance/pull/190): Add new `Performance/RedundantSplitRegexpArgument` cop. ([@mfbmina][])
* [#213](https://github.com/rubocop/rubocop-performance/pull/213): Add new `Performance/RedundantEqualityComparisonBlock` cop. ([@koic][])

### Bug fixes

* [#207](https://github.com/rubocop/rubocop-performance/issues/207): Fix an error for `Performance/Sum` when using `map(&do_something).sum` without receiver. ([@koic][])
* [#210](https://github.com/rubocop/rubocop-performance/pull/210): Fix a false negative for `Performance/BindCall` when receiver is not a method call. ([@koic][])

### Changes

* [#205](https://github.com/rubocop/rubocop-performance/issues/205): Update `Performance/ConstantRegexp` to allow memoized regexps. ([@dvandersluis][])
* [#212](https://github.com/rubocop/rubocop-performance/pull/212): Enable unsafe auto-correct for `Performance/StartWith` and `Performance/EndWith` cops by default. ([@koic][])

## 1.9.2 (2021-01-01)

### Bug fixes

* [#201](https://github.com/rubocop/rubocop-performance/pull/201): Fix an incorrect auto-correct for `Performance/ReverseEach` when using multi-line `reverse.each` with leading dot. ([@koic][])

## 1.9.1 (2020-11-28)

### Bug fixes

* [#185](https://github.com/rubocop/rubocop-performance/issues/185): Fix incorrect replacement recommendation for `Performance/ChainArrayAllocation`. ([@fatkodima][])

### Changes

* [#197](https://github.com/rubocop/rubocop-performance/issues/197): Disable `Performance/ArraySemiInfiniteRangeSlice` cop. ([@tejasbubane][])

## 1.9.0 (2020-11-17)

### New features

* [#173](https://github.com/rubocop/rubocop-performance/pull/173): Add new `Performance/BlockGivenWithExplicitBlock` cop. ([@fatkodima][])
* [#136](https://github.com/rubocop/rubocop-performance/issues/136): Add new `Performance/MethodObjectAsBlock` cop. ([@fatkodima][])
* [#151](https://github.com/rubocop/rubocop-performance/issues/151): Add new `Performance/ConstantRegexp` cop. ([@fatkodima][])
* [#175](https://github.com/rubocop/rubocop-performance/pull/175): Add new `Performance/ArraySemiInfiniteRangeSlice` cop. ([@fatkodima][])
* [#189](https://github.com/rubocop/rubocop-performance/pull/189): Support auto-correction for `Performance/Caller`. ([@koic][])
* [#171](https://github.com/rubocop/rubocop-performance/issues/171): Extend auto-correction support for `Performance/Sum`. ([@koic][])
* [#194](https://github.com/rubocop/rubocop-performance/pull/194): Support auto-correction for `Performance/UnfreezeString`. ([@koic][])

### Changes

* [#181](https://github.com/rubocop/rubocop-performance/pull/181): Change default configuration for `Performance/CollectionLiteralInLoop` to `Enabled: 'pending'`. ([@ghiculescu][])
* [#170](https://github.com/rubocop/rubocop-performance/pull/170): Extend `Performance/Sum` to register an offense for `map { ... }.sum`. ([@eugeneius][])
* [#179](https://github.com/rubocop/rubocop-performance/pull/179): Change `Performance/Sum` to warn about empty arrays, and not register an offense on empty array literals. ([@ghiculescu][])
* [#180](https://github.com/rubocop/rubocop-performance/pull/180): Require RuboCop 0.90 or higher. ([@koic][])

## 1.8.1 (2020-09-19)

### Bug fixes

* [#164](https://github.com/rubocop/rubocop-performance/pull/164): Fix an error for `Performance/CollectionLiteralInLoop` when a method from `Enumerable` is called with no receiver. ([@eugeneius][])
* [#165](https://github.com/rubocop/rubocop-performance/issues/165): Fix a false positive for `Performance/Sum` when using initial value argument is a variable. ([@koic][])

### Changes

* [#163](https://github.com/rubocop/rubocop-performance/pull/163): Change `Performance/Detect` to also detect offenses when index 0 or -1 is used instead (ie. `detect{ ... }[0]`). ([@dvandersluis][])
* [#168](https://github.com/rubocop/rubocop-performance/pull/168): Extend `Performance/Sum` to register an offense for `inject(&:+)`. ([@eugeneius][])

## 1.8.0 (2020-09-04)

### New features

* [#140](https://github.com/rubocop/rubocop-performance/pull/140): Add new `Performance/CollectionLiteralInLoop` cop. ([@fatkodima][])
* [#137](https://github.com/rubocop/rubocop-performance/pull/137): Add new `Performance/Sum` cop. ([@fatkodima][])

### Bug fixes

* [#159](https://github.com/rubocop/rubocop-performance/pull/159): Fix a false positive for `Performance/AncestorsInclude` when receiver is a variable. ([@koic][])

### Changes

* [#157](https://github.com/rubocop/rubocop-performance/pull/157): Extend `Performance/Detect` cop with check for `filter` method and `Performance/Count` cop with checks for `find_all` and `filter` methods. ([@fatkodima][])
* [#154](https://github.com/rubocop/rubocop-performance/pull/154): Require RuboCop 0.87 or higher. ([@koic][])

## 1.7.1 (2020-07-18)

### Bug fixes

* [#147](https://github.com/rubocop/rubocop-performance/issues/147): Fix an error for `Performance/AncestorsInclude` when using `ancestors.include?` without receiver. ([@koic][])
* [#150](https://github.com/rubocop/rubocop-performance/pull/150): Fix an incorrect autocorrect for `Performance/BigDecimalWithNumericArgument` when a precision is specified. ([@eugeneius][])

### Changes

* [#149](https://github.com/rubocop/rubocop-performance/pull/149): Mark `Performance/AncestorsInclude` as unsafe. ([@eugeneius][])
* [#145](https://github.com/rubocop/rubocop-performance/issues/145): Mark `Performance/StringInclude` as `SafeAutocorrect: false` and disable autocorrect by default. ([@koic][])

## 1.7.0 (2020-07-07)

### New features

* [#141](https://github.com/rubocop/rubocop-performance/pull/141): Add new `Performance/RedundantStringChars` cop. ([@fatkodima][])
* [#127](https://github.com/rubocop/rubocop-performance/pull/127): Add new `Performance/IoReadlines` cop. ([@fatkodima][])
* [#128](https://github.com/rubocop/rubocop-performance/pull/128): Add new `Performance/ReverseFirst` cop. ([@fatkodima][])
* [#132](https://github.com/rubocop/rubocop-performance/issues/132): Add new `Performance/RedundantSortBlock` cop. ([@fatkodima][])
* [#125](https://github.com/rubocop/rubocop-performance/pull/125): Support `Array()` and `Hash()` methods for `Performance/Size` cop. ([@fatkodima][])
* [#124](https://github.com/rubocop/rubocop-performance/pull/124): Add new `Performance/Squeeze` cop. ([@fatkodima][])
* [#129](https://github.com/rubocop/rubocop-performance/pull/129): Add new `Performance/BigDecimalWithNumericArgument` cop. ([@fatkodima][])
* [#130](https://github.com/rubocop/rubocop-performance/pull/130): Add new `Performance/SortReverse` cop. ([@fatkodima][])
* [#81](https://github.com/rubocop/rubocop-performance/issues/81): Add new `Performance/StringInclude` cop. ([@fatkodima][])
* [#123](https://github.com/rubocop/rubocop-performance/pull/123): Add new `Performance/AncestorsInclude` cop. ([@fatkodima][])
* [#125](https://github.com/rubocop/rubocop-performance/pull/125): Support `Range#member?` method for `Performance/RangeInclude` cop. ([@fatkodima][])

### Changes

* [#138](https://github.com/rubocop/rubocop-performance/pull/138): Drop support for RuboCop 0.81 or lower. ([@koic][])

## 1.6.1 (2020-06-05)

### New features

* [#115](https://github.com/rubocop/rubocop-performance/issues/115): Support `String#sub` and `String#sub!` methods for `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops. ([@fatkodima][])

### Bug fixes

* [#111](https://github.com/rubocop/rubocop-performance/issues/111): Fix an error for `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops when using autocorrection with RuboCop 0.81 or lower. ([@koic][])
* [#118](https://github.com/rubocop/rubocop-performance/issues/118): Fix a false positive for `Performance/DeletePrefix`, `Performance/DeleteSuffix`, `Performance/StartWith`, and `Performance/EndWith` cops when receiver is multiline string. ([@koic][])

## 1.6.0 (2020-05-22)

### New features

* [#77](https://github.com/rubocop/rubocop-performance/issues/77): Add new `Performance/BindCall` cop. ([@koic][])
* [#105](https://github.com/rubocop/rubocop-performance/pull/105): Add new `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops. ([@koic][])
* [#107](https://github.com/rubocop/rubocop-performance/pull/107): Support regexp metacharacter `^` for `Performance/StartWith` cop and regexp metacharacter `$` for `Performance/EndWith` cop. ([@koic][])

### Bug fixes

* [#55](https://github.com/rubocop/rubocop-performance/issues/55): Fix an incorrect autocorrect for `Performance/RegexpMatch` when using `str.=~(/regexp/)`. ([@koic][])
* [#108](https://github.com/rubocop/rubocop-performance/pull/108): Fix an incorrect autocorrect for `Performance/ReverseEach` when there is a newline between reverse and each. ([@joe-sharp][], [@dischorde][], [@siegfault][])

### Changes

* [#103](https://github.com/rubocop/rubocop-performance/pull/103): **(Compatibility)** Drop support for Ruby 2.3. ([@koic][])
* [#101](https://github.com/rubocop/rubocop-performance/issues/101): Mark unsafe for `Performance/Casecmp` cop. ([@koic][])

## 1.5.2 (2019-12-25)

### Bug fixes

* [#86](https://github.com/rubocop/rubocop-performance/issues/86): Fix an incorrect autocorrect for `Performance/RedundantMerge` when using an empty hash argument. ([@koic][])

## 1.5.1 (2019-11-14)

### Bug fixes

* [#82](https://github.com/rubocop/rubocop-performance/pull/82): Let `Performance/StartWith` and `Performance/EndWith` correct `Regexp#match?` and `Regexp#=~`. ([@eugeneius][])

## 1.5.0 (2019-10-01)

### Bug fixes

* [#74](https://github.com/rubocop/rubocop-performance/pull/74): Fix an error for `Performance/RedundantMerge` when `MaxKeyValuePairs` option is set to `null`. ([@koic][])
* [#70](https://github.com/rubocop/rubocop-performance/issues/70): This PR fixes a false negative for `Performance/FlatMap` when using symbol to proc operator argument of `map` method. ([@koic][], [@splattael][])

### Changes

* [#69](https://github.com/rubocop/rubocop-performance/issues/69): Remove `SafeMode` from `Performance/Count` and `Performance/Detect`. Set `SafeAutoCorrect` to `false` for these cops by default. ([@rrosenblum][])

## 1.4.1 (2019-07-29)

### Bug fixes

* [#67](https://github.com/rubocop/rubocop-performance/issues/67): Fix an error for `Performance/RedundantMerge` when `MaxKeyValuePairs` option is set to `null`. ([@koic][])
* [#73](https://github.com/rubocop/rubocop-performance/pull/73): Fix a false negative for `Performance/RegexpMatch` when `MatchData` is not detected in `if` branch of guard condition. ([@koic][])

## 1.4.0 (2019-06-20)

### Bug fixes

* [#54](https://github.com/rubocop/rubocop-performance/issues/54): Fix `Performance/FixedSize` to accept const assign with some operation. ([@tejasbubane][])
* [#61](https://github.com/rubocop/rubocop-performance/pull/61): Fix a false negative for `Performance/RegexpMatch` when using RuboCop 0.71 or higher. ([@koic][])

## 1.3.0 (2019-05-13)

### Bug fixes

* [#48](https://github.com/rubocop/rubocop-performance/issues/48): Reduce `Performance/RegexpMatch` false positive by only flagging `match` used with Regexp/String/Symbol literals. ([@dduugg][])

### Changes

* [#52](https://github.com/rubocop/rubocop-performance/issues/52): **(Compatibility)** Drop support for Ruby 2.2. ([@bquorning][])

## 1.2.0 (2019-05-04)

### Bug fixes

* [#47](https://github.com/rubocop/rubocop-performance/pull/47): Fix a false negative for `Performance/RegexpMatch` when using RuboCop 0.68 or higher. ([@koic][])

## 1.1.0 (2019-04-08)

### Changes

* [#39](https://github.com/rubocop/rubocop-performance/pull/39): Remove `Performance/LstripRstrip` cop. ([@koic][])
* [#39](https://github.com/rubocop/rubocop-performance/pull/39): Remove `Performance/RedundantSortBy`, `Performance/UnneededSort` and `Performance/Sample` cops. ([@koic][])

## 1.0.0 (2019-03-14)

### New features

* Extract performance cops from rubocop/rubocop repository. ([@composerinteralia][], [@koic][])

[@composerinteralia]: https://github.com/composerinteralia
[@koic]: https://github.com/koic
[@bquorning]: https://github.com/bquorning
[@dduugg]: https://github.com/dduugg
[@tejasbubane]: https://github.com/tejasbubane
[@rrosenblum]: https://github.com/rrosenblum
[@splattael]: https://github.com/splattael
[@eugeneius]: https://github.com/eugeneius
[@joe-sharp]: https://github.com/joe-sharp
[@dischorde]: https://github.com/dischorde
[@siegfault]: https://github.com/siegfault
[@fatkodima]: https://github.com/fatkodima
[@dvandersluis]: https://github.com/dvandersluis
[@ghiculescu]: https://github.com/ghiculescu
[@mfbmina]: https://github.com/mfbmina
[@mvz]: https://github.com/mvz
[@leoarnold]: https://github.com/leoarnold
[@ydah]: https://github.com/ydah
[@QQism]: https://github.com/QQism
[@r7kamura]: https://github.com/r7kamura
[@vlad-pisanov]: https://github.com/vlad-pisanov
[@ymap]: https://github.com/ymap
[@tagliala]: https://github.com/tagliala
[@earlopain]: https://github.com/earlopain
[@parkerfinch]: https://github.com/parkerfinch
[@viralpraxis]: https://github.com/viralpraxis
[@corsonknowles]: https://github.com/corsonknowles
[@a-lavis]: https://github.com/a-lavis
[@jbpextra]: https://github.com/jbpextra
[@lovro-bikic]: https://github.com/lovro-bikic
