require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MiniTest::Assertions do
  before do
    @config = Capistrano::Configuration.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
    @config.task(:startup)          { run "rails server" }
    @config.task(:announce_startup) { run "echo starting up"}
  end

  subject { MiniTest::Unit::TestCase.new 'fake tc' }

  it "asserts a command has run" do
    @config.run "yabba dabba"
    subject.assert_have_run "yabba dabba", @config
  end

  it "refutes a command has been run" do
    @config.run "nothing"
    subject.refute_have_run "yoyodyne", @config
  end

  it "asserts any command has run" do
    @config.run "yo"
    subject.assert_have_run_something @config
  end

  it "refute any command has run" do
    subject.refute_have_run_something @config
  end

  it "assert a command has been captured" do
    @config.capture "cat /tmp/surprise.txt"
    subject.assert_have_captured "cat /tmp/surprise.txt", @config
  end

  it "refutes a command has been captured" do
    subject.refute_have_captured "cat /tmp/anything", @config
  end

  it "assert a command has been streamed" do
    @config.stream "tail -f /tmp/surprise.txt"
    subject.assert_have_streamed "tail -f /tmp/surprise.txt", @config
  end

  it "refutes a command has been streamed" do
    subject.refute_have_streamed "tail -f /tmp/anything", @config
  end

  it "assert a file has been put" do
    @config.put "#!/usr/bin/env ruby", "/tmp/server.rb"
    subject.assert_have_put "/tmp/server.rb", @config, "#!/usr/bin/env ruby"
  end

  it "refutes a file has been put with data" do
    subject.refute_have_put "/tmp/anything", @config, "data"
  end

  it "refutes a file has been put with no data" do
    subject.refute_have_put "/tmp/anything", @config
  end

  it "asserts a callback exists for one task before another" do
    @config.before :startup, :announce_startup

    subject.assert_callback_before @config, :startup, :announce_startup
  end

  it "refutes a callback exists for one task before another" do
    subject.refute_callback_before @config, :startup, :nadda
  end

  it "asserts a callback exists for one task after another" do
    @config.after :start, :intialize

    subject.assert_callback_after @config, :start, :intialize
  end

  it "refutes a callback exists for one task after another" do
    subject.refute_callback_after @config, :clone, :nadda
  end

  it "asserts a task exists" do
    @config.namespace(:one) { task(:two) {} }

    subject.assert_have_task "one:two", @config
  end

  it "refute a task exists" do
    subject.refute_have_task "three:four", @config
  end
end
