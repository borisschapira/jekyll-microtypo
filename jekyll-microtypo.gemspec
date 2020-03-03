# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "jekyll/microtypo/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Microtypo::VERSION
  spec.homepage = "https://borisschapira.github.io/jekyll-microtypo/"
  spec.authors = ["Boris Schapira"]
  spec.email = ["contact@borisschapira.com"]
  spec.files = %w(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Jekyll plugin that improves microtypography"
  spec.name = "jekyll-microtypo"
  spec.license = "MIT"
  spec.require_paths = ["lib"]
  spec.description = <<-DESC
    Jekyll plugin that improves microtypography
  DESC

  spec.required_ruby_version = ">= 2.4.0"
  spec.rubygems_version = "2.2.2"

  spec.add_runtime_dependency "jekyll", ">= 3.0", "< 5.0"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "minitest", "~> 5.8", ">= 5.8.4"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rubocop", "~> 0.51.0"
end
