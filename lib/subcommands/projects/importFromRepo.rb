class ImportFromRepo < Subcommand

  attr_reader :remote_repository, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @remote_repository = target
    @subcommand_action = "importFromRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} 'https://github.com/snebel29/foo-repo'"
    @description = "Import Rundeck projects from repository, requires a valid repository url as parameter"

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
