class MoviesController < ApplicationController

  helper_method :sort_column, :sort_direction
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # the logic has been moved to Model
    # @all_ratings = ['G','PG','PG-13','R']
    # @all_ratings = Movie.select(:ratings).uniq
    # @all_ratings = Movie.find(:all).map(&:rating).uniq
    
    # filter ratings
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings]? params[:ratings] || session[:ratings] : @all_ratings.inject({}) {|rating,key| rating[key]="1" ; rating}
    
    # sort column and direction
    @sort_column = params[:sort] || session[:sort] ? params[:sort] || session[:sort]: "title"
    @sort_direction = params[:direction] || session[:direction] ? params[:direction] || session[:direction]: "asc"
    instance_variable_set( "@#{@sort_column}_css", "hilite" )
    
    # save sessions
    if @sort_column != session[:sort] or @sort_direction != session[:direction] or @selected_ratings != session[:ratings]
      session[:sort] = @sort_column
      session[:direction] = @sort_direction
      session[:ratings] = @selected_ratings
    end
    
    if(params[:sort] || params[:direction] || params[:ratings])
      @movies = Movie.find_all_by_rating(@selected_ratings.keys, :order => @sort_column + " " + @sort_direction)   
    else
      #If you find that the incoming URI is lacking the right params[] and you're forced to fill them in from the session[], 
      #the RESTful thing to do is to redirect_to the new URI containing the appropriate parameters. 
      redirect_to movies_path(:sort => @sort_column, :direction => @sort_direction, :ratings => @selected_ratings)
    end  
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
  
 
end
