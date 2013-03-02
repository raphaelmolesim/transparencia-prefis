module Initializer
  def self.load_environment
    require 'mongoid'
    Mongoid.load!(full_path_for "mongoid.yml")
	  
	  %W(helpers models fetchers). # load folders in order
	    map { |dir| full_path_for "../lib/#{dir}" }.
	    each{ |dir| Dir::glob("#{dir}/**/*.rb").each { |f| puts f ; require f } }
  end
  
  private
  
  def self.full_path_for file_or_directory
    File.expand_path("../#{file_or_directory}", __FILE__)
  end
  
end