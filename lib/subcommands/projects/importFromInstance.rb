class ImportFromInstance < Subcommand

  attr_reader :rundeck_instance, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @rundeck_instance = target
    @subcommand_action = "importFromInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} rundeck.foo.bar"
    @description = "Import Rundeck projects from another Rundeck instance"

  end

  def run

    puts "Running #{subcommand_full} #{rundeck_instance}"

    rundeck = Rundeck.new(rundeck_instance)
    rundeck.projects_to_zip(@@tmp_directory)

    rundeck = Rundeck.new
    rundeck.projects_import(@@tmp_directory)

  end


end
