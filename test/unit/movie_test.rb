require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  should validate_presence_of :title
  
  
  should 'build a movie from IMDB' do
    VCR.use_cassette('Die Hard Profile') do
      mock_fetcher
      movie = Movie.new_from_imdb('Die Hard')
      assert_not_nil movie
      assert_equal 'Die Hard', movie.title
      assert_equal 131, movie.length
    end
  end
  
  
  private
  
  def mock_fetcher
    Fetcher.any_instance.stubs(:movie_image).returns('http://ia.media-imdb.com/images/M/MV5BMTIxNTY3NjM0OV5BMl5BanBnXkFtZTcwNzg5MzY0MQ@@._V1._SY317_CR10,0,214,317_.jpg')
    Fetcher.any_instance.stubs(:movie_description).returns('Directed by John McTiernan. With Bruce Willis, Alan Rickman, Bonnie Bedelia, Reginald VelJohnson. New York cop John McClane gives terrorists a dose of their own medicine as they hold hostages in an LA office building.')
    Fetcher.any_instance.stubs(:movie_directors).returns(['John McTiernan'])
    Fetcher.any_instance.stubs(:movie_actors).returns(['Bruce Willis', 'Alan Rickman', 'Bonnie Bedelia'])
    Fetcher.any_instance.stubs(:movie_genres).returns(['Action', 'Thriller'])
    Fetcher.any_instance.stubs(:movie_release_year).returns('1998')
    Fetcher.any_instance.stubs(:movie_title).returns('Die Hard')
    Fetcher.any_instance.stubs(:movie_runtime).returns(131)
  end
  
end
