require 'open3'

class Git

  attr_reader :local_repository, :remote_bare_repository

  def initialize(remote_bare_repository=nil, local_repository='/tmp/rd-tool/project-definitions')

    @local_repository = local_repository
    @remote_bare_repository = remote_bare_repository

    raise "git binary was not found in the system" unless git_binary?
    puts "Local repository and default working directory will be #{local_repository}"

  end

  def git_binary?
    result = run("git --version", File.expand_path(Dir.pwd))
    return result
  end

  def run(command, working_directory=local_repository)

    puts "Running #{command}"
    Open3.popen2e(command, :chdir=>"#{working_directory }") do |stdin, stdout_err, wait_thr|
      while line = stdout_err.gets
        puts line
      end
      raise "Error while running #{command}" if not wait_thr.value.success?
      return wait_thr.value.success?
    end
  end

  def git_init
    unless is_repo?(local_repository)
      FileUtils::mkdir_p local_repository
      result = run("git init #{local_repository}")

      if result && !remote_bare_repository.nil?
        git_remote_add
        git_config_username
        git_config_email
      end

        return result
    end
        true
  end

  alias_method :init, :git_init

  def is_repo?(directory)
    Dir.exists?(File.join(directory, '.git'))
  end

  def git_config_username
    run("git config user.name 'perundeck'")
  end

  def git_config_email
    run("git config user.email prodeng@ask.com")
  end

  alias_method :config_email, :git_config_email

  def git_remote_add
    run("git remote add origin #{remote_bare_repository}")
  end

  alias_method :remote_add, :git_remote_add

  def git_remote_rm_origin
    run("git remote rm origin")
  end

  alias_method :remote_rm_origin, :git_remote_rm_origin

  def git_add
    run("git add --all")
  end

  alias_method :add, :git_add

  def git_commit(comment="Regular basis commit by Rundeck server")
    run("git commit -m \"#{comment} at #{Time.now.utc}\"")
  end

  alias_method :commit, :git_commit

  def git_push
    run("git push origin master --force")
  end

  alias_method :push, :git_push

  def git_pull
    result = run("git fetch --all")
    git_reset_hard if result

    result
  end

  alias_method :pull, :git_pull

  def git_reset_hard
    run("git reset --hard origin/master")
  end

  alias_method :reset_hard, :git_reset_hard

end
