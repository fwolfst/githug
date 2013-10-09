require 'spec_helper'
require 'hghug/cli'

describe Hghug::CLI do

  before(:each) do
    game = mock.as_null_object
    @cli = Hghug::CLI.new
    Hghug::Game.stub(:new).and_return(game)
  end

  it "should print the logo" do
    Hghug::UI.should_receive(:word_box).with("Githug")
    @cli.stub(:make_directory)
    @cli.play
  end

  it "should create a directory if one does not exist" do
    Hghug::UI.stub(:ask).and_return(true)
    Dir.should_receive(:mkdir).with("./git_hug")
    Dir.should_receive(:chdir).with("git_hug")
    @cli.make_directory
  end

  it "should not make a directory if you are in the game directory" do
    Dir.stub(:pwd).and_return("/home/git_hug")
    Hghug::UI.should_not_receive(:ask)
    @cli.make_directory
  end

  it "should exit if the user selects no" do
    Hghug::UI.stub(:ask).and_return(false)
    lambda {@cli.make_directory}.should raise_error(SystemExit)
  end

  it "should prompt to change into the directory if it exists" do
    File.stub(:exists?).and_return(true)
    Hghug::UI.should_receive(:puts).with("Please change into the git_hug directory")
    lambda {@cli.make_directory}.should raise_error(SystemExit)
  end

  describe "test" do
    it "should perform a test run of the level" do
      level = mock
      game = mock
      @cli.stub(:make_directory)
      Hghug::Level.should_receive(:load_from_file).with("/foo/bar/test/level.rb").and_return(level)
      Hghug::Game.stub(:new).and_return(game)
      game.should_receive(:test_level).with(level, anything)
      @cli.test("/foo/bar/test/level.rb")
    end
  end

  describe "level methods" do
    before(:each) do
      @level = mock
      @profile = mock
      @profile.stub(:level).and_return(1)
      Hghug::Profile.stub(:load).and_return(@profile)
      Hghug::Level.stub(:load).and_return(@level)
      Hghug::Level.stub(:load_from_file).with("/foo/bar/level.rb").and_return(@level)
    end

    it "should call the hint method on the level" do
      @level.should_receive(:show_hint)
      @cli.hint
    end

    describe "reset" do


      it "should reset the current level" do
        @level.should_receive(:setup_level)
        @level.should_receive(:full_description)
        Hghug::UI.should_receive(:word_box).with("Githug")
        Hghug::UI.should_receive(:puts).with("resetting level")
        @cli.reset
      end

      it "should not reset if the level cannot be loaded" do
        Hghug::Level.stub(:load).and_return(false)
        @level.should_not_receive(:setup_level)
        @level.should_not_receive(:full_description)
        Hghug::UI.should_receive(:error).with("Level does not exist")
        @cli.reset
      end

      it "should reset the level with a path" do
        @level.should_receive(:setup_level)
        @level.should_receive(:full_description)
        Hghug::UI.should_receive(:word_box).with("Githug")
        Hghug::UI.should_receive(:puts).with("resetting level")
        @cli.reset("/foo/bar/level.rb")
      end
    end

  end

end
