source 'https://rubygems.org'

# Specify your gem's dependencies in minitest-capistrano.gemspec
gemspec

group :test do
  gem 'rake', '~> 0.9'

  # allow CI to override the version of minitest for matrix testing
  gem 'minitest', (ENV['MINITEST_VERSION'] || '>= 0')
end

platforms :jruby do
  gem 'jruby-openssl'
end
