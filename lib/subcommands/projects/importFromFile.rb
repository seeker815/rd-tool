class ImportFromFile

  attr_reader :target, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @target = target
    @subcommand_action = "importFromFile"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} foo.zip"
    @description = "Import Rundeck projects from a zip file"

  end

end
