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
  
  def get_imdb_page
    begin
      @imdb_page = Nokogiri::HTML(open(google_query))
    rescue OpenURI::HTTPError => e
      Rails.logger.warn "OpenURI::HTTPError: #{e} FOR #{BASE_TARGET_URI}"
    end
  end
  
  def check_correct_page
    url = @imdb_page.xpath("//link[@rel='canonical']").attr('href').text
    if url.include? "episodes"
      url = url.gsub("episodes", "")
    end
    
    begin
      @imdb_document = Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError => e
      Rails.logger.warn "OpenURI::HTTPError: #{e} FOR #{BASE_TARGET_URI}"
    end
  
  end
  
  def movie_image
    @imdb_document.xpath("//td[@id='img_primary']/a/img").attr('src').text
  end
  
  def content_type
    type = @imdb_document.xpath("//meta[@property='og:type']").attr('content').text
    if type == "video.tv_show"
      "Television"
    elsif type == "video.movie"
      "Movie"
    end
  end
  
  def movie_description
    @imdb_document.xpath("//p[@itemprop='description']").text.strip
  end
  
  def movie_directors
    directors = []
    @imdb_document.xpath("//a[@itemprop='director']").children.each do |d|
      directors << d.text
    end
    directors.join(', ')
  end
  
  def movie_actors
    actors = []
    @imdb_document.xpath("//a[@itemprop='actors']").children.each do |a|
      actors << a.text
    end
    actors.join(', ')
  end
  
  def movie_genres
    genres = []
    @imdb_document.xpath("//div[@class='infobar']/a").children.each do |g|
      genres << g.text 
    end
    genres.join(', ')
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
  
  def normalized_title
    @keyword.downcase
    @keyword.split.each{|w| w.capitalize!}.join(' ')
  end
  
end
