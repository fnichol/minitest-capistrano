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
      msg ||= "Expected configuration to run #{cmd}, but did not"
      refute_nil configuration.runs[cmd], msg
    end

    ##
    # Fails if +configuration+ has run +cmd+.

    def refute_have_run(cmd, configuration, msg = nil)
      msg ||= "Expected configuration to not run #{cmd}, but did"
      assert_nil configuration.runs[cmd], msg
    end

    ##
    # Fails unless +configuration+ has not run anything.
    #
    #   assert_have_run_something configuration

    def assert_have_run_something(configuration, msg = nil)
      msg ||= "Expected configuration to have run something, but did not"
      refute_empty configuration.runs, msg
    end

    ##
    # Fails if +configuration+ has run any commands.
    #
    #   refute_have_run_something configuration

    def refute_have_run_something(configuration, msg = nil)
      msg ||= "Expected configuration to have run nothing, but did"
      assert_empty configuration.runs, msg
    end

    ##
    # Fails unless +configuration+ has a callback of +before_task_name+ before
    # +task_name+.
    #
    #   assert_callback_before configuration, :stop, :finalize

    def assert_callback_before(configuration, task_name, before_task_name, msg = nil)
      msg ||= "Expected configuration to callback #{task_name.inspect} before #{before_task_name.inspect} but did not"
      test_callback_on(true, configuration, task_name, :before, before_task_name, msg)
    end

    ##
    # Fails if +configuration+ has a callback of +before_task_name+ before
    # +task_name+.
    #
    #   refute_callback_before configuration, :stop, :start

    def refute_callback_before(configuration, task_name, before_task_name, msg = nil)
      msg ||= "Expected configuration to not have a callback #{task_name.inspect} before #{before_task_name.inspect} but did"
      test_callback_on(false, configuration, task_name, :before, before_task_name, msg)
    end

    ##
    # Fails unless +configuration+ has a callback of +after_task_name+ after
    # +task_name+.
    #
    #   assert_callback_after configuration, :reload, :log_event

    def assert_callback_after(configuration, task_name, after_task_name, msg = nil)
      msg ||= "Expected configuration to callback #{task_name.inspect} after #{after_task_name.inspect} but did not"
      test_callback_on(true, configuration, task_name, :after, after_task_name, msg)
    end

    ##
    # Fails if +configuration+ has a callback of +after_task_name+ after
    # +task_name+.
    #
    #   refute_callback_after configuration, :start, :stop

    def refute_callback_after(configuration, task_name, after_task_name, msg = nil)
      msg ||= "Expected configuration to not have a callback #{task_name.inspect} after #{after_task_name.inspect} but did"
      test_callback_on(false, configuration, task_name, :after, after_task_name, msg)
    end

    ##
    # Fails unless +configuration+ has a task called +task_name+.
    #
    #   assert_have_task "deploy:restart", configuration

    def assert_have_task(task_name, configuration, msg = nil)
      msg ||= "Expected configuration to have task #{task_name} but did not"
      refute_nil configuration.find_task(task_name), msg
    end

    ##
    # Fails if +configuration+ has a task called +task_name+.
    #
    #   refute_have_task "deploy:nothing", configuration

    def refute_have_task(task_name, configuration, msg = nil)
      msg ||= "Expected configuration to not have task #{task_name} but did"
      assert_nil configuration.find_task(task_name), msg
    end

    private

    def test_callback_on(positive, configuration, task_name, on, other_task_name, msg)
      task = configuration.find_task(task_name)
      callbacks = configuration.find_callback(on, task)

      if callbacks
        method = positive ? :refute_empty : :assert_empty
        send method, callbacks.select { |c| c.source == other_task_name }, msg
      else
        flunk msg
      end
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

    ##
    # See MiniTest::Assertions#assert_have_run_something
    #
    #   config.must_have_run_something
    #
    # :method: must_have_run_something

    infect_an_assertion :assert_have_run_something, :must_have_run_something, true

    ##
    # See MiniTest::Assertions#refute_have_run_something
    #
    #    config.wont_have_run_anything
    #
    # :method: wont_have_run_anything

    infect_an_assertion :refute_have_run_something, :wont_have_run_anything, true

    ##
    # See MiniTest::Assertions#assert_callback_before
    #
    #   config.must_have_callback_before :stop, :warn_people
    #
    # :method: must_have_callback_before

    infect_an_assertion :assert_callback_before, :must_have_callback_before, true

    ##
    # See MiniTest::Assertions#refute_callback_before
    #
    #   config.wont_have_callback_before :stop, :begin_long_job
    #
    # :method: wont_have_callback_before

    infect_an_assertion :refute_callback_before, :wont_have_callback_before, true

    ##
    # See MiniTest::Assertions#assert_callback_after
    #
    #   config.must_have_callback_after :reload, :log_event
    #
    # :method: must_have_callback_after

    infect_an_assertion :assert_callback_after, :must_have_callback_after, true

    ##
    # See MiniTest::Assertions#refute_callback_after
    #
    #   config.wont_have_callback_after :stop, :do_taxes
    #
    # :method: wont_have_callback_after

    infect_an_assertion :refute_callback_after, :wont_have_callback_after, true

    ##
    # See MiniTest::Assertions#assert_have_task
    #
    #   config.must_have_task "deploy:restart"
    #
    # :method: must_have_task

    infect_an_assertion :assert_have_task, :must_have_task

    ##
    # See MiniTest::Assertions#refute_have_task
    #
    #   config.wont_have_task "nothing:here"
    #
    # :method: wont_have_task

    infect_an_assertion :refute_have_task, :wont_have_task
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

      def capture(command, options={})
        captures[command] = {:options => options}
        captures_responses[command]
      end

      def captures
        @captures ||= {}
      end

      def captures_responses
        @captures_responses ||= {}
      end

      def find_callback(on, task)
        task = find_task(task) if task.kind_of?(String)

        Array(callbacks[on]).select do |task_callback|
          task_callback.applies_to?(task) ||
            task_callback.source == task.fully_qualified_name
        end
      end
    end
  end
end

class Object # :nodoc:
  include MiniTest::Expectations
end
