require 'open3'

class Git

  #TODO: Read email and username from config file
  #TODO: Check git version as a dependency
  attr_reader :local_repository, :remote_bare_repository

  def initialize(remote_bare_repository=nil, local_repository='/tmp/rd-tool/project-definitions')

    @local_repository = local_repository
    @remote_bare_repository = remote_bare_repository

    raise "git binary was not found in the system" unless git_binary?
    puts "Local repository and default working directory will be #{local_repository}"

  end

  def git_binary?
    result, output = run("git --version", File.expand_path(Dir.pwd))
    return result
  end

  def run(command, working_directory=local_repository)

    puts "Running #{command}"
    output = []
    Open3.popen2e(command, :chdir=>"#{working_directory }") do |stdin, stdout_err, wait_thr|
      while line = stdout_err.gets
        output << line
      end
      output.each {|line| puts line}
      raise "Error while running #{command}" if not wait_thr.value.success?
      return wait_thr.value.success?, output
    end
  end

  def git_init(username=YAML.load_file(File.join(File.dirname(File.dirname(__FILE__)), 'config.yaml'))['username'], email=YAML.load_file(File.join(File.dirname(File.dirname(__FILE__)), 'config.yaml'))['email'])
    unless is_repo?(local_repository)
      FileUtils::mkdir_p local_repository
      result, output = run("git init #{local_repository}")

      if result && !remote_bare_repository.nil?
        git_remote_add
        git_config_username(username)
        git_config_email(email)
      end

        return result
    end
        true
  end

  alias_method :init, :git_init

  def is_repo?(directory)
    Dir.exists?(File.join(directory, '.git'))
  end

  def git_clone
    FileUtils::mkdir_p local_repository if not Dir.exists?(local_repository)
    result, output = run("git clone #{remote_bare_repository} #{local_repository}")
    return result
  end

  alias_method :clone, :git_clone

  def git_something_to_commit?
    result, output = run("git status -z --porcelain")
    if output.empty? then return false else return true end
  end

  alias_method :something_to_commit?, :git_something_to_commit?

  def git_config_username(username)
    result, output = run("git config user.name '#{username}'")
    return result
  end

  alias_method :config_username, :git_config_username

  def git_config_email(email)
    result, output = run("git config user.email '#{email}'")
    return result
  end

  alias_method :config_email, :git_config_email

  def git_remote_add
    result, output = run("git remote add origin #{remote_bare_repository}")
    return result
  end

  alias_method :remote_add, :git_remote_add

  def git_remote_rm_origin
    result, output = run("git remote rm origin")
    return result
  end

  alias_method :remote_rm_origin, :git_remote_rm_origin

  def git_add
    result, output = run("git add --all")
    return result
  end

  alias_method :add, :git_add

  def git_commit(comment="Regular basis commit by Rundeck server")
    result, output = run("git commit -m \"#{comment} at #{Time.now.utc}\"")
    return result
  end

  alias_method :commit, :git_commit

  def git_push
    result, output = run("git push origin master --force")
    return result
  end

  alias_method :push, :git_push

  def git_hard_pull
    result, output = run("git fetch --all")
    git_reset_hard if result
    return result
  end

  alias_method :hard_pull, :git_hard_pull

  def git_reset_hard
    result, output = run("git reset --hard origin/master")
    return result
  end

  alias_method :reset_hard, :git_reset_hard

end
