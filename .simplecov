require "kettle/soup/cover/config"

# Minimum coverage thresholds are set by kettle-soup-cover.
# They are controlled by ENV variables loaded by `mise` from `mise.toml`
# (with optional machine-local overrides in `.env.local`).
# If the values for minimum coverage need to change, they should be changed both there,
#   and in 2 places in .github/workflows/coverage.yml.
SimpleCov.configure do
  cover "lib/**/*.rb", "lib/**/*.rake", "exe/*.rb"
end

SimpleCov.start do
  track_files "lib/**/*.rb"
  track_files "lib/**/*.rake"
  track_files "exe/*.rb"
  add_filter "lib/sanitize_email/mail_ext" # For RSpec Matchers / Testing, not runtime
  add_filter "lib/sanitize_email/rspec_matchers" # For RSpec Matchers / Testing, not runtime
  add_filter "lib/sanitize_email/test_helpers" # For RSpec Matchers / Testing, not runtime
  add_filter "lib/sanitize_email/railtie" # Rails 3.0 is too old to test
  add_filter "lib/sanitize_email/engine_v5" # Rails 3.1 - 5.2 are too long-dead to test.
end
