require_relative "spec_helper"
ENV["RAILS_ENV"] ||= "test"

# Last thing before loading this gem is to setup code coverage
begin
  # This does not require "simplecov", but
  require "kettle-soup-cover"
  #   this next line has a side-effect of running `.simplecov`
  require "simplecov" if defined?(Kettle::Soup::Cover) && Kettle::Soup::Cover::DO_COV
rescue LoadError
  nil
end

require "bundler"
Bundler.require :default, :development
Combustion.initialize! :action_mailer, :action_controller

warn "Rails version is #{Rails.version}"
warn "BUNDLE_GEMFILE: #{ENV["BUNDLE_GEMFILE"]}"
warn "RAILS_VERSION: #{ENV["RAILS_VERSION"]}"
warn "RAILS_MAJOR_MINOR: #{ENV["RAILS_MAJOR_MINOR"]}"

# require "rspec/rails"

require "sanitize_email"
