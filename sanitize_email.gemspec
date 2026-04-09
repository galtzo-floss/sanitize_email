# frozen_string_literal: true

# Get the GEMFILE_VERSION without *require* "my_gem/version", for code coverage accuracy
# See: https://github.com/simplecov-ruby/simplecov/issues/557#issuecomment-825171399
load "lib/sanitize_email/version.rb"
gem_version = SanitizeEmail::Version::VERSION
SanitizeEmail::Version.send(:remove_const, :VERSION)

Gem::Specification.new do |spec|
  spec.name = "sanitize_email"
  spec.version = gem_version

  # See CONTRIBUTING.md
  spec.cert_chain = [ENV.fetch("GEM_CERT_PATH", "certs/#{ENV.fetch("GEM_CERT_USER", ENV["USER"])}.pem")]
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $PROGRAM_NAME.end_with?("gem")

  spec.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  spec.summary = "Email Condom for your Ruby Server"
  spec.description = <<~DESCRIPTION
      Email Condom for your Ruby Server.
    In Rails, Sinatra, et al, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses.
  DESCRIPTION
  spec.email = ["peter.boling@gmail.com"]
  spec.homepage = "https://github.com/pboling/#{spec.name}"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[
    # Splats (alphabetical)
    "lib/**/*.rb",
    # Files (alphabetical)
    "CHANGELOG.md",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "LICENSE.txt",
    "README.md",
    "SECURITY.md",
  ]
  spec.executables = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/v#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/v#{spec.version}/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"
  spec.metadata["wiki_uri"] = "#{spec.homepage}/wiki"
  spec.metadata["funding_uri"] = "https://liberapay.com/pboling"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Runtime Dependencies
  # A project wanting to use this gem's engine/railtie will be expected to have already loaded the rails/railtie gem.
  # s.add_dependency "railties", ">= 3.2"
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  # s.add_runtime_dependency("facets", ["> 0"])
  spec.add_dependency("mail", "~> 2.0")
  spec.add_dependency("version_gem", "~> 1.1", ">= 1.1.4")

  # Development Dependencies
  spec.add_development_dependency("appraisal", "~> 2.5")
  spec.add_development_dependency("json", ">= 1.7.7")
  spec.add_development_dependency("rake", ">= 0.8.7")
  spec.add_development_dependency("rdoc", ">= 3")
  spec.add_development_dependency("rspec", ">= 3")
  spec.add_development_dependency("rspec-block_is_expected", "~> 1.0", ">= 1.0.5")
  spec.add_development_dependency("rspec-pending_for", "~> 0.1", ">= 0.1.16")
end
