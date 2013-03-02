require File.expand_path("../initializer", __FILE__)
Initializer.load_environment

class MonitoramentoPrefeitura
  
	def self.call(env)
	  new(env).response.finish
  end
  
  def initialize(env)
    @request = Rack::Request.new(env)
  end
  
  def response
    case @request.path
      when "/" then 
        Rack::Response.new(File.read File.expand_path("../../views/index.html", __FILE__))
      when "/news" then 
        Rack::Response.new(News.all.take(100).to_json, 200, {
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
    CityHallFetcher.new.fetch('haddad').insert_or_update
  end
end