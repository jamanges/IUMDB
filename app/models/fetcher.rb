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
  
  def movie_directors
    directors = @imdb_document.xpath("//a[@itemprop='director']")
  end
  
  def movie_actors
    actors = @imdb_document.xpath("//a[@itemprop='actors']")
  end
  
  def movie_genres
    @imdb_document.xpath("//div[@class='infobar']/a")
  end
  
  def movie_release_year
    @imdb_document.xpath("//h1[@class='header']/span/a").text
  end

  def movie_title
    @imdb_document.xpath("//h1[@class='header']").first.children.first.text.strip
  end
  
  def movie_runtime
    @imdb_document.xpath("//div[@class='txt-block']/time[@itemprop='duration']").text.to_i
    
  end
end
