# -*- encoding: utf-8 -*-
require File.expand_path('../lib/minitest/capistrano/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Fletcher Nichol"]
  gem.email         = ["fnichol@nichol.ca"]
  gem.description   = %q{MiniTest assertions and expectations for testing Capistrano recipes}
  gem.summary       = %q{MiniTest assertions and expectations for testing Capistrano recipes}
  gem.homepage      = "https://github.com/fnichol/minitest-capistrano"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "minitest-capistrano"
  gem.require_paths = ["lib"]
  gem.version       = MiniTest::Capistrano::VERSION

  gem.add_dependency "minitest"
  gem.add_dependency "capistrano", "~> 2.9"

  gem.add_development_dependency "bundler", "~> 1.3"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard-minitest", "~> 0.5.0"
end
