require 'spec_helper'

describe Hghug::Game do

  before(:each) do
    @profile = mock.as_null_object
    Hghug::Profile.stub(:new).and_return(@profile)
    @game = Hghug::Game.new
    @profile.stub(:level).and_return(1)
    @profile.stub(:save)
    @profile.stub(:level_bump)
    @profile.stub(:current_attempts).and_return(0)
    @level = mock
    @level.stub(:full_description)
    @level.stub(:setup_level)
    Hghug::UI.stub(:puts)
    Hghug::Level.stub(:load).and_return(@level)
  end

  it "should have a profile" do
    @game.profile.should eql(@profile)
  end

  it "should show a description if the level is 0" do
    @level.should_not_receive(:solve)
    @profile.stub(:level).and_return(nil)
    @profile.should_receive(:level_bump)
    Hghug::UI.should_receive(:puts).with("Welcome to Hghug")
    @game.play_level
  end

  describe "play_level" do

    it "should echo congratulations if the level is solved" do
      @level.stub(:solve).and_return(true)
      @profile.should_receive(:level_bump)
      Hghug::UI.should_receive(:success).with("Congratulations, you have solved the level")
      @game.play_level
    end

    it "should echo the solution is not right" do
      @level.stub(:solve).and_return(false)
      Hghug::UI.should_receive(:error).with("Sorry, this solution is not quite right!")
      @game.play_level
    end

    it "should increment the number of failed attempts" do
      @level.stub(:solve).and_return(false)
      @profile.should_receive(:current_attempts=).with(1)
      @profile.should_receive(:save)
      @game.play_level
    end

    it "should prompt for a hint if the user has failed 3 times." do
      @profile.stub(:current_attempts).and_return(3)
      @level.stub(:solve).and_return(false)
      Hghug::UI.should_receive(:error).with("Sorry, this solution is not quite right!")
      Hghug::UI.should_receive(:error).with("Don't forget you can type `hghug hint` for a hint and `hghug reset` to reset the current level")
      @game.play_level
    end

  end


  describe "test_level" do
    it "Should output Valid solution if the solution is valid" do
      @level.stub(:solve).and_return(true)
      Hghug::UI.should_receive(:success).with("Valid solution")
      @game.test_level(@level)
    end

    it "Should output Invalid solution if the solution is invalid" do
      @level.stub(:solve).and_return(false)
      Hghug::UI.should_receive(:error).with("Invalid solution")
      @game.test_level(@level)
    end

    it "should call test when errors is true" do
      @level.should_receive(:test)
      @game.test_level(@level, true)
    end
  end

  it "should output the description of the next level" do
    @level.should_receive(:full_description)
    @profile.stub(:level=)
    @game.level_bump
  end

  it "should call setup_level for the next level" do
    @level.should_receive(:setup_level)
    @profile.stub(:level=)
    @game.level_bump
  end

end
