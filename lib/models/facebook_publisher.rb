require 'koala'

class FacebookPublisher
  
  def self.post message, link
    #token = 'AAACRVsghO1QBAOGRKS1KMd98T2f90XTjDidCZBGFU4Jb7xzft6ZB4seEr62lOiKp7ZAMzVe4G23UFEidzKVAzXmHmN9945XOsd8QGZBBZAxZBst1SzWslv'  
    token = "159801910836052|QzTkCLtpK5V8re6__5p087lRT9M"  
    @graph = Koala::Facebook::API.new(token)
    puts @graph.put_wall_post(
      :message => "I am writing on my wall!",
      :link => link)
  end
  
end


