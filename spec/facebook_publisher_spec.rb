require './models/facebook_publisher'
describe FacebookPublisher do
  
  it "should publish to facebook" do
    FacebookPublisher.post("Sample Post", "http://www.prefeitura.sp.gov.br/portal/a_cidade/noticias/index.php?p=52635")
  end

end