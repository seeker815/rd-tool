require 'zip'

class MyZip

  def unzip(file, destination, exclude_pattern)
    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |z|
        unless z.name =~ /#{exclude_pattern}/
          destination_path = File.join(destination, z.name)
          basedir = File.dirname(destination_path)
          FileUtils.mkdir_p(basedir) unless Dir.exists?(basedir)
          zip_file.extract(z, destination_path)
        end
      end
    end
  end

end
