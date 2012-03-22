class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #if the filter settings & sorting is not present,check if it is stored in session and react
    if session.has_key?(:sid) && !params[:ratings] && !params["sort_order"]
      parameters = Hash.new()
      parameters[:ratings] = session[:ratings] unless !session[:ratings]
      parameters["sort_order"] = session[:sort_order] unless !session[:sort_order]
      redirect_to movies_path(parameters) unless parameters.empty?
    end

    #construct the find conditions and order for the query
    if params[:ratings]
      conditions = ["rating in (?)", params[:ratings].keys]
    end
    if params["sort_order"]
      sort_order = params["sort_order"]
    end
    #execute the find query
    @movies = Movie.find(:all, :conditions => conditions, :order => sort_order)
    
    #set the other instance variables required - sorted & all_ratings
    @all_ratings = Movie.unique_ratings.map {|movies| movies[:rating]}
    @sorted = {sort_order => 1}
    
    @rated = Hash.new(false)
    if params[:ratings]
      params[:ratings].keys.each { |rating| @rated[rating] = true}
    end

    #store the passed parameters in the session
    if !session.has_key?(:sid)
      session[:sid] = "saasbook-session"
    else  
      session.delete(:ratings)
      session.delete(:sort_order)
    end
    session[:ratings] = params[:ratings]
    session[:sort_order] = params["sort_order"] 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  def search_tmdb
    @movies = Movie.find_in_tmdb(params[:search_terms])
  end
  def find_movies_with_same_director
    @movies = Movie.movies_with_the_same_director_as_this_movie(Movie.find_by_id(params[:id]).id)
    @original_title = Movie.find_by_id(params[:id]).title
    @director_info = Movie.find_by_id(params[:id]).director
  end
end
