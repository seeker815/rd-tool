class ExportToInstance

  attr_reader :target, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @target = target
    @subcommand_action = "exportToInstance"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} rundeck.foo.bar"
    @description = "Export Rundeck projects to another Rundeck instance"

  end

end
