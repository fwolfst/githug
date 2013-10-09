difficulty 2

description "Add a remote repository called `origin` with the url `https://github.com/hghug/hghug`"

setup do
  repo.init
end

solution do
  result = `git remote -v`
  result.include?("https://github.com/hghug/hghug")
end

hint do
  puts "You can run `git remote --help` for the man pages"
end
