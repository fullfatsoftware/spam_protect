# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "spam_protect"
  # Read the version from the lib file without loading the library
  version_file = File.expand_path("lib/spam_protect/version.rb", __dir__)
  spec.version = File.read(version_file).match(/VERSION\s*=\s*["'](.+)["']/)[1]

  spec.authors = ["Full Fat Software"]
  spec.email = ["hey@fullfatsoftware.com"]

  spec.summary = "A lightweight Ruby gem to help reduce spam in rails applications"
  spec.description = "spam_protect stops contact message spam in rails applications by adding honeypot fields and timestamp checks."
  spec.homepage = "https://github.com/fullfatsoftware/spam_protect"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*.rb"] + %w[README.md LICENSE]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "rubocop-performance"

  spec.add_dependency "rails", ">= 7.2"

  # Require modern Ruby
  spec.required_ruby_version = ">= 3.3"
end
