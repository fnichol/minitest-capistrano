gem 'minitest'
require 'minitest/autorun'
require 'minitest/capistrano'
require 'capistrano'

describe MiniTest::Capistrano::ConfigurationExtension do
  before do
    @config = Object.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
  end

  describe "#get" do
    it "starts with an empty hash" do
      @config.gets.must_be_empty
    end

    it "adds an entry to the hash when called" do
      @config.gets.must_be_empty
      @config.get "hurdy", "gurdy"
      @config.gets.wont_be_empty
      @config.gets["hurdy"].wont_be_nil
    end
  end

  describe "#run" do
    it "starts with an empty hash" do
      @config.runs.must_be_empty
    end

    it "adds an entry to the hash when called" do
      @config.runs.must_be_empty
      @config.run "echo hi"
      @config.runs.wont_be_empty
      @config.runs["echo hi"].wont_be_nil
    end
  end

  describe "#upload" do
    it "starts with an empty hash" do
      @config.uploads.must_be_empty
    end

    it "adds an entry to the hash when called" do
      @config.uploads.must_be_empty
      @config.upload "path_to", "nowhere"
      @config.uploads.wont_be_empty
      @config.uploads["path_to"].wont_be_nil
    end
  end

  describe "#capture" do
    it "starts with an empty hash" do
      @config.captures.must_be_empty
    end

    it "adds an entry to the hash when called" do
      @config.captures.must_be_empty
      @config.capture "cat /tmp/secrets.txt"
      @config.captures.wont_be_empty
      @config.captures["cat /tmp/secrets.txt"].wont_be_nil
    end

    it "retuns a nil response if one is not pre-set" do
      @config.capture("cat /nope").must_be_nil
    end

    it "returns a response if one is pre-set" do
      @config.captures_responses["cat /tmp/file"] = "blah bleh"

      @config.capture("cat /tmp/file").must_equal "blah bleh"
    end
  end

  describe "#find_callback" do
    before do
      @config = Capistrano::Configuration.new
      @config.extend(MiniTest::Capistrano::ConfigurationExtension)
      @config.task(:startup)          { run "rails server" }
      @config.task(:announce_startup) { run "echo starting up"}
    end

    it "returns an empty array when no callbacks are found" do
      @config.find_callback(:before, @config.find_task("startup")).must_equal []
    end

    it "returns an array of callbacks that apply to the task" do
      @config.before :startup, :announce_startup

      @config.find_callback(:before, @config.find_task("startup")).
        first.source.must_equal :announce_startup
    end
  end
end

describe MiniTest::Assertions do
  before do
    @config = Object.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
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

  describe "callbacks" do
    before do
      @config = Capistrano::Configuration.new
      @config.extend(MiniTest::Capistrano::ConfigurationExtension)
      @config.task(:startup)          { run "rails server" }
      @config.task(:announce_startup) { run "echo starting up"}
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
  end
end

describe MiniTest::Expectations do
  before do
    @config = Object.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
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

  describe "callbacks" do
    before do
      @config = Capistrano::Configuration.new
      @config.extend(MiniTest::Capistrano::ConfigurationExtension)
      @config.task(:startup)          { run "rails server" }
      @config.task(:announce_startup) { run "echo starting up"}
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
  end
end
