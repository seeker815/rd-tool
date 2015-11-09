require 'socket'
require 'rest-client'
require 'json'
require 'yaml'

class Rundeck

  attr_reader :token, :instance, :url

  def initialize(instance=Socket.gethostname, token=YAML.load_file(File.join(File.dirname(File.dirname(__FILE__)), 'token.yaml'))['token'])

    #TODO: Factory for REST Client
    #TODO: Read token from file
    @token = token
    @instance = instance
    @url = "http://#{instance}"

    raise "Rundeck #{instance} is not active or its API is not available!" unless rundeck_active?

  end

  def get(path)
    RestClient.get build_uri(path), :content_type => :json, :accept => :json
  end

  def rundeck_active?
    result = system_info['system']['executions']['active'].class
  end

  def system_info
    JSON.parse(get("/api/14/system/info"))
  end

  def build_uri(path, query_parameters=nil)

    token_parameter = { :authtoken => token }

    if query_parameters.nil?
      query_parameters = token_parameter
    else
      query_parameters = query_parameters.merge(token_parameter)
    end

    qps = []
    query_parameters.each { |param, value| qps << param.to_s + '=' + value }
    qps = qps.join('&')

    "#{@url}#{path}?#{qps}"
  end

  def projects
    response_json = JSON.parse(get("/api/14/projects"))
    projects = Array.new
    response_json.each { |project| projects << project['name'] }
    return projects
  end

  def projects_to_zip(directory)

    FileUtils::mkdir_p directory
    projects.each do |project|

      destination_file = File.join(directory, project + '.zip')
      puts "Export project #{project} to #{destination_file}"
      project_to_file(project, destination_file)
    end
  end

  def project_name_from_file(file_path)
    File.basename(file_path,'.zip')
  end

  def projects_to_zip_from_dir(projects_directory, projects_destination=File.dirname(projects_directory))

    Dir[File.join(projects_directory, '/*')].each do |d|
      if File.directory?(d)
        d = File.expand_path(d) 
        MyZip.new.zip(d, File.join(projects_destination, File.basename(d) + '.zip'))
      end
    end
 
  end

  def projects_unzip_to_dir(projects_directory, projects_destination, exclude_pattern=nil)

    Dir[File.join(projects_directory, '/*.zip')].each do |project_file|
      project_destination = File.join(projects_destination, project_name_from_file(project_file))
      puts "Decompressing #{project_file} to #{project_destination}"

      if exclude_pattern.nil?
        MyZip.new.unzip(project_file, project_destination)
      else
        MyZip.new.unzip(project_file, project_destination, exclude_pattern)
        clean_raw_project(project_destination) if File.exists?File.join(projects_destination,'.git')
      end

    end

  end

  alias_method :projects_unzip_to_repo, :projects_unzip_to_dir

  def project_to_file(project, zip_file)
    compressed_project = get("/api/14/project/#{project}/export")
    File.open(zip_file, 'w') { |file| file.write(compressed_project)}
  end

  def projects_import(directory)

    projects_delete_all

    Dir[File.join(directory,'*.zip')].each do |project_file|
      puts "Importing #{project_file}"
      project_create(project_name_from_file(project_file))
      project_import(project_file)
    end
  end

  def projects_delete_all
    projects.each do |project|
      project_delete(project)
    end
  end
  
  def project_delete(project_name)
    puts "Deleting #{project_name}"
    RestClient.delete build_uri("/api/14/project/#{project_name}")
  end

  def project_create(project_name)
    puts "Creating #{project_name}"
    response = RestClient.post build_uri("/api/14/projects"), { 'name' => project_name }.to_json, :content_type => :json, :accept => :json
  end

  def project_import(project_file)

    query_parameters = {
    
      :jobUuidOption => 'preserve',
      :importExecutions => 'true',
      :importConfig => 'true',
      :importACL => 'true'
    }

    project_name = project_name_from_file(project_file)
    uri = build_uri("/api/14/project/#{project_name}/import", query_parameters)

    response_json = JSON.parse(RestClient.put uri, File.read(project_file) , {:content_type => :zip, :accept => :json})
    if response_json['import_status'] == 'successful'
      puts "Project #{project_name} imported successfully"
    else
      raise "Import failed for project #{project_name}" 
    end

  end

  def clean_raw_project(directory)

    project_name = File.basename(directory)

    what_to_clean = [
      {:file => 'META-INF/MANIFEST.MF', :pattern_to_clean => '^Rundeck-Archive-Export-Date'},
      {:file => "rundeck-#{project_name}/files/etc/project.properties", :pattern_to_clean => '^#'}
    ] 
    
    what_to_clean.each do |i|
      file = File.join(directory, i[:file])
      pattern = i[:pattern_to_clean]

      old_file = File.readlines(file)
      File.open(file, 'w') do |new_file|
        old_file.each do |line|
          new_file.write(line) if not line =~ /#{pattern}/
        end
      end   
    end

  end

end


