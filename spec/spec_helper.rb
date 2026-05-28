# frozen_string_literal: true

# Config for development dependencies of this library
# i.e., not configured by this library
#
# SimpleCov & related config (must run BEFORE any other requires)
# NOTE: Gemfiles for non-coverage appraisals may not have kettle-soup-cover.
#       The rescue LoadError handles that scenario.
begin
  require "kettle-soup-cover"
  require "simplecov" if Kettle::Soup::Cover::DO_COV # `.simplecov` is run here!
rescue LoadError => error
  # check the error message and re-raise when unexpected
  raise error unless error.message.include?("kettle")
end

# External RSpec & related config
require "kettle/test/rspec"
require "rspec/pending_for"

# Project-specific RSpec config
require_relative "config/byebug"
require_relative "config/rspec/helpers"
require_relative "config/rspec/rspec_block_is_expected"
require_relative "config/rspec/rspec_core"
require_relative "config/rspec/version_gem"
require_relative "support/matchers"
