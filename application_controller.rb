require 'bundler'
Bundler.require
require_relative 'models/model.rb'
class MyApp < Sinatra::Base

  get '/' do
    erb :index
  end
  
post '/cities' do
   #take user input from the form
    user_cities=params[:cities]
    user_interest=params[:interest]
    user_radius=params[:radius].to_i
    @answer=calculate_route(user_cities, user_radius, user_interest)
    @statement=getstatement(user_interest)
    puts @answer
    puts @statement
    erb :results
  end
  

end