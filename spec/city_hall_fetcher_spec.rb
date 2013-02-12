require './city_hall_fetcher'

describe CityHallFetcher do

  it "should fetch all link from city hall portal search" do
    mock = double "EasyHTTP"
    mock.stub(:get).and_return(File.read "./spec/fixtures/city-hall-1.yaml")
    mock.should_receive(:post).and_return(File.read("./spec/fixtures/city-hall-2.yaml"))
    mock.should_receive(:post).and_return(File.read("./spec/fixtures/city-hall-3.yaml"))
    EasyHTTP.stub(:new).and_return(mock)
    fetcher = CityHallFetcher.new
    fetcher.fetch('haddad').size.should == 58
  end

end