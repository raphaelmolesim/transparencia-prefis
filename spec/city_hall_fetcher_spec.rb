require './spec/spec_helper'

describe CityHallFetcher do
  
  it "should fetch all link from city hall portal search" do
    mock = double "EasyHTTP"
    mock.stub(:get).and_return(File.read "./spec/fixtures/city-hall-1.yaml")
    mock.should_receive(:post).and_return(File.read("./spec/fixtures/city-hall-2.yaml"))
    mock.should_receive(:post).and_return(File.read("./spec/fixtures/city-hall-3.yaml"))
    EasyHTTP.stub(:new).and_return(mock)
    fetcher = CityHallFetcher.new
    fetcher.fetch('haddad').search_results.size.should == 58
  end
  
  it "should update or insert all links from city hall portal search" do
    
    fetcher = CityHallFetcher.new
    fetcher.search_results = [{ title: "titulo 01", :source => :city_hall_website, link: "http://domain.com/link-to-news.html" }]
    fetcher.insert_or_update
    News.all.count.should == 1
    n = News.first
    puts "--> #{n.title} #{n.source} #{n.link}"
    n.title.should == "titulo 01"
    n.source.should == :city_hall_website
    n.link.should == "http://domain.com/link-to-news.html"
    
    fetcher.search_results = [{ title: "Novo titulo 01", :source => :city_hall_website, link: "http://domain.com/link-to-news.html" }]
    
    fetcher.insert_or_update
    News.all.count.should == 1
    n = News.first
    n.title.should == "Novo titulo 01"
    n.source.should == :city_hall_website
    n.link.should == "http://domain.com/link-to-news.html"
  end

end