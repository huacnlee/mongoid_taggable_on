# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "mongoid_taggable_on"
  s.version     = "0.1.4"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/huacnlee/mongoid_taggable_on"
  s.summary     = %q{Mongoid Taggable provides some helpers to create taggable documents, can use many fields.}
  s.description = s.summary
	s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'

  s.add_dependency "mongoid", ["> 2.0.0"]
end
