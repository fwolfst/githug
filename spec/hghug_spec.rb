require 'spec_helper'

RSpec::Matchers.define :be_solved do
  match do |actual|
    !actual.match("Congratulations, you have solved the level").nil?
  end
end

def skip_level
  Hghug::Profile.load.level_bump
  `hghug reset`
end


describe "The Game" do

  before(:all) do
    @dir = Dir.pwd
    `rake build`
    `gem install pkg/hghug-#{Hghug::VERSION}.gem`
    FileUtils.rm_rf("/tmp/hg_hug")
    Dir.chdir("/tmp")
    `echo "y" | hghug`
    Dir.chdir("/tmp/hg_hug")
  end

  after(:all) do
    Dir.chdir(@dir)
  end

  it "should complete the init level" do
    `hg init`
    `hghug`.should be_solved
  end

  it "should complete the add level" do
    `hg add README`
    `hghug`.should be_solved
  end

  it "should complete the commit level" do
    `hg commit -m "test message"`
    `hghug`.should be_solved
  end


  it "should complete the config level" do
    skip_level #The CI server does not have git config set
    #full_name = `git config --get user.name`.chomp
    #email = `git config --get user.email`.chomp
    #f = IO::popen('hghug', 'w')
    #f.puts(full_name)
    #f.puts(email)
    #f.close
  end

  it "should complete the clone level" do
    `git clone https://github.com/Gazler/cloneme`
    `hghug`.should be_solved
  end

  it "should complete the clone_to_folder level" do
    `git clone https://github.com/Gazler/cloneme my_cloned_repo`
    `hghug`.should be_solved
  end

  it "should complete the ignore level" do
    `echo "*.swp" >> .hgignore`
    `hghug`.should be_solved
  end

  it "should complete the status level" do
    `git ls-files --other --exclude-standard | hghug`.should be_solved
  end

  it "should complete the rm level" do
    file_name = `git status | grep deleted | cut -d " " -f 5`
    `git rm #{file_name}`
    `hghug`.should be_solved
  end

  it "should complete the rm cached level" do
    file_name = `git status | grep "new file" | cut -d " " -f 5`
    `git rm --cached #{file_name}`
    `hghug`.should be_solved
  end

  it "should complete the stash level" do
    `git stash save`
    `hghug`.should be_solved
  end

  it "should complete the rename level" do
    `git mv oldfile.txt newfile.txt`
    `hghug`.should be_solved
  end

  it "should complete the log level" do
    `git log --pretty=short | grep commit | cut -c 8-14 | hghug`.should be_solved
  end

  it "should complete the tag level" do
    `git tag new_tag`
    `hghug`.should be_solved
  end

  it "should complete the commit_amend level" do
    `git add forgotten_file.rb`
    `git commit --amend -C HEAD`
    `hghug`.should be_solved
  end

  it "should complete the reset level" do
    `git reset HEAD to_commit_second.rb`
    `hghug`.should be_solved
  end

  it "should complete the reset_soft level" do
    `git reset --soft HEAD^`
    `hghug`.should be_solved
  end

  it "should complete the checkout_file level" do
    `git checkout -- config.rb`
    `hghug`.should be_solved
  end

  it "should complete the remove level" do
    `git remote | hghug`.should be_solved
  end

  it "should complete the remote_url level" do
    `git remote -v | tail -2 | head -1 | cut -c 17-52 | hghug`.should be_solved
  end

  it "should complete the pull level" do
    `git pull origin master`
    `hghug`.should be_solved
  end

  it "should complete the remote_add level" do
    `git remote add origin https://github.com/hghug/hghug`
    `hghug`.should be_solved
  end

  it "should complete the push level" do
    `git rebase origin/master`
    `git push origin`
    `hghug`.should be_solved
  end

  it "should complete the diff level" do
    `echo "26" | hghug`.should be_solved
  end

  it "should complete the blame level" do
    `echo "spider man" | hghug`.should be_solved
  end

  it "should complete the branch level" do
    `git branch test_code`
    `hghug`.should be_solved
  end

  it "should complete the checkout level" do
    `git checkout -b my_branch`
    `hghug`.should be_solved
  end

  it "should complete the checkout_tag level" do
    `git checkout v1.2`
    `hghug`.should be_solved
  end

  it "should complete the branch_at level" do
    commit = `git log HEAD~1 --pretty=short | head -1 | cut -d " " -f 2`
    `git branch test_branch #{commit}`
    `hghug`.should be_solved
  end

  it "should commit the merge level" do
    `git merge feature`
    `hghug`.should be_solved
  end

  it "should complete the cherry-pick level" do
    commit = `git log new-feature --oneline  -n 3 | tail -1 | cut -d " " -f 1`
    `git cherry-pick #{commit}`
    `hghug`.should be_solved
  end

  it "should complete the rename_commit level" do
    skip_level
  end

  it "should complete the squash level" do
    skip_level
  end

  it "should complete the merge squash level" do
    `git merge --squash long-feature-branch`
    `git commit -m "Merged Long Feature Branch"`
    `hghug`.should be_solved
  end

  it "should complete the reorder level" do
    skip_level
  end

  it "should complete the bisect level" do
    `echo "18ed2ac" | hghug`.should be_solved
  end

  it "should complete the stage_lines level" do
    skip_level
  end

  it "should complete the find_old_branch level" do
    `git checkout solve_world_hunger`
    `hghug`.should be_solved
  end

  it "should complete the revert level" do
    sleep 1
    `git revert HEAD~1 --no-edit`
    `hghug`.should be_solved
  end

  it "should complete the restore level" do
    `git reflog | grep "Restore this commit" | awk '{print $1}' | xargs git checkout`
    `hghug`.should be_solved
  end

  it "should complete the conflict level" do
    skip_level
  end

  it "should complete the contribute level" do
    skip_level
  end

end
