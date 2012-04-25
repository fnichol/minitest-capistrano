require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MiniTest::Capistrano::ConfigurationExtension do
  before do
    @config = Capistrano::Configuration.new
    @config.extend(MiniTest::Capistrano::ConfigurationExtension)
    @config.task(:startup)          { run "rails server" }
    @config.task(:announce_startup) { run "echo starting up"}
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

  describe "#put" do
    it "starts with an empty hash" do
      @config.putes.must_be_empty
    end

    it "adds an entry to the hash when called" do
      @config.putes.must_be_empty
      @config.put "data", "path"
      @config.putes.wont_be_empty
      @config.putes["path"].wont_be_nil
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
