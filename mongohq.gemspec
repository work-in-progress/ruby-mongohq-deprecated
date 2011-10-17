# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongohq/version"


Gem::Specification.new do |s|
  s.name        = "mongohq"
  s.version     = Mongohq::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Martin Wawrusch"]
  s.email       = ["martin@wawrusch.com"]
  s.homepage    = "http://github.com/scottyapp/ruby-mongohq"
  s.summary     = %q{An API wrapper for the mongohq API (http://mongohq.com).}
  s.description = %q{A gem that implements the mongohq.com API which allows you to host mongodb in the cloud.}
  s.extra_rdoc_files   = ["LICENSE","README.md"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "mongohq"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency "httparty"  
  s.add_runtime_dependency "multi_json", "~> 1.0"  
  s.add_development_dependency "rspec", "~> 2.1"
  s.add_development_dependency "rake", "~> 0.8"
  s.add_development_dependency "fakeweb",">= 0"
  s.add_development_dependency "bundler","~> 1.0.0"
  #s.add_development_dependency "rcov", ">= 0"
  s.post_install_message=<<eos
**********************************************************************************
  Thank you for using this gem.
  
  Follow @martin_sunset on Twitter for announcements, updates and news
  https://twitter.com/martin_sunset

  To get the source go to http://github.com/scottyapp/ruby-mongohq

**********************************************************************************    
eos
  
  
end
