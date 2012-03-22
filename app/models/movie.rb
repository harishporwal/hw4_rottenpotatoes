# sample model
class Movie < ActiveRecord::Base

  class Movie::InvalidKeyError < StandardError; end
  def self.unique_ratings
    #self.all(:group => :rating).uniq
    self.select("DISTINCT(RATING)")
  end
  def self.api_key
    'dc3609d3e8e944d788e6a7c06bff6301'
  end
  def self.find_in_tmdb(string)
    Tmdb.api_key = self.api_key
    begin
      TmdbMovie.find(:title => string)
    rescue ArgumentError => tmdbError
      raise Movie::InvalidKeyError, tmdbError.message
    rescue RuntimeError => tmdbError
      if tmdbError.message =~ /status code '404'/
        raise Movie::InvalidKeyError, tmdbError.mesage
      else
        raise RuntimeError, tmdbError.message
      end
    end
  end
end
