require 'fileutils'
require 'ftools'

class FriendlyLogHandler
  
  attr_accessor :remote, :local, :cleanup
  
  def initialize(remote, local, cleanup=true)
    @remote = remote
    @local = local
    @cleanup = cleanup
  end

  def cleanup?
    @cleanup
  end
  
  def cleanup=(cleanup)
    @cleanup = cleanup
  end

  def ignore_file?(file)
    file == "." or file == ".." or file == '.DS_Store'
  end

  def import
    files = Dir.entries(@remote)

    files.each do |folder|
      next if ignore_file?(folder)

      Dir.entries(@remote+'/'+folder).each do |file|
        next if ignore_file?(file)
        File.makedirs("#{@local}/#{folder}") unless File.exist?("#{@local}/#{folder}")
        File.move("#{@remote}/#{folder}/#{file}","#{@local}/#{folder}")
      end
      Dir.delete("#{@remote}/#{folder}") if @cleanup
    end    
  end

end