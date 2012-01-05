require 'minitest/spec'

module MiniTest
  ##
  # MiniTest Assertions.  All assertion methods accept a +msg+ which is
  # printed if the assertion fails.

  module Assertions
    ##
    # Fails unless +configuration+ has run +cmd+.
    #
    #   assert_have_run "echo hi", configuration

    def assert_have_run(cmd, configuration, msg = nil)
      msg = message(msg) { "Expected configuration to run #{cmd}, but did not" }
      refute_nil configuration.runs[cmd], msg
    end

    ##
    # Fails if +configuration+ has run +cmd+.

    def refute_have_run(cmd, configuration, msg = nil)
      msg = message(msg) { "Expected configuration to not run #{cmd}, but did" }
      assert_nil configuration.runs[cmd], msg
    end
  end

  ##
  # It's where you hide your "assertions".

  module Expectations
    ##
    # See MiniTest::Assertions#assert_have_run
    #
    #    config.must_have_run cmd
    #
    # :method: must_have_run

    infect_an_assertion :assert_have_run, :must_have_run

    ##
    # See MiniTest::Assertions#refute_have_run
    #
    #    config.wont_have_run cmd
    #
    # :method: wont_have_run

    infect_an_assertion :refute_have_run, :wont_have_run
  end

  module Capistrano
    ##
    # Patches to Capistrano::Configuration to track invocations. Taken from
    # the awesome capistrano-spec gem
    # (https://github.com/technicalpickles/capistrano-spec)

    module ConfigurationExtension
      def get(remote_path, path, options={}, &block)
        gets[remote_path] = {:path => path, :options => options, :block => block}
      end

      def gets
        @gets ||= {}
      end

      def run(cmd, options={}, &block)
        runs[cmd] = {:options => options, :block => block}
      end

      def runs
        @runs ||= {}
      end

      def upload(from, to, options={}, &block)
        uploads[from] = {:to => to, :options => options, :block => block}
      end

      def uploads
        @uploads ||= {}
      end
    end
  end
end

class Object # :nodoc:
  include MiniTest::Expectations
end
