# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sanitize_email/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "sanitize_email"
  s.version = SanitizeEmail::VERSION

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Boling", "John Trupiano", "George Anderson"]
  s.summary = "Rails/Sinatra/Mail gem: Test email abilities without ever sending a message to actual live addresses"
  s.description = "In Rails, Sinatra, or simply the mail gem: Aids in development, testing, qa, and production troubleshooting of email issues without worrying that emails will get sent to actual live addresses."
  s.email = ["peter.boling@gmail.com", "jtrupiano@gmail.com", "george@benevolentcode.com"]
  s.extra_rdoc_files = [
    "CHANGELOG",
    "LICENSE",
    "README.rdoc"
  ]
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.homepage = "http://github.com/pboling/sanitize_email"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"

  # Runtime Dependencies
  # to replace the cattr_accessor method we lost when removing rails from run time dependencies
  #s.add_runtime_dependency(%q<facets>, ["> 0"])

  # Development Dependencies
  s.add_development_dependency(%q<rails>, ["> 3"])
  s.add_development_dependency(%q<actionmailer>, ["> 3"])
  s.add_development_dependency(%q<letter_opener>, [">= 0"])
  s.add_development_dependency(%q<launchy>, [">= 0"])
  s.add_development_dependency(%q<rspec>, [">= 2.11"])
  s.add_development_dependency(%q<mail>, [">= 0"])
  s.add_development_dependency(%q<rdoc>, [">= 3.12"])
  s.add_development_dependency(%q<reek>, [">= 1.2.8"])
  s.add_development_dependency(%q<roodi>, [">= 2.1.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<email_spec>, [">= 0"])
end

