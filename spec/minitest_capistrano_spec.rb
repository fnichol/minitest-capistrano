require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

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

describe '#load_capistrano_recipe' do
  Capistrano::Configuration.instance = Capistrano::Configuration.new
  load_capistrano_recipe(Capistrano::Recipes::Bark)

  it 'extends the config' do
    Capistrano::Configuration.instance.must_respond_to :uploads
  end

  it 'loads the specified recipe into the instance configuration' do
    Capistrano::Configuration.instance.must_have_task "bark"
  end

  it 'sets the capistrano instance to the extend config' do
    Capistrano::Configuration.instance.must_equal recipe
  end

  it 'sets recipe to the config for reference' do
    recipe.must_equal Capistrano::Configuration.instance
  end

  it 'sets subject to the config for reference' do
    subject.must_equal Capistrano::Configuration.instance
  end

  it 'holds onto the original config' do
    @orig_config.must_be_instance_of Capistrano::Configuration.instance.class
    @orig_config.wont_equal Capistrano::Configuration.instance
  end
end
