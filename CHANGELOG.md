HEAD

*UNRELEASED*
* Drop support for MRI Ruby 1.9, 2.0, 2.1, and 2.2 by Peter Boling
* Drop support for JRuby 1.7 and 9.0, while still supporting 9.1 by Peter Boling
* Drop support for Rails 3.0, 3.1, 3.2, 4.0, 4.1, while still supporting 4.2 by Peter Boling
* Add testing for Rails 5.1 and 5.2 by Peter Boling

Version 1.2.2 - FEB.17.2017
* Improve handling of frozen strings, which are becoming more common by @milgner

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
    * https://github.com/pboling/sanitize_email/issues/4
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
