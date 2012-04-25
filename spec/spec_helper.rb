gem 'minitest'

require 'minitest/autorun'
require 'minitest/colorize'
require 'capistrano'

require 'minitest-capistrano'
require File.expand_path(File.join(File.dirname(__FILE__), 'fixtures','recipes','bark'))
