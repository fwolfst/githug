difficulty 1
description "There is a file in your folder called README, you should add it to your repository.
Note: You start each level with a new repo. Don't look for files from the previous one"

setup do
  repo.init
  FileUtils.touch('README')
end

solution do
  # In mercurial-ruby it seems difficult to find not committed adds.
  # Note thtat string comparison assumes that hg stat is not i18ned.
  # TODO If repo.shell does not set e.g. LC_ALL (or windows equ.), do it.
  return false unless repo.shell.run('hg stat').strip == 'A README'
  #return false if repo.status.files["README"].untracked
  true
end

hint do
  puts 'You can type `hg` in your shell to get a list of available hg commands'
end
