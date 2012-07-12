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
    # Fails unless +configuration+ has captured +cmd+.
    #
    #   assert_have_captured "echo hi", configuration

    def assert_have_captured(cmd, configuration, msg = nil)
      msg ||= "Expected configuration to capture #{cmd}, but did not"
      refute_nil configuration.captures[cmd], msg
    end

    ##
    # Fails if +configuration+ has captured +cmd+.

    def refute_have_captured(cmd, configuration, msg = nil)
      msg ||= "Expected configuration to not capture #{cmd}, but did"
      assert_nil configuration.captures[cmd], msg
    end

    ##
    # Fails unless +configuration+ has put +cmd+.
    #
    #   assert_have_put "/tmp/thefile", configuration, "thedata"

    def assert_have_put(path, configuration, data, msg = nil)
      msg ||= "Expected configuration to put #{path} with data, but did not"
      refute_nil configuration.putes[path], msg
      assert_equal configuration.putes[path][:data], data, msg
    end

    ##
    # Fails if +configuration+ has put +path+.

    def refute_have_put(path, configuration, data = nil, msg = nil)
      msg ||= "Expected configuration to not put #{path}, but did"
      assert_nil configuration.putes[path], msg
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
      if callbacks = configuration.callbacks[on]
        callbacks.select!{|c| c.only.include?(task_name.to_s) && c.source == other_task_name}
      else
        callbacks = {}
      end
      method = positive ? :refute_empty : :assert_empty
      send method, callbacks.select { |c| c.only.include?(task_name.to_s) && c.source == other_task_name }, msg
    end
  end
end
