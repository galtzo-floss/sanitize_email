# 📧 sanitize_email

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/gem/v/sanitize_email.svg)](https://rubygems.org/gems/sanitize_email)
[![Downloads Today](https://img.shields.io/gem/rd/sanitize_email.svg)](https://github.com/pboling/sanitize_email)
[![Depfu][🔑depfui]][🔑depfu]
[![CodeCov][🖇codecov-img♻️]][🖇codecov]
[![Test Coverage][🔑cc-covi]][🔑cc-cov]
[![Maintainability][🔑cc-mnti]][🔑cc-mnt]
[![CI Supported Build][🚎s-wfi]][🚎s-wf]
[![CI Unsupported Build][🚎us-wfi]][🚎us-wf]
[![CI Style Build][🚎st-wfi]][🚎st-wf]
[![CI Coverage Build][🚎cov-wfi]][🚎cov-wf]
[![CI Heads Build][🚎hd-wfi]][🚎hd-wf]
[![CI Ancient Build][🚎an-wfi]][🚎an-wf]

[🖇codecov-img♻️]: https://codecov.io/gh/pboling/sanitize_email/graph/badge.svg?token=selEoMrZzA
[🖇codecov]: https://codecov.io/gh/pboling/sanitize_email
[🚎s-wf]: https://github.com/pboling/sanitize_email/actions/workflows/supported.yml
[🚎s-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/supported.yml/badge.svg
[🚎us-wf]: https://github.com/pboling/sanitize_email/actions/workflows/unsupported.yml
[🚎us-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/unsupported.yml/badge.svg
[🚎st-wf]: https://github.com/pboling/sanitize_email/actions/workflows/style.yml
[🚎st-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/style.yml/badge.svg
[🚎cov-wf]: https://github.com/pboling/sanitize_email/actions/workflows/coverage.yml
[🚎cov-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/coverage.yml/badge.svg
[🚎hd-wf]: https://github.com/pboling/sanitize_email/actions/workflows/heads.yml
[🚎hd-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/heads.yml/badge.svg
[🚎an-wf]: https://github.com/pboling/sanitize_email/actions/workflows/ancient.yml
[🚎an-wfi]: https://github.com/pboling/sanitize_email/actions/workflows/ancient.yml/badge.svg

-----

[![Liberapay Patrons][⛳liberapay-img]][⛳liberapay]
[![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor]
[![Polar Shield][🖇polar-img]][🖇polar]
[![Donate to my FLOSS or refugee efforts at ko-fi.com][🖇kofi-img]][🖇kofi]
[![Donate to my FLOSS or refugee efforts using Patreon][🖇patreon-img]][🖇patreon]

[⛳liberapay-img]: https://img.shields.io/liberapay/patrons/pboling.svg?logo=liberapay
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://polar.sh/embed/seeks-funding-shield.svg?org=pboling
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/buy%20me%20coffee-donate-yellow.svg
[🖇kofi]: https://ko-fi.com/O5O86SNP4
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-yellow.svg
[🖇patreon]: https://patreon.com/galtzo

[comment]: <> ( 🔑 KEYED LINKS )

[🔑cc-mnt]: https://codeclimate.com/github/pboling/sanitize_email/maintainability
[🔑cc-mnti]: https://api.codeclimate.com/v1/badges/65af4948d859903a0372/maintainability
[🔑cc-cov]: https://codeclimate.com/github/pboling/sanitize_email/test_coverage
[🔑cc-covi]: https://api.codeclimate.com/v1/badges/65af4948d859903a0372/test_coverage
[🔑depfu]: https://depfu.com/github/pboling/sanitize_email
[🔑depfui]: https://badges.depfu.com/badges/bba430e8f19a2ba3273fb20d5e8c82d6/count.svg

This gem allows you to override your mail delivery settings, globally or in a local context.
It is like a Ruby encrusted condom for your email server,
just in case it decides to have intercourse with other servers via sundry mail protocols.

Seriously though, this gem solves similar problems as the excellent [mailcatcher](https://mailcatcher.me/) gem,
and `mailcatcher` solves those problems far more easily.

In addition, this gem solves problems that `mailcatcher` does not solve.  I recommend using both!

To make an analogy, `mailcatcher` is akin to `webmock`, entirely preventing interaction with your real live mail server,
while this gem allows you to effectively use your real live (production!) mail server, while
intercepting and modifying recipients on the way out, so that testing emails go to safe locations.

It is a bit like using the "test" Visa credit card number `4701322211111234` with a real payment gateway.

## Encryption

Making special note of this use case because it is important for companies working on HIPAA-compliant products.
When you are sending emails through an encrypted email provider, e.g. [Paubox](https://www.paubox.com/),
testing your email in the aforementioned `mailcatcher` may not be enough.

If you want to test all the way through Paubox's system, but have the email go to a safe testing account address,
then this is the gem for you.

## Compatibility

- ⚙️ Compatible with all versions of Ruby >= 2.3, plus JRuby and Truffleruby.
- ⚙️ Compatible with all Ruby web Frameworks (Hanami, Roda, Sinatra, Rails).
- ⚙️ Compatible with all versions of Rails from 3.0 - 7.1+.
- ⚙️ Compatible with scripted usage of Mail gem outside a web framework.
- ⚙️ Compatible with [`sendgrid-actionmailer`](https://github.com/eddiezane/sendgrid-actionmailer)'s support for personalizations, and will override email addresses there according to the configuration.
- ⚙️ If this gem is not compatible with your use case, and you'd like it to be, I'd like to hear about it!

It was a slog getting (very nearly) the entire compatibility matrix working with Github Actions, [appraisal](https://github.com/thoughtbot/appraisal), and [combustion](https://github.com/pat/combustion), and I'm very interested in hearing about ways to improve it!

## 🛞 DVCS

This project does not trust any one version control system,
so it abides the principles of ["Distributed Version Control Systems"][💎d-in-dvcs]

Find this project on:

| Any            | Of               | These          | DVCS           |
|----------------|------------------|----------------|----------------|
| [🐙hub][🐙hub] | [🧊berg][🧊berg] | [🛖hut][🛖hut] | [🧪lab][🧪lab] |

[comment]: <> ( DVCS LINKS )

[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/

[🧊berg]: https://codeberg.org/pboling/sanitize_email
[🐙hub]: https://gitlab.com/pboling/sanitize_email
[🛖hut]: https://sr.ht/~galtzo/pboling/sanitize_email
[🧪lab]: https://gitlab.com/pboling/sanitize_email

<!--
Numbering rows and badges in each row as a visual "database" lookup,
    as the table is extremely dense, and it can be very difficult to find anything
Putting one on each row here, to document the emoji that should be used, and for ease of copy/paste.

row #s:
1️⃣
2️⃣
3️⃣
4️⃣
5️⃣
6️⃣
7️⃣

badge #s:
⛳️
🖇
🏘
🚎
🖐
🧮
📗

appended indicators:
♻️ / 🔑 - Tagged URLs need to be updated from SAAS integration. Find / Replace is insufficient.
-->

|     | Project                        | bundle add sanitize_email                                                                                                                                                                                                                                                                                                                                                                                                                           |
|:----|--------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1️⃣ | name, license, docs, standards | [![RubyGems.org][⛳️name-img]][⛳️gem] [![License: MIT][🖇src-license-img]][🖇src-license] [![RubyDoc.info][🚎yard-img]][🚎yard] [![YARD Documentation](http://inch-ci.org/github/pboling/sanitize_email.svg)][🚎yard] [![SemVer 2.0.0][🧮semver-img]][🧮semver] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog]                                                                                                                  |
| 2️⃣ | version & activity             | [![Gem Version][⛳️version-img]][⛳️gem] [![Total Downloads][🖇DL-total-img]][⛳️gem] [![Download Rank][🏘DL-rank-img]][⛳️gem] [![Source Code][🚎src-main-img]][🚎src-main] [![Open PRs][🖐prs-o-img]][🖐prs-o] [![Closed PRs][🧮prs-c-img]][🧮prs-c]                                                                                                                                                                                                  |
| 3️⃣ | maintenance & linting          | [![Helpers][🖇triage-help-img]][🖇triage-help] [![Depfu][🔑depfui]][🔑depfu] [![Contributors][🚎contributors-img]][🚎contributors]                                                                                                                                                                                                                                                                            |
| 4️⃣ | coverage & security            | [![CodeCov][🖇codecov-img♻️]][🖇codecov] [![Coveralls][🏘coveralls-img]][🏘coveralls] [![Security Policy][🚎sec-pol-img]][🚎sec-pol] [![CodeQL][🖐codeQL-img]][🖐codeQL]                                                                                                                                                                                                                                |
| 5️⃣ | resources                      | [![Get help on Codementor][🖇codementor-img]][🖇codementor] [![Chat][🏘chat-img]][🏘chat] [![Blog][🚎blog-img]][🚎blog] [![Wiki][🖐wiki-img]][🖐wiki]                                                                                                                                                                                                                                                                                               |
| 6️⃣ | `...` 💖                       | [![Liberapay Patrons][⛳liberapay-img]][⛳liberapay] [![Sponsor Me][🖇sponsor-img]][🖇sponsor] [![Follow Me on LinkedIn][🖇linkedin-img]][🖇linkedin] [![Find Me on WellFound:][✌️wellfound-img]][✌️wellfound] [![Find Me on CrunchBase][💲crunchbase-img]][💲crunchbase] [![My LinkTree][🌳linktree-img]][🌳linktree] [![Follow Me on Ruby.Social][🐘ruby-mast-img]][🐘ruby-mast] [![Tweet @ Peter][🐦tweet-img]][🐦tweet] [💻][coderme] [🌏][aboutme] |

<!--
The link tokens in the following sections should be kept ordered by the row and badge numbering scheme
-->

<!-- 1️⃣ name, license, docs -->
[⛳️gem]: https://rubygems.org/gems/sanitize_email
[⛳️name-img]: https://img.shields.io/badge/name-sanitize__email-brightgreen.svg?style=flat
[🖇src-license]: https://opensource.org/licenses/MIT
[🖇src-license-img]: https://img.shields.io/badge/License-MIT-green.svg
[🚎yard]: https://www.rubydoc.info/gems/sanitize_email
[🚎yard-img]: https://img.shields.io/badge/documentation-rubydoc-brightgreen.svg?style=flat
[🧮semver]: http://semver.org/
[🧮semver-img]: https://img.shields.io/badge/semver-2.0.0-FFDD67.svg?style=flat
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-FFDD67.svg?style=flat

<!-- 2️⃣ version & activity -->
[⛳️version-img]: http://img.shields.io/gem/v/sanitize_email.svg
[🖇DL-total-img]: https://img.shields.io/gem/dt/sanitize_email.svg
[🏘DL-rank-img]: https://img.shields.io/gem/rt/sanitize_email.svg
[🚎src-main]: https://gitlab.com/pboling/sanitize_email
[🚎src-main-img]: https://img.shields.io/badge/source-gitlab-brightgreen.svg?style=flat
[🖐prs-o]: https://gitlab.com/pboling/sanitize_email/-/merge_requests
[🖐prs-o-img]: https://img.shields.io/github/issues-pr/pboling/sanitize_email
[🧮prs-c]: https://github.com/pboling/sanitize_email/pulls?q=is%3Apr+is%3Aclosed
[🧮prs-c-img]: https://img.shields.io/github/issues-pr-closed/pboling/sanitize_email

<!-- 3️⃣ maintenance & linting -->
[🖇triage-help]: https://www.codetriage.com/pboling/sanitize_email
[🖇triage-help-img]: https://www.codetriage.com/pboling/sanitize_email/badges/users.svg
[🚎contributors]: https://gitlab.com/pboling/sanitize_email/-/graphs/main
[🚎contributors-img]: https://img.shields.io/github/contributors-anon/pboling/sanitize_email

<!-- 4️⃣ coverage & security -->
[🖇codecov-img♻️]: https://codecov.io/gh/pboling/sanitize_email/graph/badge.svg?token=Joire8DbSW
[🖇codecov]: https://codecov.io/gh/pboling/sanitize_email
[🏘coveralls]: https://coveralls.io/github/pboling/sanitize_email?branch=main
[🏘coveralls-img]: https://coveralls.io/repos/github/pboling/sanitize_email/badge.svg?branch=main
[🚎sec-pol]: https://gitlab.com/pboling/sanitize_email/-/blob/main/SECURITY.md
[🚎sec-pol-img]: https://img.shields.io/badge/security-policy-brightgreen.svg?style=flat
[🖐codeQL]: https://github.com/pboling/sanitize_email/security/code-scanning
[🖐codeQL-img]: https://github.com/pboling/sanitize_email/actions/workflows/codeql-analysis.yml/badge.svg

<!-- 5️⃣ resources -->
[🖇codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[🖇codementor-img]: https://cdn.codementor.io/badges/get_help_github.svg
[🏘chat]: https://gitter.im/pboling/sanitize_email
[🏘chat-img]: https://img.shields.io/gitter/room/pboling/sanitize_email.svg
[🚎blog]: http://www.railsbling.com/tags/sanitize_email/
[🚎blog-img]: https://img.shields.io/badge/blog-railsbling-brightgreen.svg?style=flat
[🖐wiki]: https://gitlab.com/pboling/sanitize_email/-/wikis/home
[🖐wiki-img]: https://img.shields.io/badge/wiki-examples-brightgreen.svg?style=flat

<!-- 6️⃣ spread 💖 -->
[🐦tweet-img]: https://img.shields.io/twitter/follow/galtzo.svg?style=social&label=Follow%20%40galtzo
[🐦tweet]: http://twitter.com/galtzo
[🚎blog]: http://www.railsbling.com/tags/sanitize_email/
[🚎blog-img]: https://img.shields.io/badge/blog-railsbling-brightgreen.svg?style=flat
[🖇linkedin]: http://www.linkedin.com/in/peterboling
[🖇linkedin-img]: https://img.shields.io/badge/PeterBoling-blue?style=plastic&logo=linkedin
[✌️wellfound]: https://angel.co/u/peter-boling
[✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=plastic&logo=wellfound
[💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=plastic&logo=crunchbase
[🐘ruby-mast]: https://ruby.social/@galtzo
[🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https%3A%2F%2Fruby.social&style=plastic&logo=mastodon&label=Ruby%20%40galtzo
[🌳linktree]: https://linktr.ee/galtzo
[🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=plastic&logo=linktree

<!-- Maintainer Contact Links -->
[aboutme]: https://about.me/peter.boling
[coderme]: https://coderwall.com/Peter%20Boling

## Summary

It's particularly helpful when you want to prevent the delivery of email (e.g. in development/test environments) or alter the to/cc/bcc (e.g. in staging or demo environments) of all email generated from your application.

* compatible without Rails!  Can work with just the `mail` gem.
* compatible with Rails >= 3.0.  See gem versions 1.x for older versions of Rails.
* compatible with Ruby >= 2.3.  See gem versions 1.x for older versions of Ruby.
* compatible with any Ruby app with a mail handler that uses the `register_interceptor` API (a la ActionMailer and `mail` gems)
* configure it and forget it
* little configuration required
* solves common problems in ruby web applications that use email
* provides test helpers and spec matchers to assist with testing email content delivery

## Working Locally with Production Data

1. Have a production site with live data
2. Dump the live data and securely transfer it to another machine (e.g. rync -e ssh)
3. Import it into a development database
4. Test features which send out email (registration/signup, order placement, etc.)
5. Emails get sent (in real-life!) but to sanitized email recipients
6. Verify what they look like when sent
7. Iterate on email content design
8. No risk of emailing production addresses

## Re-routing Email on a Staging or QA Server

Another very important use case for me is to transparently re-route email generated from a staging or QA server to an appropriate person.  For example, it's common for us to set up a staging server for a client to use to view our progress and test out new features.  It's important for any email that is generated from our web application be delivered to the client's inbox so that they can review the content and ensure that it's acceptable.  `dotenv` or `direnv` allows each developer to configure the local behavior specifically for them via ENV vars.

## Testing Email from a Hot Production Server

If you install this gem on a production server (which I don't always do), you can load up script/console and override the to/cc/bcc on all emails for the duration of your console session.  This allows you to poke and prod a live production instance, and route all email to your own inbox for inspection.  The best part is that this can all be accomplished without changing a single line of your application code.

## Monitoring all email sent by server to a backup account

You may want to add a BCC automatically (e.g. to account-history@my-company.com) to every email sent by your system, for customer service purposes, and this gem allows that.  Note that this may not be a good idea for all systems, for many reasons, e.g security!

## Using with a test suite as an alternative to the heavy email_spec

[email_spec](https://github.com/bmabey/email-spec) is a great gem, with awesome rspec matchers and helpers, but it has an undeclared dependency on ActionMailer. Sad face.

SanitizeEmail comes with some lightweight RspecMatchers covering most of what email_spec can do.  It will help you test email functionality.  It is useful when you are creating a gem to handle email features, or are writing a simple Ruby script, and don't want to pull in le Rails.  SanitizeEmail has two dependencies, `mail` gem, and `version_gem`.  Your Mail system just needs to conform to `mail` gem's `register_interceptor` API.

## Install Like a Boss

In Gemfile:

       gem 'sanitize_email'

Then:

       bundle install

## Setup with Ruby

_keep scrolling for Rails, but read this for a better understanding of Magic_

There are three ways SanitizeEmail can be turned on; in order of precedence they are:

1. Only useful for local context.  Inside a method where you will be sending an email, set `SanitizeEmail.force_sanitize = true` just prior to delivering it.  Also useful in the console.

        SanitizeEmail.force_sanitize = true # by default it is nil

2. If SanitizeEmail seems to not be sanitizing you have probably not registered the interceptor.  SanitizeEmail tries to do this for you. *Note*: If you are working in an environment that has a Mail or Mailer class that uses the register_interceptor API, the interceptor will already have been registered by SanitizeEmail:

        # The gem will probably have already done this for you, but some really old versions of Rails may need you to do this manually:
        Mail.register_interceptor(SanitizeEmail::Bleach)

   Once registered, SanitizeEmail needs to be engaged:

        # in config/initializers/sanitize_email.rb
        SanitizeEmail::Config.configure { |config| config[:engage] = true }

3. If you don't need to compute anything, then don't use this option, go with the previous option.

        SanitizeEmail::Config.configure { |config| config[:activation_proc] = proc { true } } # by default :activation_proc is false

### Examples

#### Only allow email to a specific domain

This works by ensuring that all recipients have the "allowed" domain.
In other words, none of the recipients have a domain other than the allowed domain.

        allowed_domain = "example.com"
        # NOTE: you may need to check CC and BCC also, depending on your use case...
        SanitizeEmail::Config.configure do |config|
          config[:activation_proc] =
            ->(message) do
              !Array(message.to).any? { |recipient| Mail::Address.new(recipient).domain != allowed_domain }
            end
        end

### Notes

Number 1, above, is the method used by the SanitizeEmail.sanitary block.
If installed but not configured, sanitize_email DOES NOTHING.  Until configured the defaults leave it turned off.

### Troubleshooting

IMPORTANT: You may need to setup your own register_interceptor.  If sanitize_email doesn't seem to be working for you find your Mailer/Mail class and try this:

        # in config/initializers/sanitize_email.rb
        Mail.register_interceptor(SanitizeEmail::Bleach)
        SanitizeEmail::Config.configure { |config| config[:engage] = true }

If that causes an error you will know why sanitize_email doesn't work.
Otherwise it will start working according to the rest of the configuration.

## Setup With Rails

Create an initializer, if you are using rails, or otherwise configure:

        SanitizeEmail::Config.configure do |config|
          config[:sanitized_to] = "to@sanitize_email.org"
          config[:sanitized_cc] = "cc@sanitize_email.org"
          config[:sanitized_bcc] = "bcc@sanitize_email.org"
          # run/call whatever logic should turn sanitize_email on and off in this Proc:
          config[:activation_proc] = proc { %w(development test).include?(Rails.env) }
          config[:use_actual_email_prepended_to_subject] = true         # or false
          config[:use_actual_environment_prepended_to_subject] = true   # or false
          config[:use_actual_email_as_sanitized_user_name] = true       # or false
        end

Keep in mind, this is ruby (and possibly rails), so you can add conditionals or utilize different environment.rb files to customize these settings on a per-environment basis.

## Override the override

But wait there's more:

Let's say you have a method in your model that you can call to test the signup email. You want to be able to test sending it to any user at any time... but you don't want the user to ACTUALLY get the email, even in production. A dilemma, yes?  Not anymore!

To override the environment based switch use `force_sanitize`, which is normally `nil`, and ignored by default. When set to `true` or `false` it will turn sanitization on or off:

       SanitizeEmail.force_sanitize = true

When testing your email in a console, you can manipulate how email will be handled in this way.

There are also two methods that take a block and turn SanitizeEmail on or off (see section on Thread Safety below):

Regardless of the Config settings of SanitizeEmail you can do a local override to force unsanitary email in any environment.

       SanitizeEmail.unsanitary do
         Mail.deliver do
           from "from@example.org"
           to "to@example.org" # Will actually be sent to the specified address, not sanitized
           reply_to "reply_to@example.org"
           subject "subject"
         end
       end

Regardless of the Config settings of SanitizeEmail you can do a local override to send sanitary email in any environment.
You have access to all the same configuration options in the parameter hash as you can set in the actual
`SanitizeEmail.configure` block.

        SanitizeEmail.sanitary(sanitized_to: "boo@example.com") do # these config options are merged with the globals
          Mail.deliver do
            from "from@example.org"
            to "to@example.org" # Will actually be sent to the override addresses, in this case: boo@example.com
            reply_to "reply_to@example.org"
            subject "subject"
          end
        end

## Configuration Options

As used in the "Description" column below, `engaged` means: `SanitizeEmail.activate?(message) # => true`.
This happens in a few different ways, and two of them are in the config below (`engage` and `activation_proc`).

| Option                                      | Type (Yard format)                   | Description                                                                                                                            |
|---------------------------------------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| sanitized_to                                | [String, Array[String]]              | (when engaged) Override CC field with these addresses                                                                                  |
| sanitized_cc                                | [String, Array[String]]              | (when engaged) Override CC field with these addresses                                                                                  |
| sanitized_bcc                               | [String, Array[String]]              | (when engaged) Override BCC field with these addresses                                                                                 |
| good_list                                   | [Array[String]]                      | (when engaged) Email addresses to allow to pass-through without overriding                                                             |
| bad_list                                    | [Array[String]]                      | (when engaged) Email addresses to be removed from message's TO, CC, & BCC                                                              |
| environment                                 | [String, #to_s, Proc, Lambda, #call] | (when engaged) The environment value to use wherever it is added to message (e.g. in the subject line)                                 |
| use_actual_email_as_sanitized_user_name     | [Boolean]                            | (when engaged) Use "real" email address as username for sanitized email address (e.g. `"real at example.com <sanitized@example.com>"`) |
| use_actual_email_prepended_to_subject       | [Boolean]                            | (when engaged) Use "real" email address prepended to subject (e.g. `"real at example.com Original Subject"`)                           |
| use_actual_environment_prepended_to_subject | [Boolean]                            | (when engaged) Use `environment` prepended to subject (e.g. `"[[ STAGING ]] Original Subject"`)                                        |
| engage                                      | [Boolean, nil]                       | Boolean will turn engage or disengage this gem, while `nil` ignores this setting and instead checks `activation_proc`                  |
| activation_proc                             | [Proc, Lambda, #call]                | When checked, due to `engage: nil`, the result will either engage or disengage this gem                                                |

## Thread Safety

So long as you don't change the config after initializing it at runtime, you'll be fine.
Like many Ruby tools' config objects, it is a single config object, shared by all threads.
The helpers like `sanitary`, `unsanitary`, `janitor`, and `force_sanitize`
are intended to be used in single threaded environments,
like a test suite, or a console session.

I doubt I'll ever have a need for runtime reconfiguration of the config,
so I doubt I'll ever have a reason to make it "more" thread safe than it is now, but PRs are welcome!

## Use sanitize_email in your test suite!

### rspec

In your `spec_helper.rb`:


       require "sanitize_email"
       # rspec matchers are *not* loaded by default in sanitize_email, as it is not primarily a gem for test suites.
       require "sanitize_email/rspec_matchers"

       SanitizeEmail::Config.configure do |config|
         config[:sanitized_to] = "sanitize_email@example.org"
         config[:sanitized_cc] = "sanitize_email@example.org"
         config[:sanitized_bcc] = "sanitize_email@example.org"
         # run/call whatever logic should turn sanitize_email on and off in this Proc.
         # config[:activation_proc] =      Proc.new { true }
         # Since this configuration is *inside* the spec_helper, it might be assumed that we always want to sanitize.  If we don't want to it can be easily manipulated with SanitizeEmail.unsanitary and SanitizeEmail.sanitary block helpers.
         # Thus instead of using the Proc (slower) we just engage it always:
         config[:engage] = true
         config[:use_actual_email_prepended_to_subject] = true         # or false
         config[:use_actual_environment_prepended_to_subject] = true   # or false
         config[:use_actual_email_as_sanitized_user_name] = true       # or false
       end

       # If your mail system is not one that sanitize_email automatically configures an interceptor for (ActionMailer, Mail)
       # then you will need to do the equivalent for whatever Mail system you are using.

       RSpec.configure do |config|
         # ...
         # From sanitize_email gem
         config.include(SanitizeEmail::RspecMatchers)
       end

       context "an email test" do
         subject { Mail.deliver(@message_hash) }
         it { should have_to("sanitize_email@example.org") }
       end

#### have_* matchers

These will look for an email address in any of the following mail attributes:

       [:from, :to, :cc, :bcc, :subject, :reply_to]

Example:

       context "the subject line must have the email address sanitize_email@example.org" do
         subject { Mail.deliver(@message_hash) }
         it { should have_subject("sanitize_email@example.org") }
       end

#### be_* matchers

These will look for a matching string in any of the following attributes:

       [:from, :to, :cc, :bcc, :subject, :reply_to]

Example:

       context "the subject line must have the string 'foobarbaz'" do
         subject { Mail.deliver(@message_hash) }
         it { should be_subject("foobarbaz") }
       end

#### have_to_username matcher

The `username` in the `:to` field is when the `:to` field is formatted like this:

`"Peter Boling" <sanitize_email@example.org>`

Example:

       context "the to field must have the username 'Peter Boling'" do
         subject { Mail.deliver(@message_hash) }
         it { should have_to_username("Peter Boling") }
       end

#### have_sanitized_to_header matcher

Matches any part of the value of the first sanitized to header (`"X-Sanitize-Email-To"`),
which could be formatted like this:

`"Peter Boling" <sanitize_email@example.org>`

NOTE: It won't match subsequent headers like `"X-Sanitize-Email-To-2"`, or `"X-Sanitize-Email-To-3"`.

Example:

       context "the first 'X-Sanitize-Email-To' header must have the username 'Peter Boling'" do
         subject { Mail.deliver(@message_hash) }
         it { should have_sanitized_to_header("Peter Boling") }
       end

#### have_cc_username matcher

The `username` in the `:cc` field is when the `:c` field is formatted like this:

`"Peter Boling" <sanitize_email@example.org>`

Example:

       context "the cc field must have the username 'Peter Boling'" do
         subject { Mail.deliver(@message_hash) }
         it { should have_cc_username("Peter Boling") }
       end

#### have_sanitized_cc_header matcher

Matches any part of the value of the first sanitized cc header (`"X-Sanitize-Email-Cc"`),
which could be formatted like this:

`"Peter Boling" <sanitize_email@example.org>`

NOTE: It won't match subsequent headers like `"X-Sanitize-Email-Cc-2"`, or `"X-Sanitize-Email-Cc-3"`.

Example:

       context "the first 'X-Sanitize-Email-Cc' header must have the username 'Peter Boling'" do
         subject { Mail.deliver(@message_hash) }
         it { should have_sanitized_cc_header("Peter Boling") }
       end

### non-rspec (Test::Unit, mini-test, etc)

In your setup file:

       require "sanitize_email"
       # test helpers are *not* loaded by default in sanitize_email, as it is not primarily a gem for test suites.
       require "sanitize_email/test_helpers"

       SanitizeEmail::Config.configure do |config|
         config[:sanitized_to] = "sanitize_email@example.org"
         config[:sanitized_cc] = "sanitize_email@example.org"
         config[:sanitized_bcc] = "sanitize_email@example.org"
         # run/call whatever logic should turn sanitize_email on and off in this Proc.
         # config[:activation_proc] =      Proc.new { true }
         # Since this configuration is *inside* the spec_helper, it might be assumed that we always want to sanitize.  If we don't want to it can be easily manipulated with SanitizeEmail.unsanitary and SanitizeEmail.sanitary block helpers.
         # Thus instead of using the Proc (slower) we just engage it always:
         config[:engage] = true
         config[:use_actual_email_prepended_to_subject] = true         # or false
         config[:use_actual_environment_prepended_to_subject] = true   # or false
         config[:use_actual_email_as_sanitized_user_name] = true       # or false
       end

       # If your mail system is not one that sanitize_email automatically configures an interceptor for (ActionMailer, Mail)
       # then you will need to do the equivalent for whatever Mail system you are using.

       # You need to know what to do here... somehow get the methods into rhw scope of your tests.
       # Something like this maybe?
       include SanitizeEmail::TestHelpers
       # Look here to see what it gives you:
       # https://github.com/pboling/sanitize_email/blob/master/lib/sanitize_email/test_helpers.rb

## Deprecations

Sometimes things get deprecated (meaning they still work, but are noisy about it).  If this happens to you, and you like your head in the sand, call this number:

       SanitizeEmail::Deprecation.deprecate_in_silence = true

## Authors

Peter Boling is the original author of the code, and current maintainer.

Thanks to John Trupiano for turning Peter's original Rails plugin into the initial cut of this gem!

## 🤝 Contributing

See [CONTRIBUTING.md][🤝contributing]

[🤝contributing]: CONTRIBUTING.md

### You can help!

Take a look at the `reek` list which is the file called `REEK` and start fixing things.

To refresh the `reek` list:

`bundle exec reek > REEK`

Then follow these instructions:

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make some fixes.
4. Commit your changes (`git commit -am 'Added some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
7. Create new Pull Request.

## 🌈 Contributors

[![Contributors][🌈contrib-rocks-img]][🐙hub-contrib]

Contributor tiles (GitHub only) made with [contributors-img][🌈contrib-rocks].

Learn more about, or become one of, our 🎖 contributors on:

| Any                                 | Of                                    | These                               | DVCS                                |
|-------------------------------------|---------------------------------------|-------------------------------------|-------------------------------------|
| [🐙hub contributors][🐙hub-contrib] | [🧊berg contributors][🧊berg-contrib] | [🛖hut contributors][🛖hut-contrib] | [🧪lab contributors][🧪lab-contrib] |

[comment]: <> ( DVCS CONTRIB LINKS )

[🌈contrib-rocks]: https://contrib.rocks
[🌈contrib-rocks-img]: https://contrib.rocks/image?repo=pboling/sanitize_email

[🧊berg-contrib]: https://codeberg.org/pboling/sanitize_email/activity
[🐙hub-contrib]: https://github.com/pboling/sanitize_email/graphs/contributors
[🛖hut-contrib]: https://git.sr.ht/~galtzo/sanitize_email/log/
[🧪lab-contrib]: https://gitlab.com/pboling/sanitize_email/-/graphs/main?ref_type=heads

## Star History

<a href="https://star-history.com/#pboling/sanitize_email&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=pboling/sanitize_email&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=pboling/sanitize_email&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=pboling/sanitize_email&type=Date" />
 </picture>
</a>

## Running Specs

The basic compatibility matrix:

       appraisal install
       appraisal rake test

NOTE: `appraisal install` uses the standard Gemfile, and thus adds a bunch of gems
we do not need in each of our appraisal gemfiles.

Instead we can do one of:

       BUNDLE_GEMFILE=gemfiles/vanilla.gemfile appraisal generate
       BUNDLE_GEMFILE=gemfiles/vanilla.gemfile appraisal update

NOTE: This results in bad paths to the gemspec from each of the appraisal `gemfiles/rails_*_*.gemfile` files.
`gemspec path: "../../"` needs to be replaced with `gemspec path: "../"` in each Appraisal gemfile.

It is unlikely to be possible to install all of the supported Rubies & Railsies in a single container...
See the various github action workflows for more inspiration on running certain oldies.

### Code Coverage

[![Coverage Graph][🔑codecov-g]][🖇codecov]

[🔑codecov-g]: https://codecov.io/gh/pboling/sanitize_email/graphs/tree.svg?token=Joire8DbSW

## 🪇 Code of Conduct

Everyone interacting in this project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the [code of conduct][🪇conduct].

[🪇conduct]: CODE_OF_CONDUCT.md

## 📌 Versioning

This Library adheres to [Semantic Versioning 2.0.0][📌semver].
Violations of this scheme should be reported as bugs.
Specifically, if a minor or patch version is released that breaks backward compatibility,
a new version should be immediately released that restores compatibility.
Breaking changes to the public API will only be introduced with new major versions.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

As a result of this policy, you can (and should) specify a dependency on these libraries using
the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

       spec.add_dependency("sanitize_email", "~> 2.0")

[comment]: <> ( 📌 VERSIONING LINKS )

[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: http://semver.org/
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html

## References

* [Source Code](http://github.com/pboling/sanitize_email)
* [Gem Release Announcement](http://blog.smartlogicsolutions.com/2009/04/25/reintroducing-sanitize_email-work-with-production-email-without-fear/)
* [Peter's Original Writeup](http://galtzo.blogspot.com/2008/11/sanitize-email-never-worry-about.html)
* [Using sanitize_email to Preview HTML Emails Locally](http://blog.smartlogicsolutions.com/2009/04/30/using-sanitize-email-to-preview-html-emails-locally/)

## 📄 License

The gem is available as open source under the terms of
the [MIT License][📄license] [![License: MIT][📄license-img]][📄license-ref].
See [LICENSE.txt][📄license] for the official [Copyright Notice][📄copyright-notice-explainer].

[comment]: <> ( 📄 LEGAL LINKS )

[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.txt
[📄license-ref]: https://opensource.org/licenses/MIT
[📄license-img]: https://img.shields.io/badge/License-MIT-green.svg

### © Copyright

* Copyright (c) 2009 [John Trupiano](http://smartlogicsolutions.com/wiki/John_Trupiano) of [SmartLogic Solutions, LLC](http://www.smartlogicsolutions.com)
* Copyright (c) 2008 - 2018, 2020, 2022, 2024 [Peter H. Boling][peterboling] of [Rails Bling][railsbling]

[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com

## 🤑 One more thing

You made it to the bottom of the page,
so perhaps you'll indulge me for another 20 seconds.
I maintain many dozens of gems, including this one,
because I want Ruby to be a great place for people to solve problems, big and small.
Please consider supporting my efforts via the giant yellow link below,
or one of the others at the head of this README.

[![Buy me a latte][🖇buyme-img]][🖇buyme]

[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
