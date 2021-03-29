# Change log

## master (unreleased)

### Changes

* [#228](https://github.com/rubocop/rubocop-performance/pull/228): Mark `Performance/RedundantMerge` as unsafe. ([@dvandersluis][])

## 1.10.2 (2021-03-23)

### Bug fixes

* [#162](https://github.com/rubocop/rubocop-performance/issues/162): Fix a false positive for `Performance/RedundantBlockCall` when an optional block that is overridden by block variable. ([@koic][])
* [#36](https://github.com/rubocop/rubocop-performance/issues/36): Fix a false positive for `Performance/ReverseEach` when `each` is called on `reverse` and using the result value. ([@koic][])
* [#224](https://github.com/rubocop/rubocop-performance/pull/224): Fix a false positive for `Style/RedundantEqualityComparisonBlock` when using one argument with comma separator in block argument. ([@koic][])
* [#225](https://github.com/rubocop/rubocop-performance/issues/225): Fix a false positive for `Style/RedundantEqualityComparisonBlock` when using `any?` with `===` comparison block and block argument is not used as a receiver for `===`. ([@koic][])
* [#222](https://github.com/rubocop/rubocop-performance/issues/222): Fix a false positive for `Performance/RedundantSplitRegexpArgument` when `split` method argument is exactly one spece regexp `/ /`. ([@koic][])

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

* [#103](https://github.com/rubocop/rubocop-performance/pull/103): **(BREAKING)** Drop support for Ruby 2.3. ([@koic][])
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

* [#52](https://github.com/rubocop/rubocop-performance/issues/52): Drop support for Ruby 2.2. ([@bquorning][])

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
