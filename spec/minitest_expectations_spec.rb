require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MiniTest::Expectations do
  before do
    @config = Capistrano::Configuration.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
    @config.task(:startup)          { run "rails server" }
    @config.task(:announce_startup) { run "echo starting up"}
  end

  it "needs to verify a command has run" do
    @config.run "yabba dabba"
    @config.must_have_run "yabba dabba"
  end

  it "needs to verify a command has not been run" do
    @config.run "wot?"
    @config.wont_have_run "yabba dabba"
  end

  it "needs to verify something has run" do
    @config.run "woah"
    @config.must_have_run_something
  end

  it "needs to verify no command has been run" do
    @config.wont_have_run_anything
  end

  it "needs to verify a command has captured" do
    @config.capture "yabba dabba"
    @config.must_have_captured "yabba dabba"
  end

  it "needs to verify a command has not been captured" do
    @config.capture "wot?"
    @config.wont_have_captured "yabba dabba"
  end

  it "needs to verify a file has been put" do
    @config.put "thedata", "thepath"
    @config.must_have_put "thepath", "thedata"
  end

  it "needs to verify a file has not been put" do
    @config.put "yabbadabbadata", "yepperspath"
    @config.wont_have_put "nopath"
  end

  it "needs to verify a callback exists for a task before another" do
    @config.before :stop, :warn_people

    @config.must_have_callback_before :stop, :warn_people
  end

  it "needs to verify no callback exists for a task before another" do
    @config.wont_have_callback_before :reload, :stop
  end

  it "needs to verify a callback exists for a task after another" do
    @config.after :start, :init_database

    @config.must_have_callback_after :start, :init_database
  end

  it "needs to verify no callback exists for a task after another" do
    @config.wont_have_callback_after :stop, :do_taxes
  end

  it "needs to verify a task exists by name" do
    @config.must_have_task "startup"
  end

  it "needs to verify no task exists by name" do
    @config.wont_have_task "doofus"
  end
end
