# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "pregel/version"

Gem::Specification.new do |s|
  s.name        = "pregel"
  s.version     = Pregel::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ilya Grigorik"]
  s.email       = ["ilya@igvita.com"]
  s.homepage    = "http://github.com/igrigorik/pregel"
  s.summary     = "Single-node implementation of Google's Pregel framework for large-scale graph processing."
  s.description = s.summary
  s.rubyforge_project = "pregel"

  s.add_development_dependency "rspec", '~> 2.0.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
