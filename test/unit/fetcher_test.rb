require 'test_helper'

class FetcherTest < ActiveSupport::TestCase
  
  setup do
    @fetcher = Fetcher.new('Die Hard')
  end
  
  should 'initialize with a keyword' do
    assert_equal 'Die Hard', @fetcher.keyword
  end
  
  should 'build a Google URL request with the keyword' do
    assert_equal "http://www.google.com/search?hl=en&q=?site:imdb.com+Die%20Hard&btnI=I%27m+Feeling+Lucky", @fetcher.google_query
  end
  
  should 'get the IMDB page from the Google URL' do
    VCR.use_cassette('Die Hard Profile') do
      assert_nothing_raised(OpenURI::HTTPError) {@fetcher.get_imdb_profile}
      assert_kind_of(Nokogiri::HTML::Document, @fetcher.imdb_document)
    end
  end
  
  should 'get the main movie image' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_equal 'http://ia.media-imdb.com/images/M/MV5BMTIxNTY3NjM0OV5BMl5BanBnXkFtZTcwNzg5MzY0MQ@@._V1._SY317_CR10,0,214,317_.jpg', @fetcher.movie_image
    end
  end
  
  should 'get the movie description' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_equal 'Directed by John McTiernan. With Bruce Willis, Alan Rickman, Bonnie Bedelia, Reginald VelJohnson. New York cop John McClane gives terrorists a dose of their own medicine as they hold hostages in an LA office building.', @fetcher.movie_description
    end
  end
  
  
  
end
