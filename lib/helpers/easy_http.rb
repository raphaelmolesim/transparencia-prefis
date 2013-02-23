require 'open-uri'
require 'net/http'
require 'zlib'

class EasyHTTP
  WRONG_CONTENT_TYPE = "[ERROR] ==> This response is no GZip <=="
  
  
  def get(url, params, headers, &block)
    url += "?" + params.map{ |key, value| "#{key}=#{value}" }.join("&")
    @response, content = open(url, headers) do |response|
      content_type = response.content_encoding.first
      [response, extract_response(content_type, response)]
    end
    enconde_content content, @response.charset
  end
  
  def post(domain, port, path, params, headers)
    request = Net::HTTP.new(domain, 80)
    url_params = params.map{ |key, value| "#{key}=#{value}" }.join("&")
    @response, data = request.post(path, url_params, headers)
    content = extract_response(@response['Content-Encoding'], @response)
    charset = @response["content-type"].split(";").last.split('=').last
    enconde_content content, charset
  end
  
  def extract_response content_type, response
    raise ArgumentError, WRONG_CONTENT_TYPE if not content_type == "gzip"
    io = response.respond_to?(:read) ? response : StringIO.new(response.body.to_s)
    Zlib::GzipReader.new(io).read
  end
  
  def enconde_content content, charset
    content.encode("UTF-8", charset)
  end
  
end