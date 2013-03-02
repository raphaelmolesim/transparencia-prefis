desc "This task is called by the Heroku scheduler add-on"
task :import_news => :environment do
  puts "Importing City Hall WebSite news ..."
  require 'open-uri'
  open("http://transparenciaprefis.herokuapp.com/import")
  puts "Done!!"
end