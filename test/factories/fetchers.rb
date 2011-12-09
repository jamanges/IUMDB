# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :fetcher do
    movie_image 'http://ia.media-imdb.com/images/M/MV5BMTIxNTY3NjM0OV5BMl5BanBnXkFtZTcwNzg5MzY0MQ@@._V1._SY317_CR10,0,214,317_.jpg'
    movie_description 'Directed by John McTiernan. With Bruce Willis, Alan Rickman, Bonnie Bedelia, Reginald VelJohnson. New York cop John McClane gives terrorists a dose of their own medicine as they hold hostages in an LA office building.'
    movie_directors ['John McTiernan']
    movie_actors ['Bruce Willis', 'Alan Rickman', 'Bonnie Bedelia']
    movie_genres ['Action', 'Thriller']
    movie_release_year '1998'
    movie_title 'Die Hard'
    movie_runtime 131
  end
end
