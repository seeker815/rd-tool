class ImportFromInstance

  attr_reader :target, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @target = target
    @subcommand_action = "importFromInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} rundeck.foo.bar"
    @description = "Import Rundeck projects from another Rundeck instance"

  end

end
