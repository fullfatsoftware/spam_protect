
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "spam_protect"
  # Read the version from the lib file without loading the library
  version_file = File.expand_path("lib/spam_protect/version.rb", __dir__)
  spec.version = File.read(version_file).match(/VERSION\s*=\s*["'](.+)["']/)[1]

  spec.authors       = ["Full Fat Software"]
  spec.email         = ["hey@fullfatsoftware.com"]

  spec.summary       = %q{Simple helpers to protect from spam}
  spec.description   = %q{SpamProtect provides small helpers and middleware to reduce spam in web apps.}
  spec.homepage      = "https://example.com/spam_protect"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + %w[README.md LICENSE]
  spec.bindir        = "exe"
  spec.executables   = ["spam_protect"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  # This gem integrates with Rails via a Railtie; require railties at runtime
  spec.add_dependency "railties", ">= 7.2"
  # Add rails as a development dependency for testing the Railtie in CI
  spec.add_development_dependency "rails", ">= 7.2"

  # Require modern Ruby
  spec.required_ruby_version = ">= 3.3"
end
