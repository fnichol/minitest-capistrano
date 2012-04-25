require 'minitest/spec'

module MiniTest
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
    # See MiniTest::Assertions#assert_have_captured
    #
    #    config.must_have_captured cmd
    #
    # :method: must_have_captured

    infect_an_assertion :assert_have_captured, :must_have_captured

    ##
    # See MiniTest::Assertions#refute_have_captured
    #
    #    config.wont_have_captured cmd
    #
    # :method: wont_have_captured

    infect_an_assertion :refute_have_captured, :wont_have_captured

    ##
    # See MiniTest::Assertions#assert_have_put
    #
    #    config.must_have_put path, data
    #
    # :method: must_have_put

    infect_an_assertion :assert_have_put, :must_have_put

    ##
    # See MiniTest::Assertions#refute_have_put
    #
    #    config.wont_have_put path, data
    #
    # :method: wont_have_put

    infect_an_assertion :refute_have_put, :wont_have_put

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
end

class Object # :nodoc:
  include MiniTest::Expectations
end
