require 'rack/test'
ENV['RACK_ENV'] = 'test'

require File.expand_path('../../config/initializer' , __FILE__)
Initializer.load_environment

require 'database_cleaner'

RSpec.configure do |config|
  
  config.before(:each) do
    DatabaseCleaner.start
  end
    
  config.after(:each) do
    DatabaseCleaner.clean
  end
  
end