class ExportToRepo < Subcommand

  attr_reader :remote_repository, :subcommand_action, :subcommand_full, :description, :cmd_example
  def initialize(target=nil)

    @remote_repository = target
    @subcommand_action = "exportToRepo"
    @subcommand_full = "projects #{subcommand_action}"
    @cmd_example = "#{subcommand_full} 'https://github.com/snebel29/foo-repo'"
    @description = "Export Rundeck projects to repository, requires a valid non empty repository url as parameter, an empty README.md file would be enough"

  end

  def run
    puts "Running #{subcommand_full} #{remote_repository}"

    git = Git.new(remote_repository, @@project_definitions_directory)
    rundeck = Rundeck.new

    git.init
    git.pull

    rundeck.projects.each do |project|

      project_file = File.join(@@tmp_directory, Date.today.strftime("%Y-%m-%d") + '_' + project + '.zip')

      puts "Exporting #{project} to #{project_file}"
      rundeck.project_to_file(project, project_file)

      puts "Decompressing #{project}"
      destination_directory = File.join(@@project_definitions_directory, project)
      rm_rf(destination_directory)

      MyZip.new.unzip(project_file, destination_directory, "(\/reports\/|\/executions\/)")
      rundeck.clean_project(destination_directory)

    end
    
    git.add

    if git.something_to_commit?
      git.commit
      git.push
    else
      puts "Nothing to commit"
    end

  end

end
