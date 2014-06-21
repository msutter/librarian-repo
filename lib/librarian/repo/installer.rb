require 'fileutils'
require 'rubygems/package'
require 'zlib'
require 'zipruby'
require 'open-uri'
require 'librarian/repo/util'
require 'librarian/repo/iterator'

# This is an extremely simple file that can consume
# a Puppet file with git references
#
# It does absolutely no dependency resolution by design.
#
module Librarian
  module Repo
    module Installer

      include Librarian::Repo::Util
      include Librarian::Repo::Iterator

      # installs repos using the each_module method from our
      # iterator mixin
      def install!
        each_module do |repo|

          print_verbose "\n##### processing module #{repo[:name]}..."

          module_dir = File.join(module_path, repo[:name])

          unless File.exists?(module_dir)
            case
            when repo[:git]
              install_git module_path, repo[:name], repo[:git], repo[:ref]
            when repo[:tarball]
              install_tarball module_path, repo[:name], repo[:tarball]
            else
              abort('only the :git and :tarball provider are currently supported')
            end
          else
            print_verbose "\nModule #{repo[:name]} already installed in #{module_path}"
          end
        end
      end

      private

      # installs sources that are git repos
      def install_git(module_path, module_name, repo, ref = nil)
        module_dir = File.join(module_path, module_name)

        Dir.chdir(module_path) do
          print_verbose "cloning #{repo}"
          system_cmd("git clone #{repo} #{module_name}")
          Dir.chdir(module_dir) do
            system_cmd('git branch -r')
            system_cmd("git checkout #{ref}") if ref
          end
        end
      end

      def install_tarball(module_path, module_name, remote_tarball)
        Dir.mktmpdir do |tmp|
          temp_file = File.join(tmp,remote_tarball.split('/').last)
          File.open(temp_file, "w+b") do |saved_file|
            print_verbose "Downloading #{remote_tarball}..."
            open(remote_tarball, 'rb') do |read_file|
              saved_file.write(read_file.read)
            end
            saved_file.rewind
            target_directory = File.join(module_path, module_name)
            print_verbose "Extracting #{remote_tarball} to #{target_directory}..."
            case File.extname saved_file
            when '.gz'
            then
              unzipped_target = ungzip(saved_file)
              tarfile_full_name = untar(unzipped_target, module_path)
              FileUtils.mv File.join(module_path, tarfile_full_name), target_directory
            when '.zip'
            then
              tarfile_full_name = unzip(saved_file.read, target_directory)
            else
              print_verbose "\nTarball archive format not supported"
            end
          end
        end
      end

      # un-gzips the given IO, returning the
      # decompressed version as a StringIO
      def ungzip(tarfile)
        z = Zlib::GzipReader.new(tarfile)
        unzipped = StringIO.new(z.read)
        z.close
        unzipped
      end

      # untars the given IO into the specified
      # directory
      def untar(io, destination)
        tarfile_full_name = nil
        Gem::Package::TarReader.new io do |tar|
          tar.each do |tarfile|
            tarfile_full_name ||= tarfile.full_name
            destination_file = File.join destination, tarfile.full_name

            if tarfile.directory?
              FileUtils.mkdir_p destination_file
            else
              destination_directory = File.dirname(destination_file)
              FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
              File.open destination_file, "wb" do |f|
                f.write tarfile.read
              end
            end
          end
        end
        tarfile_full_name
      end

      # unzips the given IO into the specified
      # directory
      def unzip(io, destination)
        Zip::Archive.open_buffer(io) do |archive|
          archive.each do |zipfile|
            destination_file = File.join destination, zipfile.name
            if zipfile.directory?
              FileUtils.mkdir_p destination_file
            else
              destination_directory = File.dirname(destination_file)
              FileUtils.mkdir_p destination_directory unless File.directory?(destination_directory)
              File.open destination_file, "wb" do |f|
                f.write zipfile.read
              end
            end

          end
        end
      end


      def write()
      end

    end
  end
end
