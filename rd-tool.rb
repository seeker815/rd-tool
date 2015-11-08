#!/usr/bin/env ruby

#TODO: Use Hash as arguments in all methods to increase readability
require_relative './lib/rdTool'

if __FILE__ == $0 then rdtool = Rdtool.new(ARGV,__FILE__).run end

