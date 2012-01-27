class Movie < ActiveRecord::Base
  validates_presence_of :title
  
  def self.new_from_imdb(movie_title)
    fetcher = Fetcher.new(movie_title)
    
    fetcher.get_imdb_page
    fetcher.check_correct_page
    
    movie = Movie.new({
      :title => fetcher.movie_title,
      :release_year => fetcher.movie_release_year,
      :link_to_image => fetcher.movie_image,
      :description => fetcher.movie_description,
      :length => fetcher.movie_runtime,
      :genres => fetcher.movie_genres,
      :actors => fetcher.movie_actors,
      :directors => fetcher.movie_directors,
      :content_type => fetcher.content_type,
      :original_title => fetcher.normalized_title
    })
    movie.save
  end
end
