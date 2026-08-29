# Changelog

[![SemVer 2.0.0][📌semver-img]][📌semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog][📗keep-changelog],
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html),
and [yes][📌major-versions-not-sacred], platform and engine support are part of the [public API][📌semver-breaking].
Please file a bug if you notice a violation of semantic versioning.

[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

## [Unreleased]

### Added

### Changed

- kettle-jem-template-20260801-001 - Generated README gem dashboard links now
  use ClickGems instead of BestGems.

- [kc] kettle-jem/prepare: updated 44 project files:
  - configuration (1)
  - dependencies (40)
  - other (3)

- [kc] kettle-jem/template: updated 13 project files:
  - code and tests (2)
  - configuration (1)
  - dependencies (3)
  - documentation (1)
  - other (5)
  - workflows (1)

### Deprecated

### Removed

### Fixed

- kettle-jem-template-20260801-002 - Generated RSpec helpers now normalize
  managed configuration block bindings structurally, preventing mixed block
  parameter names from producing invalid configuration after a merge.
- kettle-jem-template-20260801-003 - Generated project metadata and
  documentation now normalize configured underscore hostnames to valid
  hyphenated hostnames.
- kettle-jem-template-20260801-004 - Generated organization README logos now
  use GitHub's stable organization avatar endpoint instead of assuming a
  matching Galtzo-hosted asset exists.

- kettle-jem-template-20260802-001 - Devcontainer JSON files now merge as JSONC,
  preserving comments and trailing commas during template updates.

- Restore the Rails app harness required by the default test bundle.

- Restore the Rails integration test dependencies removed by an earlier template pass.

### Security

## [2.0.14] - 2026-07-31

- TAG: [v2.0.14][2.0.14t]
- COVERAGE: 95.58% -- 368/385 lines in 13 files
- BRANCH COVERAGE: 82.91% -- 97/117 branches in 13 files
- 53.41% documented

### Changed

- kettle-jem-template-20260716-002 - Generated gemspec manifests now ship fewer
  repository-only files by default to reduce downstream distro packaging churn.
- kettle-jem-template-20260720-002 - Generated development Gemfiles now use the
  released `tree_sitter_language_pack` gem 1.13.3 or newer by default.
- kettle-jem-template-20260720-003 - Generated StructuredMerge Git diff driver
  config now uses the installed `smorg-rb` Ruby driver name.
- kettle-jem-template-20260720-005 - Generated README Support & Community rows
  now include a RubyForum help badge.
- kettle-jem-template-20260725-001 - Generated JRuby and TruffleRuby workflow
  files now run when pull request head branches start with `feature/release`,
  so release CI monitoring does not report intentionally skipped engine
  workflows as failures.

- kettle-jem-template-20260725-002 - Generated gemspec templates now include
  `anonymous_loader` as a development dependency, and version specs use it to
  execute generated `version.rb` files for coverage without redefining package
  constants. Managed version specs are removed when `version_gem` is disabled
  or incompatible with the project's runtime Ruby floor.

- kettle-jem-template-20260728-001 - Generated Ruby workflows now use clearer
  setup-ruby-flash planning and can prepare appraisal-only jobs without
  installing the main Gemfile bundle.

### Fixed

- Root development bundle now includes the Rails test harness fragment, so
  `bundle exec kettle-test` can load the suite outside appraisal-specific
  Gemfiles.
- Added coverage for legacy test helper, matcher, and Rails integration shim
  surfaces so release coverage thresholds pass.

- Root release bundles now include the default Rails test support, and
  Rails-dependent specs load `rails_helper` explicitly for parallel workers.

- kettle-jem-template-20260726-002 - Generated version files now document their
  version namespace and constants, reducing warning-only YARD lint output.

- kettle-jem-template-20260726-003 - Coverage upload steps now treat Coveralls,
  QLTY, and Codecov as optional, so provider outages do not fail CI when local
  coverage thresholds still pass.
- kettle-jem-template-20260728-002 - Generated RuboCop configs now ignore the
  same `gemfiles/vendor/bundle` tree as `.gitignore`, so vendored dependency
  installs are not reported as project lint debt.
- kettle-jem-template-20260728-003 - Generated dep-heads workflows now run
  TruffleRuby jobs with current RubyGems and Bundler, avoiding setup failures
  before the test suite starts.

- kettle-jem-template-20260728-004 - Generated dep-heads workflows now use the
  setup-ruby Bundler install path for direct appraisal Gemfiles, avoiding rv
  lockfile parser failures on Git and path dependencies.

- kettle-jem-template-20260728-005 - VersionGem bootstrap now creates the
  missing canonical version spec when a project only has shim namespace version
  specs.

- kettle-jem-template-20260729-001 - Generated JRuby 9.4 workflows now use the
  legacy manual bundle install path, avoiding setup-time Bundler full-index
  failures against `gem.coop`.

- kettle-jem-template-20260730-001 - Gemspec package file enumeration now runs
  relative to the gemspec directory, so packaged template assets are included
  even when the gemspec is loaded from another working directory.

- Legacy test helpers now reject unsupported match values consistently on Ruby
  2.5, where plain objects still respond to `=~`.

### Added

- Documentation linting now has its generated `yard-lint` dependency and severity config available in the local bundle.

- kettle-jem-template-20260726-001 - Projects now include YARD lint
  configuration and documentation dependencies so documentation issues fail
  before generated docs are refreshed.

- kettle-jem-template-20260727-001 - Spec harness documentation now lists the
  RSpec helpers provided by `kettle-test`.

- kettle-jem-template-20260729-005 - Gemspec metadata now publishes this
  project's RubyForum tag as `mailing_list_uri`, and support docs link to the
  tagged RubyForum community alongside Discord.

## [2.0.13] - 2026-07-02

- TAG: [v2.0.13][2.0.13t]
- COVERAGE: 83.12% -- 320/385 lines in 13 files
- BRANCH COVERAGE: 76.07% -- 89/117 branches in 13 files
- 51.14% documented

### Added

- Added support for JRuby 10.1 and TruffleRuby 34.0.

### Changed

- Retemplated project metadata and CI/development automation with `kettle-jem` v7.0.0.

### Fixed

- Root development bundle now includes the default Rails 7.2 test stack so
  `bundle exec kettle-test` can load `rails_helper` and Combustion.
- Package configured license files in gem release file lists.

## [2.0.12] - 2026-06-14

- TAG: [v2.0.12][2.0.12t]
- COVERAGE: 94.87% -- 259/273 lines in 7 files
- BRANCH COVERAGE: 81.19% -- 82/101 branches in 7 files
- 51.14% documented

### Changed

- Refreshed generated project metadata, support documentation and README
  badges, funding metadata, documentation URLs, CI workflow pins and matrices,
  `docs/CNAME`, and development dependency floors from the latest `kettle-jem`
  template.

### Fixed

- Honored explicit per-call `activation_proc` and `engage` options in `SanitizeEmail.sanitary`, and restored temporary sanitization state when a delivery raises.
- Preserved the Rails environment activation override in sanitizer specs so
  test setup matches configured activation behavior.

## [2.0.11] - 2026-05-28

- TAG: [v2.0.11][2.0.11t]
- COVERAGE: 94.93% -- 262/276 lines in 8 files
- BRANCH COVERAGE: 80.81% -- 80/99 branches in 8 files
- 52.27% documented

### Added

- Published generated API documentation
  - refreshed README Ruby & Rails compatibility guidance

### Changed

- Refreshed package metadata, support links, and documentation links for the
  current `galtzo-floss/sanitize_email` project home.

### Fixed

- Fixed sanitization of SendGrid ActionMailer `personalizations` headers so the
  overridden recipient data is written back to the message.
- Made global sanitization/configuration state updates safer under concurrent
  access by synchronizing `force_sanitize`, configuration, and deprecation
  silence state.

## [2.0.10] - 2024-11-09

- TAG: [v2.0.10][2.0.10t]

- COVERAGE:  90.15% -- 247/274 lines in 8 files
- BRANCH COVERAGE:  71.68% -- 81/113 branches in 8 files
- 61.73% documented

### Fixed

* Prefer `require_relative` > `require` internally
  * Better performance, portability, and consistency
  * See: https://github.com/rubocop/rubocop/issues/8748

## [2.0.9] - 2024-11-09

- TAG: [v2.0.9][2.0.9t]

- COVERAGE:  90.15% -- 247/274 lines in 8 files
- BRANCH COVERAGE:  71.68% -- 81/113 branches in 8 files
- 61.73% documented

### Added

* More & better documentation
* Rails 8.0 to CI

## [2.0.8] - 2024-06-11

- TAG: [v2.0.8][2.0.8t]

### Fixed

* [#110](https://github.com/galtzo-floss/sanitize_email/issues/110) - interceptor not working via Rails 6+ engine (actual fix!)

## [2.0.7] - 2024-04-25

- TAG: [v2.0.7][2.0.7t]

### Added

* More documentation

### Changed

* Documentation is now via yard instead of rdoc

### Fixed

* [#110](https://github.com/galtzo-floss/sanitize_email/issues/110) - interceptor not working via Rails 6+ engine

## [2.0.6] - 2024-04-25

- TAG: [v2.0.6][2.0.6t]

### Added

* Appraisals & Combustion for comprehensive testing across versions of Rails (@pboling)
* Rails 3.0 to Test Matrix (@pboling)
* Rails 3.1 to Test Matrix (@pboling)
* Rails 3.2 to Test Matrix (@pboling)
* Rails 4.0 to Test Matrix (@pboling)
* Rails 4.1 to Test Matrix (@pboling)
* Rails 4.2 to Test Matrix (@pboling)
* Rails 5.0 to Test Matrix (@pboling)
* Rails 5.1 to Test Matrix (@pboling)
* More Documentation (@pboling)

### Fixed

* Compatibility with Rails 3.0, 3.1, 3.2 (@pboling)
* Compatibility with Rails 6.0, 6.1, 7.0, 7.1 (@pboling)

## [2.0.5] - 2024-04-18

- TAG: [v2.0.5][2.0.5t]

### Added

* New RSpec matcher (@pboling)
  * `have_bcc_username`
* Feature #21 - environment configuration option can now be set to proc / lambda / #call (@pboling)
* Documentation of all configuration options in README.md (@pboling)
* Many more tests
  * Confirmed compatibility with [`sendgrid-actionmailer`](https://github.com/eddiezane/sendgrid-actionmailer)
  * Code coverage up to 90%

### Changed

* Averted deprecation warnings when using Rails 6 (@pboling)

## Fixed

* Bug #37 - Unable to send email when only CC or BCC present

## [2.0.4] - 2024-03-22

- TAG: [v2.0.4][2.0.4t]

### Added

* [#74](https://github.com/galtzo-floss/sanitize_email/pull/74) Support sanitizing SendGrid personalization fields (@joeyparis)
* mail gem dependency (@pboling)
* version_gem dependency (@pboling)
* new RSpec Matchers (@pboling)
  * `have_sanitized_to_header`
  * `have_sanitized_cc_header`
* Contributor [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) (@pboling)
* Security Policy in [SECURITY.md](SECURITY.md) (@pboling)
* More documentation (@pboling)

### Changed

* Switched from Travis-CI to GitHub Actions
  * Testing for

### Fixed

* [#64](https://github.com/galtzo-floss/sanitize_email/issues/64) Automatically dedup recipients in cascading fashion: To > CC > BCC (@pboling)
* Set sanitized email headers with decoded values from Mail gem

### Removed

* Dependency on git in gemspec (@pboling)
* Coveralls development gem dependecy

## [2.0.3] - 2018-09-08

- TAG: [v2.0.3][2.0.3t]

### Changed

* Nothing

## [2.0.2] - 2018-09-08

- TAG: [v2.0.2][2.0.2t]

### Added

* More and fixed badges (@pboling)
* Code Coverage reporting (@pboling)

### Changed

* begin following SemVer for dependency requirements (@pboling)

### Fixed

* [#47](https://github.com/galtzo-floss/sanitize_email/pull/47) Don't use #prepend on subject (@mslade-fairfax)

### Removed

* Ability to install on Ruby 2.2 (@pboling)

## [2.0.1] - 2018-03-07

- TAG: [v2.0.1][2.0.1t]

### Fixed

* [#32](https://github.com/galtzo-floss/sanitize_email/pull/32) A better fix for the frozen subject bug (@pboling)

### Removed

* Ruby 2.2 is really no longer supported (@pboling)

## [2.0.0] - 2018-03-07

- TAG: [v2.0.0][2.0.0t]

### Added

* Add testing for Rails 5.1 and 5.2 (@pboling)
* More and fixed badges (@pboling)

### Changed

* Drop support for MRI Ruby 1.9, 2.0, 2.1, and 2.2 (@pboling)
* Drop support for JRuby 1.7 and 9.0, while still supporting 9.1 (@pboling)
* Drop support for Rails 3.0, 3.1, 3.2, 4.0, 4.1, while still supporting 4.2 (@pboling)

### Fixed

* Frozen subject bug (@pboling)

### Removed

* Ruby 2.2 is no longer supported (@pboling)

Version 1.2.2 - FEB.20.2017
* Improve handling of frozen strings, which are becoming more common (@milgner)

Version 1.2.1 - NOV.03.2016
* Fix bug where non-array to address would not get prepended to subject when that feature is turned on
* SanitizeEmail::TestHelpers::UnexpectedMailType no longer raised by SanitizeEmail::RspecMatchers (a breaking change if you were depending on that for your specs to pass)
* SanitizeEmail::RspecMatchers are now fully composed Rspec Matchers with much improved spec failure output
* Many linting improvements
* Added Rails 5.0 to test matrix
  - but is only tested on travis against 2.0, 2.1, 2.2, and 2.3
  - Rails versions tested are now 3.2, 4.0, 4.1, 4.2, 5.0
  - Runtime code might still be compatible with ruby 1.8.7, should be compatible with 1.9.3
  - Specs suite should still run 1.9.3 if you want to run them manually

Version 1.2.0 - JUL.24.2016
* No longer registers instance of SanitizeEmail::Bleach to avoid the dev env reloading problem (fixes #12)
* Instead registers SanitizeEmail::Bleach class.
* Deprecate sending arguments to SanitizeEmail::Bleach.new

Version 1.1.7 - AUG.30.2015
* No API changes
* General improvement to the code base by Peter Boling
  - small refactorings
  - documentation
  - setup reek properly
  - Fixed travis build matrix, added latest Ruby and Rails, and bumped patch releases

Version 1.1.6 - AUG.29.2015
* spec run as default rake task & improve Rakefile syntax by Peter Boling
* prevent direct configuration via `DEFAULTS` from working, as that is not the API by Peter Boling
* better gem summary: "Email Condom for your Ruby Server" by Peter Boling
* Improve specs and spec config by Peter Boling

Version 1.1.5 - MAR.10.2015
* Refactored `prepend_subject_array` by Scott Rocher
* Specs for prepending to subject by Scott Rocher
* Fix spec examples by Peter Boling
* Update Readme by Theo Bittencourt

Version 1.1.4 - JAN.06.2014
* Another attempt at not breaking when subject is nil by Peter Boling

Version 1.1.3 - JAN.06.2014
* Allow specification of environment when outside Rails by Peter Boling

Version 1.1.2 - JAN.06.2014
* Don't break when subject is nil by Peter Boling

Version 1.1.1 - DEC.30.2013
* Cribbed have_body_text from email_spec gem by Peter Boling
* Cribbed have_header from email_spec gem by Peter Boling
* Cribbed MailExt from email_spec gem by Peter Boling
* All Rspec Matchers now working by Peter Boling
* All Test Helpers now working by Peter Boling
* All internal tests now use the matchers and helpers of sanitize_email by Peter Boling
* Development dependency on email_spec gem removed by Peter Boling
* Travis is getting barfy on my 1.8.7 build (passes locally) by Peter Boling

Version 1.1.0 - DEC.30.2013
* Add documentation for non-Rails setup by Peter Boling
* Add documentation for using sanitize_email's bundled Rspec Matchers by Peter Boling
* Add documentation for using sanitize_email's bundled Test Helpers by Peter Boling
* Stopped using method_missing internally for config access by Peter Boling
* Improved ease of setup with mail gem outside rails by auto-configuring the interceptor (default inactive) by Peter Boling

Version 1.0.11 - DEC.30.2013
* Fix travis build by Peter Boling
* Fix test suite to run on Ruby 1.8.7 again, add back to Travis by Peter Boling
* Add mode badges to Readme by Peter Boling
* Improve Readme by Peter Boling

Version 1.0.10 - NOV.24.2013
* Expand test suite to test against all supported versions of ActionMailer and Railties gems by Peter Boling
* Add Coveralls by Peter Boling
* Fix Travis Build by Peter Boling
* Stop using method missing when alternatives exist inside gem by Peter Boling

Version 1.0.9 - AUG.31.2013
* \[Bug Fix\] More Fixes for #12 - Strange repeating headers, and repeated subject injection by Peter Boling

Version 1.0.8 - AUG.30.2013
* \[Bug Fix\] Partial Fix for #12 - Strange repeating headers by Peter Boling
* Lots of refactoring by Peter Boling
  * Properly supports when a to/cc field has multiple recipients sanitized and adds all to mail headers
* Improved specs by Peter Boling

Version 1.0.7 - AUG.06.2013

* \[Bug Fix\] Stripping the message headers before appending new headers.
  - In a scenario where there is a trailing space, adding the newline before we append results in a blank header which throws an error as illegal by Eric Musgrove
* Minor updates to Gemspec by Peter Boling

Version 1.0.6 - JAN.25.2013

* \[New Feature\] use_actual_environment_prepended_to_subject by [altonymous](https://github.com/Altonymous)

Version 1.0.5 - DEC.20.2012

* Fixes Compatibility with Rails 3.0 by David Morton
* Added header tests to ensure original header markers do not appear when sanitize is disabled by Harry Lascelles
* Added tests and email_spec for have_header matcher by Harry Lascelles
* Make activation_proc option a bit more configurable by Nikita Fedyashev
* Adding message to engage proc, so we can sanitize on a message by message basis by Harry Lascelles
* Allowing for nil ccs and bccs by Harry Lascelles
* Adding original emails as headers, except for bcc by Harry Lascelles

Version 1.0.4 - SEP.10.2012

* Removes facets dependency, upgrades to rspec v2.11 by Peter Boling
* REEK refactoring by Peter Boling
* Improve handling of mal-formed calls to (un)sanitary (raises error) by Peter Boling
* code cleanup by Peter Boling
* Put some examples back in the README, until I improve and link to the wiki. :/

Version 1.0.3 - AUG.12.2012

* Accidentally broke spec suite with 1.0.2 - fixed
* Expanded spec suite
* Split test_helpers from rspec_matchers (test_helpers may be useful in TestUnit
* Moving Examples from README to wiki
* Document and implement working deprecation of version 0's SanitizeEmail::Config.config[:force_sanitize] behavior
    * Now use SanitizeEmail.force_sanitize = true # or false or nil

Version 1.0.2 - AUG.11.2012

* Massive improvement to spec suite, and found bleeding
    * needed to unregister the interceptors:
        * Mail.class_variable_get(:@@delivery_interceptors).pop
* Added SanitizeEmail.deprecate_in_silence
* Added SanitizeEmail.sanitary &block
    * Local overrides to SanitizeEmail config for specific local purpose
    * Force Sanitization On for a block
* Added SanitizeEmail.unsanitary &block
    * Force Sanitization Off for a block
* Added SanitizeEmail.force_sanitize = true # or false or nil
    * Force Sanitization On or Off

Version 1.0.1 - Unintentional, unexpected bump behavior from gem-release gem (Issues #24 & #25)

Version 1.0.0.rc3 - AUG.08.2012

* Forgot to switch from jeweler to gem-release, so making appropriate changes and bumping again
* Aligning closer to bundler gem defaults
* Removing Rails dependency - Should work with Sinatra, or any Mail-like interface
* Added facets dependency to get cattr functionality (and hopefully other cool stuff)
* Gem dependencies in gemspec

Version 1.0.0.rc2 - AUG.08.2012 - botched

* Bug: loading the gem in a rails app broke mailer specs in the app - Fixed
    * https://github.com/galtzo-floss/sanitize_email/issues/4
* Moved MIT-LICENSE to LICENSE, updated years
* Added Travis-CI for... CI.

Version 1.0.0.rc1

* Added a good_list and a bad_list (i.e. allowlist and blocklist)
* Added Deprecation library
* Refactored Sanitization module into Hook class
* Renamed Hook Class to Bleach Class
* Improve support for non-rails implementations
* Deprecated local_environments in favor of local_environment_proc
* Deprecated sanitized_recipients in favor of sanitized_to
* More specs

Version 1.0.0.alpha2

* Complete refactor!  Implementing initial support for Rails >= 3.0 (new ActionMailer API)
    * Support for Rails <= 2.X remains in version 0.X.X releases.
* NinthBit namespace is now SanitizeEmail namespace
* Now has a first class Config class

XXXXXXXXXXXXXXXXXXXXXXX Rails 3.0+ Only From here on up! XXXXXXXXXXXXXXXXXXXXXXX

Version 0.3.8

* Update specs, note requirement of Rails 2.3 or below to run spec quite.
* Support use_actual_email_prepended_to_subject
* Fix environment check for old versions of Rails
* Improved Readme

Version 0.3.7

* Improved Installation instructions
* Fixed so tests run from inside a rails app (previously only ran standalone)

Version 0.3.6

* Fixed Installation instructions
* Improved README

Old version?

* Fixed require paths
* added about.yml and this CHANGELOG

[Unreleased]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.14...HEAD
[2.0.14]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.13...v2.0.14
[2.0.14t]: https://github.com/galtzo-floss/sanitize_email/releases/tag/v2.0.14
[2.0.13]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.12...v2.0.13
[2.0.13t]: https://github.com/galtzo-floss/sanitize_email/releases/tag/v2.0.13
[2.0.12]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.11...v2.0.12
[2.0.12t]: https://github.com/galtzo-floss/sanitize_email/releases/tag/v2.0.12
[2.0.11]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.10...v2.0.11
[2.0.11t]: https://github.com/galtzo-floss/sanitize_email/releases/tag/v2.0.11
[2.0.10]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.9...v2.0.10
[2.0.10t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.10
[2.0.9]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.8...v2.0.9
[2.0.9t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.9
[2.0.8]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.7...v2.0.8
[2.0.8t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.8
[2.0.7]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.6...v2.0.7
[2.0.7t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.7
[2.0.6]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.5...v2.0.6
[2.0.6t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.6
[2.0.5]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.4...v2.0.5
[2.0.5t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.5
[2.0.4]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.3...v2.0.4
[2.0.4t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.4
[2.0.3]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.2...v2.0.3
[2.0.3t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.3
[2.0.2]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.1...v2.0.2
[2.0.2t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.2
[2.0.1]: https://github.com/galtzo-floss/sanitize_email/compare/v2.0.0...v2.0.1
[2.0.1t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.1
[2.0.0]: https://github.com/galtzo-floss/sanitize_email/compare/v1.2.2...v2.0.0
[2.0.0t]: https://github.com/galtzo-floss/sanitize_email/tags/v2.0.0
