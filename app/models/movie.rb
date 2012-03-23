# sample model
class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError; end
  def self.unique_ratings
    #self.all(:group => :rating).uniq
    self.select("DISTINCT(RATING)")
  end
  def self.similar_movies(id)
    if id
      movie = Movie.find_by_id(id)
      if movie && movie.director && movie.director != ''
        movies = Movie.find(:all, :conditions =>"director = '#{movie.director}' and id != #{id}")
      end
    end
  end
end
