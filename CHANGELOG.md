# Change log

## master (unreleased)

### New features

* [#115](https://github.com/rubocop-hq/rubocop-performance/issues/115): Support `String#sub` and `String#sub!` methods for `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops. ([@fatkodima][])

### Bug fixes

* [#111](https://github.com/rubocop-hq/rubocop-performance/issues/111): Fix an error for `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops when using autocorrection with RuboCop 0.81 or lower. ([@koic][])

## 1.6.0 (2020-05-22)

### New features

* [#77](https://github.com/rubocop-hq/rubocop-performance/issues/77): Add new `Performance/BindCall` cop. ([@koic][])
* [#105](https://github.com/rubocop-hq/rubocop-performance/pull/105): Add new `Performance/DeletePrefix` and `Performance/DeleteSuffix` cops. ([@koic][])
* [#107](https://github.com/rubocop-hq/rubocop-performance/pull/107): Support regexp metacharacter `^` for `Performance/StartWith` cop and regexp metacharacter `$` for `Performance/EndWith` cop. ([@koic][])

### Bug fixes

* [#55](https://github.com/rubocop-hq/rubocop-performance/issues/55): Fix an incorrect autocorrect for `Performance/RegexpMatch` when using `str.=~(/regexp/)`. ([@koic][])
* [#108](https://github.com/rubocop-hq/rubocop-performance/pull/108): Fix an incorrect autocorrect for `Performance/ReverseEach` when there is a newline between reverse and each. ([@joe-sharp][], [@dischorde][], [@siegfault][])

### Changes

* [#103](https://github.com/rubocop-hq/rubocop-performance/pull/103): **(BREAKING)** Drop support for Ruby 2.3. ([@koic][])
* [#101](https://github.com/rubocop-hq/rubocop-performance/issues/101): Mark unsafe for `Performance/Casecmp` cop. ([@koic][])

## 1.5.2 (2019-12-25)

### Bug fixes

* [#86](https://github.com/rubocop-hq/rubocop-performance/issues/86): Fix an incorrect autocorrect for `Performance/RedundantMerge` when using an empty hash argument. ([@koic][])

## 1.5.1 (2019-11-14)

### Bug fixes

* [#82](https://github.com/rubocop-hq/rubocop-performance/pull/82): Let `Performance/StartWith` and `Performance/EndWith` correct `Regexp#match?` and `Regexp#=~`. ([@eugeneius][])

## 1.5.0 (2019-10-01)

### Bug fixes

* [#74](https://github.com/rubocop-hq/rubocop-performance/pull/74): Fix an error for `Performance/RedundantMerge` when `MaxKeyValuePairs` option is set to `null`. ([@koic][])
* [#70](https://github.com/rubocop-hq/rubocop-performance/issues/70): This PR fixes a false negative for `Performance/FlatMap` when using symbol to proc operator argument of `map` method. ([@koic][], [@splattael][])

### Changes

* [#69](https://github.com/rubocop-hq/rubocop-performance/issues/69): Remove `SafeMode` from `Performance/Count` and `Performance/Detect`. Set `SafeAutoCorrect` to `false` for these cops by default. ([@rrosenblum][])

## 1.4.1 (2019-07-29)

### Bug fixes

* [#67](https://github.com/rubocop-hq/rubocop-performance/issues/67): Fix an error for `Performance/RedundantMerge` when `MaxKeyValuePairs` option is set to `null`. ([@koic][])
* [#73](https://github.com/rubocop-hq/rubocop-performance/pull/73): Fix a false negative for `Performance/RegexpMatch` when `MatchData` is not detected in `if` branch of guard condition. ([@koic][])

## 1.4.0 (2019-06-20)

### Bug fixes

* [#54](https://github.com/rubocop-hq/rubocop-performance/issues/54): Fix `Performance/FixedSize` to accept const assign with some operation. ([@tejasbubane][])
* [#61](https://github.com/rubocop-hq/rubocop-performance/pull/61): Fix a false negative for `Performance/RegexpMatch` when using RuboCop 0.71 or higher. ([@koic][])

## 1.3.0 (2019-05-13)

### Bug fixes

* [#48](https://github.com/rubocop-hq/rubocop-performance/issues/48): Reduce `Performance/RegexpMatch` false positive by only flagging `match` used with Regexp/String/Symbol literals. ([@dduugg][])

### Changes

* [#52](https://github.com/rubocop-hq/rubocop-performance/issues/52): Drop support for Ruby 2.2. ([@bquorning][])

## 1.2.0 (2019-05-04)

### Bug fixes

* [#47](https://github.com/rubocop-hq/rubocop-performance/pull/47): Fix a false negative for `Performance/RegexpMatch` when using RuboCop 0.68 or higher. ([@koic][])

## 1.1.0 (2019-04-08)

### Changes

* [#39](https://github.com/rubocop-hq/rubocop-performance/pull/39): Remove `Performance/LstripRstrip` cop. ([@koic][])
* [#39](https://github.com/rubocop-hq/rubocop-performance/pull/39): Remove `Performance/RedundantSortBy`, `Performance/UnneededSort` and `Performance/Sample` cops. ([@koic][])

## 1.0.0 (2019-03-14)

### New features

* Extract performance cops from rubocop-hq/rubocop repository. ([@composerinteralia][], [@koic][])

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
