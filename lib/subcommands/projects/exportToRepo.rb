class ExportToRepo < Subcommand

  attr_reader :remote_repository, :subcommand_action, :subcommand_full, :description, :cmd_example

  def initialize(target=nil)

    @remote_repository = target
    @subcommand_action = "exportToRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} 'git@git.foo.com:devops-rundeck/foo-repo.git'"
    @description = "Export Rundeck projects to repository, requires a valid non empty repository url as parameter, an empty README.md file would be enough"

  end

  def run

    puts "Running #{subcommand_full} #{remote_repository}"

    git = Git.new(remote_repository, @@project_definitions_directory)
    rundeck = Rundeck.new

    git.init

    #The hard_pull then remove everything except .git is necessary to catch deletes, .git folder is not removed using Dir
    git.hard_pull 
    Dir[File.join(@@project_definitions_directory, '/*')].each { |file| Subcommand.rm_rf(file) }

    rundeck.projects_to_zip(@@tmp_directory)
    rundeck.projects_unzip_to_repo(@@tmp_directory, @@project_definitions_directory, "(\/reports\/|\/executions\/)")
    
    git.add

    if git.something_to_commit?
      git.commit
      git.push
    else
      puts "Nothing to commit"
    end

    puts "Finish"

  end

end
