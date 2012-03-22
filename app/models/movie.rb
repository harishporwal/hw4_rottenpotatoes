# sample model
class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError; end
  def self.unique_ratings
    #self.all(:group => :rating).uniq
    self.select("DISTINCT(RATING)")
  end
  def self.movies_with_the_same_director_as_this_movie(id)
    if Movie.find_by_id(id).director
      movies = Movie.find(:all, :conditions =>"director = '#{Movie.find_by_id(id).director}' and id != #{id}")
    end
  end
end
