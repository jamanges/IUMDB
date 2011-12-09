require 'nokogiri'
require 'open-uri'

class Fetcher
  attr_accessor :keyword, :imdb_document
  
  def initialize(keyword)
    @keyword = keyword
  end
  
  def google_query
    "http://www.google.com/search?hl=en&q=?site:imdb.com+#{URI.escape(@keyword)}&btnI=I%27m+Feeling+Lucky"
  end
  
  def get_imdb_profile
    begin
      @imdb_document = Nokogiri::HTML(open(google_query))
    rescue OpenURI::HTTPError => e
      Rails.logger.warn "OpenURI::HTTPError: #{e} FOR #{BASE_TARGET_URI}"
    end
  end
  
  def movie_image
    @imdb_document.xpath("//td[@id='img_primary']/a/img").attr('src').text
  end
  
  def movie_description
    @imdb_document.xpath("//meta[@name='description']").attr('content').text
  end

end
