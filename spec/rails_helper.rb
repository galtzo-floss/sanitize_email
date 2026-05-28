require_relative "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require "combustion"
Combustion.path = "spec/internal"
Combustion.initialize! :action_mailer, :action_controller

warn "Rails version is #{Rails.version}"
warn "BUNDLE_GEMFILE: #{ENV["BUNDLE_GEMFILE"]}"
warn "RAILS_VERSION: #{ENV["RAILS_VERSION"]}"
warn "RAILS_MAJOR_MINOR: #{ENV["RAILS_MAJOR_MINOR"]}"

# require "rspec/rails"

require "sanitize_email"
