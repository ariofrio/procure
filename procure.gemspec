# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

# require 'procure/version'

Gem::Specification.new do |s|
  s.name        = "procure"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andres Riofrio"]
  s.email       = ["ariofrio@cs.ucsb.edu"]
  s.homepage    = "http://github.com/ariofrio/procure"
  s.summary     = "Generate an Azure app from a Procfile Heroku-style app"
  s.description = "Write your app in Java, add a Procfile, and run it in Azure. It's that simple."

  # s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project         = "bundler"

  s.add_dependency "mustache"
  s.add_dependency "require_all"

  s.add_development_dependency "rspec"
  s.add_development_dependency "fakefs"
  s.add_development_dependency "unindent"
  s.add_development_dependency "equivalent-xml"

  s.files        = Dir.glob("{bin,lib,templates,spec}/**/*") + %w(LICENSE README.md ROADMAP.md)
  s.executables  = ['procure']
  s.require_path = 'lib'
end