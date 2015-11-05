class ImportFromRepo

  attr_reader :target, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @target = target
    @subcommand_action = "importFromRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} 'https://github.com/snebel29/foo-repo'"
    @description = "Import Rundeck projects from repository, requires a valid repository url as parameter"

  end

end
