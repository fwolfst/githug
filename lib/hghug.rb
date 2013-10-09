require 'grit'

require "hghug/extensions/grit/ruby1.9"


require "hghug/version"

require 'hghug/ui'
require 'hghug/game'
require 'hghug/profile'
require 'hghug/level'
require 'hghug/repository'

Githug::UI.in_stream = STDIN
Githug::UI.out_stream = STDOUT
