require 'socket'
require 'rest-client'
require 'json'


class Rundeck

  attr_reader :token, :instance, :url

  def initialize(instance=Socket.gethostname, token='GulhKBMPTLKXR7Aonb9ZSmviVSEuR5nJ')

    #TODO: Read token from file
    #TODO: Factory for REST Client
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

  def build_uri(path)
    "#{@url}#{path}?authtoken=#{@token}"
  end

  def projects
    response_json = JSON.parse(get("/api/14/projects"))
    projects = Array.new
    response_json.each { |project| projects << project['name'] }
    return projects
  end

  def project_to_file(project, zip_file)
    compressed_project = get("/api/14/project/#{project}/export")
    File.open(zip_file, 'w') { |file| file.write(compressed_project)}
  end

  def clean_project(directory)

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


