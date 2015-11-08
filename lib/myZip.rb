require 'zip'

class MyZip

  def clean_path(path, path_to_clean)
    path = path.dup
    path.gsub!("#{path_to_clean}", '')
    path[0] = ''
    return path
  end

  def unzip(file, destination, exclude_pattern=nil)

    Zip::ZipFile.open(file) do |zip_file|
      zip_file.each do |z|
        if exclude_pattern.nil? or not z.name =~ /#{exclude_pattern}/
          destination_path = File.join(destination, z.name)
          basedir = File.dirname(destination_path)
          FileUtils.mkdir_p(basedir) unless Dir.exists?(basedir)
          zip_file.extract(z, destination_path)
        end
      end
    end

  end

  def zip(folder, zip_file)

    zip_file = File.expand_path(zip_file)

    if File.exists?(zip_file)
      puts "Deleting #{zip_file}"
      File.delete zip_file 
    end

    Zip::ZipFile.open(zip_file, Zip::ZipFile::CREATE) do |z|

      puts "Creating #{zip_file}"
      Dir[File.join(folder, '/**/*')].each do |f|
        f_clean = clean_path(f, folder)
        puts "Adding #{f_clean} from #{f}"
        z.add(f_clean, f)
      end
    end
  end

end
