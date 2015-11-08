class Subcommand

  def self.rm_rf(dest)
    if Dir.exists?(dest)
      puts "rm -rf #{dest}"
      FileUtils.rm_rf(dest)
    end
  end

  def self.random_string(length)
    (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).sort_by {rand}[0,length].join
  end

  def self.iso_date(date=Date.today)
    date.strftime("%Y-%m-%d")
  end

  @@tmp_directory = File.join('/tmp/rd-tool', Subcommand.random_string(12))
  @@project_definitions_directory = File.join(@@tmp_directory, 'project-definitions')
  
end
