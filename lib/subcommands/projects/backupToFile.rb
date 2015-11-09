class BackupToFile < Subcommand

  attr_reader :export_file, :subcommand_action, :subcommand_full, :description, :cmd_example, :tmp_directory

  def initialize(target=nil)

    @export_file = target
    @subcommand_action = "backupToFile"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Backup Rundeck projects to a zip file"

  end

  def run

    puts "Running #{subcommand_full} #{export_file}"
    rundeck = Rundeck.new

    rundeck.projects_to_zip(@@tmp_directory)
    MyZip.new.zip(@@tmp_directory, export_file)
    puts "Finish #{export_file}"

  end

end

