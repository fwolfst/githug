module Hghug
  class Repository

    attr_accessor :grit

    def initialize(location = ".")
      Mercurial.configure do |conf|
          conf.hg_binary_path = '/usr/bin/hg'
      end
      @grit = Mercurial::Repository.open(location)
      #rescue Mercurial::Error
      #@grit = nil
    end

    def reset
      dont_delete = ["..", ".", ".profile.yml"]
      if File.basename(Dir.pwd) == "hg_hug"
        Dir.entries(Dir.pwd).each do |file|
          FileUtils.rm_rf(file) unless dont_delete.include?(file)
        end
      end
      create_hgignore
    end

    def create_hgignore
      Dir.chdir("hg_hug") if File.exists?("./hg_hug")
      File.open(".hgignore", "w") do |file|
        file.puts(".profile.yml")
        file.puts(".hgignore")
      end
    end

    def valid?
      !@grit.nil? and @grit.verify and File.exists?(@grit.dothg_path)
    end

    # Initialize a hg repo. If the repo already exists, do nothing.
    def init(location = ".")
      @grit = Mercurial::Repository.create(location)
    end

    def method_missing(method, *args, &block)
      if @grit && @grit.respond_to?(method)
        return @grit.send(method, *args, &block)
      end
      super
    end


  end
end
