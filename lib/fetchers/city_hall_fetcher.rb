# encoding: UTF-8
class CityHallFetcher

  def initialize
    @easy_http = EasyHTTP.new
    @domain = "capital.sp.gov.br"
    @base_url = "http://www.#{@domain}"
    @search_path = "/portalpmsp/do/busca"
    @url = "#{@base_url}#{@search_path}"
    @headers = {
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
      'Accept-Encoding' => 'gzip,deflate,sdch',
      'Accept-Language' => 'en-US,en;q=0.8',
      'Cache-Control' => 'max-age=0',
      'Connection' => 'keep-alive',
      'Cookie' => 'JSESSIONID=DD3CFAD07598B4E4FBA82A771D426E00',
      'Host' => 'www.capital.sp.gov.br',
      'Referer' => 'http://www.capital.sp.gov.br/portalpmsp/do/busca;jsessionid=62BD91FA2D3DCEF9AF760670F41D746F?op=buscaForm&buscaAvancada=false&buscaSimples=false&contadorServico=&contadorInstituicao=&contadorUnidade=&contadorNoticia=&orderBy=&filter=&unidadeForm=&servicoForm=&coInstituicao=&isHead=true&param=haddad&imageField2.x=0&imageField2.y=0',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17'
    }
  end

  def fetch search_string
    content = @easy_http.get(@url, first_request(search_string), @headers) 
    search_results = parse(content)
    puts "==> #{search_results.size}"
    (2..get_last_page(content)).each do |page_number|
      params = others_requests(search_string, page_number)
      content = @easy_http.post(@domain, 80, @search_path, params, @headers)
      search_results << parse(content)
      search_results.flatten!
      puts "==> #{search_results.size}"
    end
    search_results
  end
  
  private
    def parse html
      require 'nokogiri'
      doc = Nokogiri::HTML(html)
      doc.css("a.listlinks").map do |a| 
        News.new({ 
          title: a.content.gsub(/(\t|\r|\n)*/, ''),
          link: a['href'].gsub(/(\t|\r|\n)*/, ''),
          :source => :city_hall_website
        })
      end
    end

    def get_last_page html
      regex = /BuscaForm\.pg\.value=([0-9]+);document\.getElementById/
      html.scan(regex).max.first.to_i
    end

    def first_request search_string
      {
        :op => 'buscaForm', 
        :buscaSimples => true, 
        :param => search_string, 
        :coBusca => 3
      }
    end
  
    def others_requests search_string, page_number
      {
        op: 'buscaForm',
        buscaAvancada: false,
        buscaSimples: true,
        contadorServico: 0,
        contadorInstituicao: 0,
        contadorUnidade: 0,
        contadorNoticia: 58,
        contadorSaoPaulo: nil,
        orderBy: nil,
        filter: nil,
        unidadeForm: false,
        servicoForm: false,
        coInstituicao: nil,
        isHead: nil,
        unidadesPrestadoras: false,
        coSeqEstrutura: nil,
        coBusca: 3,
        param: search_string,
        pg: page_number
      }
    end
end