class Subcommand

  @@tmp_directory = '/tmp/rd-tool'
  @@project_definitions_directory = File.join(@@tmp_directory, 'project-definitions')

  def rm_rf(dest)
    if Dir.exists?(dest)
      puts "rm -rf #{dest}"
      FileUtils.rm_rf(dest)
    end
  end

end
