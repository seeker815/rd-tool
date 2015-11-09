class RestoreFromRepo < Subcommand

  attr_reader :remote_repository, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @remote_repository = target
    @subcommand_action = "restoreFromRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} 'https://github.com/snebel29/foo-repo'"
    @description = "Restore Rundeck projects from repository, this action remove all existent projects on the local instance"

  end

  def run

    puts "Running #{subcommand_full} #{remote_repository}"
  
    git = Git.new(remote_repository, @@project_definitions_directory)
    git.clone

    rundeck = Rundeck.new
    rundeck.projects_to_zip_from_dir(@@project_definitions_directory)
    rundeck.projects_import(@@tmp_directory)

  end

end
