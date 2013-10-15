require 'spec_helper'

describe Hghug::Repository do

  before(:each) do
    @grit = mock
    Mercurial::Repository.stub(:new).and_return(@grit)
    @repository = Hghug::Repository.new
    @repository.stub(:create_hgignore)
  end

  describe "initialize" do

    it "should call grit on initialize" do
      Mercurial::Repository.should_receive(:new).with(".").and_return(@grit)
      repo = Hghug::Repository.new
      repo.grit.should equal(@grit)
    end

    it "should contain a nil grit if the repo is invalid" do
      Mercurial::Repository.should_receive(:new).and_raise(Grit::InvalidGitRepositoryError)
      repo = Hghug::Repository.new
      repo.grit.should equal(nil)
    end

    it "should initialize with a location" do
      Mercurial::Repository.should_receive(:new).with("test").and_return(@grit)
      repo = Hghug::Repository.new("test")
    end

  end

  describe "reset" do

    before(:each) do
      FileUtils.stub(:rm_rf)
    end

    it "should do nothing if the current directory isn't hg_hug" do
      Dir.stub(:pwd).and_return("/tmp/foo")
      FileUtils.should_not_receive(:rm_rf)
      @repository.reset
    end

    it "should remove all the files except .hgignore and .profile.yml" do
      Dir.stub(:pwd).and_return("/tmp/hg_hug")
      Dir.stub(:entries).and_return([".profile.yml", ".hgignore", "..", ".", "README", ".hg"])
      FileUtils.should_receive(:rm_rf).with("README")
      FileUtils.should_receive(:rm_rf).with(".git")
      @repository.reset
    end
  end


  describe "create_hgignore" do
    it "should create a hgignore" do
      @repository.unstub(:create_hgignore)
      File.stub(:exists?).and_return(true)
      Dir.should_receive(:chdir).with("hg_hug")
      File.should_receive(:open).with(".hgignore", "w")
      @repository.create_hgignore
    end
  end

  describe "valid?" do
    it "should be valid if grit exists" do
      @repository.should be_valid
    end

    it "should not be valid if grit does not exist" do
      @repository.instance_variable_set("@grit", nil)
      @repository.should_not be_valid
    end
  end

  describe "init" do
    it "should not add and commit hgignore if prompted" do
      @repo = mock
      Mercurial::Repository.should_receive(:init).with(".").and_return(@repo)
      @repository.init
    end
  end

  describe "method_missing" do
    it "should deletegate to grit if the method exists" do
      @grit.should_receive(:respond_to?).with(:valid_method).and_return(true)
      @grit.should_receive(:valid_method)
      @repository.valid_method
    end

    it "should not deletegate to grit if the method does not exist" do
      @grit.should_receive(:respond_to?).with(:invalid_method).and_return(false)
      lambda { @repository.invalid_method }.should raise_error(NoMethodError)
    end
  end


end
