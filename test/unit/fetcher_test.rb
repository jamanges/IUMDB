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
  
  should 'get the movie directors' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_kind_of(Nokogiri::XML::NodeSet, @fetcher.movie_directors)
      assert_equal 'John McTiernan', @fetcher.movie_directors.first.text
    end
  end
  
  should 'get the movie actors' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_kind_of(Nokogiri::XML::NodeSet, @fetcher.movie_actors)
      assert_equal 3, @fetcher.movie_actors.size
      assert_equal 'Bruce Willis', @fetcher.movie_actors.first.text
    end
  end
  
  should 'get the genres' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_kind_of(Nokogiri::XML::NodeSet, @fetcher.movie_genres)
      assert_equal 2, @fetcher.movie_genres.size
      assert_equal 'Action', @fetcher.movie_genres.first.text
    end
  end
  
  should 'get the release year' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_equal '1988', @fetcher.movie_release_year
    end
  end
  
  should 'get the movie title' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_equal 'Die Hard', @fetcher.movie_title
    end
  end
  
  should 'get the movie runtime in minutes' do
    VCR.use_cassette('Die Hard Profile') do
      @fetcher.get_imdb_profile
      assert_equal 131, @fetcher.movie_runtime
    end
  end
  
end
