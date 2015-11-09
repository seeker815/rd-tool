class RestoreFromFile < Subcommand

  attr_reader :import_file, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @import_file = target
    @subcommand_action = "restoreFromFile"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Restore Rundeck projects from a previously generated backupToFile zip file, this action remove all existent project"

  end

  def run

    puts "Running #{subcommand_full} #{import_file}"
    MyZip.new.unzip(import_file, @@tmp_directory)
    Rundeck.new.projects_import(@@tmp_directory)

  end

end
