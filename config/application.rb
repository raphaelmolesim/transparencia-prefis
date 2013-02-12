require 'mongoid'

class MonitoramentoPrefeitura
	def self.call(env)
	  new(env).response.finish
  end
  
  def initialize(env)
	  Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__))
	  
	  %W(models).map { |dir| File.expand_path("../../#{dir}", __FILE__) }.
	    each{ |dir| Dir::glob("#{dir}/**/*.rb").each { |f| require f } }
	  
    @request = Rack::Request.new(env)
  end
  
  def response
    case @request.path
      when "/" then 
        Rack::Response.new(File.read File.expand_path("../../views/index.html", __FILE__))
      when "/news" then 
        Rack::Response.new(News.all, 200, {
          'Content-Type' => 'application/json'
        })
      when "/import" then 
        import_data
        Rack::Response.new("Done!!!", 404)
      else 
        Rack::Response.new("Not found", 404)
    end
  end
  
  def import_data
    %W(fetchers).map { |dir| File.expand_path("../../#{dir}", __FILE__) }.
	    each do |dir| 
	      Dir::glob("#{dir}/**/*.rb").each do |f| 
	        begin 
	          require f
          rescue LoadError
            next
          end
        end
        Dir::glob("#{dir}/**/*.rb").each{ |f| require f }
      end
	  
	  CityHallFetcher.new.fetch('haddad').each { |news| news.save }
  end
end