difficulty 1
description "The README file has been added to your repositoy, now commit it."

setup do
  repo.init
  FileUtils.touch("README")
  # Sure enough there is a mercurial-ruby way to do this.
  repo.shell.run('hg add README')
end

solution do
  return false if repo.commits.all.empty?
  true
end

hint do
  puts "You must include a message when you commit."
end
