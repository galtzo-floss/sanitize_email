# frozen_string_literal: true

# kettle-jem:freeze
# To retain chunks of comments & code during kettle-jem templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# kettle-jem will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

# HOW TO UPDATE APPRAISALS (Appraisal2 RuboCop plugin normalizes generated gemfiles on modern Ruby):
#   bin/rake appraisal:update

plugin "appraisal2-rubocop", require: "appraisal2/rubocop", optional: true

# HOW TO UPDATE APPRAISALS (Appraisal2 RuboCop hooks normalize generated gemfiles on modern Ruby):

begin
  require "appraisal2/rubocop"
rescue LoadError
end

# kettle-jem:freeze
# To retain chunks of comments & code during sanitize_email templating:
# Wrap custom sections with freeze markers (e.g., as above and below this comment chunk).
# sanitize_email will then preserve content between those markers across template runs.
# kettle-jem:unfreeze

# HOW TO UPDATE APPRAISALS (will run rubocop_gradual's autocorrect afterward):
#   bin/rake appraisal:update

# Lock/Unlock Deps Pattern
#
# Two often conflicting goals resolved!
#
#  - unlocked_deps.yml
#    - All runtime & dev dependencies, but does not have a `gemfiles/*.gemfile.lock` committed
#    - Uses an Appraisal2 "unlocked_deps" gemfile, and the current MRI Ruby release
#    - Know when new dependency releases will break local dev with unlocked dependencies
#    - Broken workflow indicates that new releases of dependencies may not work
#
#  - locked_deps.yml
#    - All runtime & dev dependencies, and has a `Gemfile.lock` committed
#    - Uses the project's main Gemfile, and the current MRI Ruby release
#    - Matches what contributors and maintainers use locally for development
#    - Broken workflow indicates that a new contributor will have a bad time
#

appraise "unlocked_deps" do
  # Seems to be an undeclared dependency of yard.
  # /opt/hostedtoolcache/Ruby/4.0.0/x64/lib/ruby/gems/4.0.0/gems/yard-0.9.38/lib/yard/parser/ruby/legacy/irb/slex.rb:13: warning: irb/notifier is found in irb, which is not part of the default gems since Ruby 4.0.0.
  # You can add irb to your Gemfile or gemspec to fix this error.
  # rake aborted!
  # LoadError: cannot load such file -- irb/notifier (LoadError)
  # /opt/hostedtoolcache/Ruby/4.0.0/x64/bin/bundle:25:in '<main>'
  # But it won't install on TruffleRuby, so it can't be part of modular gemfiles used there:
  # An error occurred while installing psych (5.3.1), and Bundler cannot continue.
  #
  # In ruby_3_2.gemfile:
  #   irb was resolved to 1.16.0, which depends on
  #     rdoc was resolved to 7.0.3, which depends on
  #       psych
  gem "irb", "~> 1.17" # ruby >= 2.7

  eval_gemfile "modular/coverage.gemfile"
  eval_gemfile "modular/documentation.gemfile"
  eval_gemfile "modular/optional.gemfile"
  eval_gemfile "modular/style.gemfile"
  eval_gemfile "modular/x_std_libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "head" do
  eval_gemfile "modular/x_std_libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "current" do
  eval_gemfile "modular/x_std_libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "dep-heads" do
  eval_gemfile "modular/runtime_heads.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "ruby-2-4" do
  eval_gemfile "modular/x_std_libs/r2.4/libs.gemfile"
  eval_gemfile "rails_5_2.gemfile"
end

appraise "ruby-2-5" do
  eval_gemfile "modular/x_std_libs/r2.6/libs.gemfile"
  eval_gemfile "rails_6_0.gemfile"
end

appraise "ruby-2-6" do
  eval_gemfile "modular/x_std_libs/r2.6/libs.gemfile"
  eval_gemfile "rails_6_1.gemfile"
end

appraise "ruby-2-7" do
  eval_gemfile "modular/x_std_libs/r2/libs.gemfile"
  eval_gemfile "rails_7_0.gemfile"
end

appraise "ruby-3-0" do
  eval_gemfile "modular/json/truffleruby_22_3.gemfile"
  eval_gemfile "modular/json/truffleruby_23_0.gemfile"
  eval_gemfile "modular/x_std_libs/r3.1/libs.gemfile"
  eval_gemfile "rails_7_1.gemfile"
end

appraise "ruby-3-1" do
  eval_gemfile "modular/x_std_libs/r3.1/libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "ruby-3-2" do
  eval_gemfile "modular/json/truffleruby_23_1.gemfile"
  eval_gemfile "modular/x_std_libs/r3/libs.gemfile"
  eval_gemfile "rails_8_0.gemfile"
end

appraise "truffleruby-23-1" do
  eval_gemfile "modular/x_std_libs/r3/libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "ruby-3-3" do
  eval_gemfile "modular/x_std_libs/r3/libs.gemfile"
  eval_gemfile "rails_8_0.gemfile"
end

appraise "ruby-3-4" do
  eval_gemfile "modular/x_std_libs/r3/libs.gemfile"
  eval_gemfile "rails_8_0.gemfile"
end

appraise "audit" do
  eval_gemfile "modular/x_std_libs.gemfile"
end

appraise "coverage" do
  eval_gemfile "modular/coverage.gemfile"
  eval_gemfile "modular/optional.gemfile"
  eval_gemfile "modular/x_std_libs.gemfile"
  eval_gemfile "rails_7_2.gemfile"
end

appraise "style" do
  eval_gemfile "modular/style.gemfile"
  eval_gemfile "modular/x_std_libs.gemfile"
end

appraise "templating" do
  eval_gemfile "modular/templating.gemfile"
  eval_gemfile "modular/x_std_libs.gemfile"
end

appraise "rails-3-0" do
  gem "rails", "~> 3.0.0"
  gem "reek", "~> 2.0" # for Ruby < 2.0
  gem "tins", "~> 1.6.0" # for Ruby < 2.0
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
  gem "rest-client", "~> 1.8.0"
  gem "tzinfo", "~> 0.3.23"
end

appraise "rails-3-1" do
  gem "actionmailer", "~> 3.1.0"
  gem "railties", "~> 3.1.0"
  gem "reek", "~> 2.0" # for Ruby < 2.0
  gem "tins", "~> 1.6.0" # for Ruby < 2.0
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
  gem "rest-client", "~> 1.8.0"
  gem "tzinfo", "~> 1.0"
end

appraise "rails-3-2" do
  gem "actionmailer", "~> 3.2.0"
  gem "railties", "~> 3.2.0"
  # reek >= 4.0 requires Ruby 2.1 minimum
  gem "reek", "~>3.11.0"
  gem "json", "~> 1.8.3"
  gem "rake", "~> 10.0"
  gem "tzinfo", "~> 1.0"
end

appraise "rails-4-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.0.13"
  gem "railties", "~> 4.0.13"
  gem "rdoc", "6.1.2.1"
  gem "json", ">= 1.7.7", "~> 1.7"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

appraise "rails-4-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.1.16"
  gem "railties", "~> 4.1.16"
  gem "rdoc", "6.1.2.1"
  gem "json", ">= 1.7.7", "~> 1.7"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

appraise "rails-4-2" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 4.2.11.3"
  gem "railties", "~> 4.2.11.3"
  gem "rdoc", "6.1.2.1"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 3.0" # For Rails 4
end

appraise "rails-5-0" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 5.0.7.2"
  gem "railties", "~> 5.0.7.2"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 4.0" # For Rails 5.0 & 5.1
end

appraise "rails-5-1" do
  # Load order is very important with combustion!
  gem "combustion", "~> 1.4"

  gem "actionmailer", "~> 5.1.7"
  gem "railties", "~> 5.1.7"
  gem "nokogiri"
  #   gem "rspec-rails", "~> 4.0" # For Rails 5.0 & 5.1
end
