# Dynamic require libraries under methods require_*
require 'date'
require 'fileutils'

class Rdtool

  @@separator_length = 50
  @@left_identation_length  = 2
  @@separation_char  = " "
  @@subcommands = nil

  attr_reader :args, :subcommand_dir, :parent_directory, :script_name

  def initialize(args, script_name)

    @args = args
    @subcommand_dir = 'subcommands'
    @script_name = script_name

    require_libs
    require_subcommands
    print_usage unless arguments_valid?(args)

  end

  def arguments_valid?(args)
    is_valid = false
    subcommands.each do |obj|
      if args_subcommand_full(args) == obj.subcommand_full
        is_valid = true
      end
    end
      return is_valid
  end

  def subcommands_files
    files = Dir.glob(File.expand_path(File.join(my_directory, subcommand_dir, "/**/*.rb")))
    return files
  end

  def libs_files
    files = Dir.glob(File.expand_path(File.join(my_directory, "/*.rb")))
    return files
  end

  def require_subcommands
    subcommands_files.each {|file| require file }
  end

  def require_libs
    libs_files.each {|file| require file }
  end

  def my_directory
    File.dirname(__FILE__)
  end

  def subcommands

    if @@subcommands.nil?
      sub = []
      subcommands_files.each do |sub_action| 
        sub_action = extract_subcommand_action_from_path(sub_action)
        obj = Object.const_get(sub_action).new
        sub.push(obj)
      end
        @@subcommands = sub
        return sub
     end
      return @@subcommands
  end

  def extract_subcommand_action_from_path(path)
      file_name = File.basename(path)
      file_name.slice!(".rb")
      file_name = upcase_first_letter(file_name)
      return file_name
  end
  
  def upcase_first_letter(str)
    str[0] = str[0].upcase
    return str
  end

  def left_ident(str)
    @@separation_char * @@left_identation_length + str
  end

  def available_subcommands
    desc = []
    subcommands.each do |obj|
      desc.push(left_ident("#{obj.subcommand_full}#{@@separation_char * (@@separator_length - obj.subcommand_full.length)}#{obj.description}"))
    end
      return desc
  end

  def examples
    exm = []
    subcommands.each do |obj|
      exm.push(left_ident("ruby #{script_name} #{obj.cmd_example}"))
    end
      return exm
  end

  def args_subcommand_full(args)
    args = args.dup
    args.pop
    args_subcommand_full = args.join(' ')
  end

  def target
    args.dup.last
  end

  def print_usage
    puts ""
    puts "Usage: #{script_name} SUBCOMMAND SUBCOMMAND TARGET"
    puts ""
    puts "Available subcommands:"
    puts ""
    puts available_subcommands
    puts ""
    puts "Examples:"
    puts ""
    puts examples
    puts ""
    exit(1)
  end

  def run()
    subcommand_action = args[1].dup
    action_obj = Object.const_get(upcase_first_letter(subcommand_action)).new(target)
    action_obj.run
  end

end
