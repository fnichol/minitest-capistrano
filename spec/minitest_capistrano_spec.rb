require 'minitest/autorun'
require 'minitest/capistrano'

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
end
