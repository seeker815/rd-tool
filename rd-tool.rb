#!/usr/bin/env ruby

require_relative './lib/rdTool'

if __FILE__ == $0 then rdtool = Rdtool.new(ARGV,__FILE__).run end

