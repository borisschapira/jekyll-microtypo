$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require "jekyll/microtypo/version"

Gem::Specification.new do |spec|
  spec.version = Jekyll::Microtypo::VERSION
  spec.homepage = "https://github.com/borisschapira/jekyll-microtypo"
  spec.authors = ["Boris Schapira"]
  spec.email = ["contact@borisschapira.com"]
  spec.files = %W(Rakefile Gemfile README.md LICENSE) + Dir["lib/**/*"]
  spec.summary = "Jekyll plugin that improves microtypography"
  spec.name = "jekyll-microtypo"
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.require_paths = ["lib"]
  spec.description = spec.description = <<-DESC
    Jekyll plugin that improves microtypography
  DESC

  spec.rubygems_version = '2.2.2'
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "jekyll", ">= 3.0", "< 4.0"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.42"
  spec.add_development_dependency "minitest", "~> 5.8", ">= 5.8.4"
end
