class Movie < ActiveRecord::Base
  validates_presence_of :title
  
  def self.new_from_imdb(movie_title)
    fetcher = Fetcher.new(movie_title)
    fetcher.get_imdb_profile
    movie = Movie.new({
      :title => fetcher.movie_title,
      :release_year => fetcher.movie_release_year,
      :link_to_image => fetcher.movie_image,
      :description => fetcher.movie_description,
      :length => fetcher.movie_runtime
    })
  end
end
