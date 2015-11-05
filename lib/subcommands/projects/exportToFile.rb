class ExportToFile

  attr_reader :target, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @target = target
    @subcommand_action = "exportToFile"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Export Rundeck projects to file, requires a valid filename"

  end

end

