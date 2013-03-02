desc "This task is called by the Heroku scheduler add-on"
task :import_news do
  puts "Importing City Hall WebSite news ..."
  system "curl http://transparenciaprefis.herokuapp.com/import"
end