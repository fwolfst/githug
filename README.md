# Hghug
H(u)g Your Game On [![Build Status](https://travis-ci.org/Gazler/hghug.png?branch=master)](https://travis-ci.org/Gazler/hghug)

## About
Githug was designed to give you a practical way of learning git and was conceived by Gary 'Gazler' Rennie.
Hghug is a bold clone of Githug, meant to learn mercurial/hg.  All credits should go to Gazler and his Githug, and all the contributors.
Gazler pointed out that especially the level-contributors should be praised, too.
During the adaptation to hg (mercurial), all occurences of 'Githug' and 'githug' were replaces by 'Hghug' and 'hghug'.
Hghug has a series of levels, each utilizing hg commands to ensure a correct answer.

## Installation
To install Hghug

    gem install hghug

After the gem is installed, you can run `hghug` where you will be prompted to create a directory.  Hghug should work on Linux, OS X and Windows.

## Commands

Hghug has 4 commands:

 * play - This is the default command and it will check your solution for the current level.
 * hint - Gives you a hint (if available) for the current level.
 * reset - Reset the current level.
 * test - Used to test levels in development, please see the Testing Levels section.

## Change Log

The change log is available on the wiki.  [Change log](https://github.com/Gazler/hghug/wiki/Change-Log)


## Contributing

If you want to suggest a level or make a level that has been suggested, check out [the wiki](https://github.com/Gazler/hghug/wiki).

 Get yourself on the [contributors list](https://github.com/Gazler/hghug/contributors) by doing the following:

 * Fork the repository
 * Make a level in the levels directory (covered below)
 * Add your level to the LEVELS array inside `lib/hghug/level.rb` in a position that makes sense (the "commit" level after the "add" and "init" levels for example)
 * Make sure your level works (covered below)
 * Submit a pull request

## Todo List

 * A better way of returning from the solution block.
 * A follow up to the level, more information on a specific command, etc.
 * Better way to configure mercurial-ruby.
 * More levels!

## Writing Levels

Hghug has a DSL for writing levels

An example level:

```ruby
difficulty 1
description "There is a file in your folder called README, you should add it to your staging area"

setup do
  repo.init
  FileUtils.touch("README")
end

solution do
  return false unless repo.status.files.keys.include?("README")
  return false if repo.status.files["README"].untracked
  true
end

hint do
  puts "You can type `hg` in your shell to get a list of available hg commands"
end
```

 `difficulty`, `description` and `solution` are required.

You can also include multiple hints like this:

```ruby
hints [
  "You can type `hg` in your shell to get a list of available hg commands",
  "Check the man for `hg add`"]
```

 **note** Because `solution` is a Proc, you cannot prematurely return out of it and as a result, must put an explicit return on the last line of the solution block.

```ruby
solution do
  solved = false
  solved = true if repo.valid?
  solved
end
```

 By default, `setup` will remove all files from the game folder.  You do not need to include a setup method if you don't want an initial hg repository (if you are testing `hg init` or only checking an answer.)

 You can call `repo.init` to initialize an empty repository.

 All methods called on `repo` are sent to the [grit gem](https://github.com/mojombo/grit) if the method does not exist, and you can use that for most hg related commands (`repo.add`, `repo.commit`, etc.)


Another method exists called `init_from_level` and it is used like so:

```ruby
setup do
  init_from_level
end
```

This will copy the contents of a repository specified in the levels folder for your level.  For example, if your level is called "merge" then it will copy the contents of the "merge" folder.  it is recommended that you do the following steps:

 * mkdir "yourlevel"
 * cd "yourlevel"
 * hg init
 * some hg stuff
 * **important** rename ".hg" to ".hghug" so it does not get treated as a submodule
 * cd "../"
 * hg add "yourlevel"

After doing this, your level should be able to copy the contents from that hg repository and use those for your level.  You can see the "blame" level for an example of this.

## Testing Levels

The easiest way to test a level is:

 * change into your hg_hug repository
 * Run `hghug reset PATH_TO_YOUR_LEVEL
 * Solve the level
 * Run `hghug test PATH_TO_YOUR_LEVEL

Please note that the `hghug test` command can be run as `hghug test --errors` to get an error stacktrace from your solve method.

It would be ideal if you add an integration test for your level.  These tests live in `spec/hghug_spec` and **must** be run in order.  If you add a level but do not add a test, please add a simple `skip_level` test case similar to the `contribute` level.
