require 'net/http'
require 'json'
require 'pp'


require "http"
require "optparse"


# Place holders for Yelp Fusion's OAuth 2.0 credentials. Grab them
# from https://www.yelp.com/developers/v3/manage_app
CLIENT_ID = "x0LOXFAjrgc9FObJNnszTQ"
CLIENT_SECRET = "1mWDj5IL7JIGZ7KLnvzTNpWDy2777z3NHr4XvBf54MPLDRJGu3gJqxQG8J1gXPbR"


# Constants, do not change these
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"  # trailing / because we append the business id to the path
TOKEN_PATH = "/oauth2/token"
GRANT_TYPE = "client_credentials"


DEFAULT_BUSINESS_ID = "yelp-san-francisco"
DEFAULT_TERM = "dinner"
DEFAULT_LOCATION = "San Francisco, CA"
SEARCH_LIMIT = 5


def bearer_token
  # Put the url together
  url = "#{API_HOST}#{TOKEN_PATH}"

  raise "Please set your CLIENT_ID" if CLIENT_ID.nil?
  raise "Please set your CLIENT_SECRET" if CLIENT_SECRET.nil?

  # Build our params hash
  params = {
    client_id: CLIENT_ID,
    client_secret: CLIENT_SECRET,
    grant_type: GRANT_TYPE
  }

  response = HTTP.post(url, params: params)
  parsed = response.parse

  "#{parsed['token_type']} #{parsed['access_token']}"
end



# Returns a parsed json object of the request
def search(start_lat, start_long, end_lat, end_long, radius, term)
    latitude=start_lat
    longitude=start_long
    puts latitude
    puts end_lat
    # place = []
    # address= []
    places_hash={
        
    }
    while ((latitude-end_lat).abs>0.05) do 
         puts "------------------------------------------"
    # latitude=((start_lat)..(end_lat)).step(0.001).to_a
    # longitude=((start_long)..(end_long)).step(0.001).to_a
    # s=start_long
        url = "#{API_HOST}#{SEARCH_PATH}"

        params = {
            # categories: term,
            term: term,
            latitude: latitude,
            longitude: longitude,
            radius: radius
            
            # limit: SEARCH_LIMIT
          }

        response = HTTP.auth(bearer_token).get(url, params: params)

        
       puts result=response.parse
    if result["businesses"]!=nil
        result["businesses"].each do |place|
            #need to change each loop
            places_hash[place["name"]]=place["location"]["address1"]
        end
    end
    
    puts latitude
    puts end_lat
        latitude=(latitude+(end_lat-start_lat)/5.0)
        longitude=(longitude+(end_long-start_long)/5.0)
    end
    puts places_hash
    return places_hash
end





def calculate_route(user_search, user_radius, user_interest)
    # user_interest=" "
    start_lat=0
    start_long=0
    end_lat=0
    end_long=0
    
    case user_search 
        when "Colombus, OH to Detroit, MI"
            start_lat=39.9612
            start_long=-82.9988
            end_lat=42.3314
            end_long=-83.0458
        when "Indianapolis, IN to Detroit, MI"
            start_lat= 41.8781
            start_long=-87.6298
            end_lat=42.3314
            end_long=-83.0458
        when "Chicago, IL to Detroit, MI"
            start_lat=41.8781
            start_long=-87.6298
            end_lat=42.3314
            end_long=-83.0458
        else
            puts "input valid option"
        
    end
    return search(start_lat, start_long, end_lat, end_long, user_radius, user_interest)

end
    
    


def getstatement(user_interest)
    if user_interest=="Food"
        return result_statement="Here are some food options on your way to Detroit!"
    elsif user_interest=="Gas Station"
        return result_statement="Here are some gas stations on your way to Detroit!"
    elsif user_interest=="Scenic"
        return result_statement="Here are some scenic spots on your way to Detroit!"
    elsif user_interest=="Indoor Activities"
        return result_statement="Here are some indoor activities on your way to Detroit!"
    elsif user_interest=="Outdoor Activities"
        return result_statement="Here are some outdoor activities on your way to Detroit!"
    elsif user_interest=="Hotel"
        return result_statement="Here are some hotels on your way to Detroit!"
    end
end


# def find_coordinates(start_lat, start_long, end_lat, end_long)
        
#     # i=start_lat
#     # for i in start_lat..end_lat do
#     # i+=0.001
#     # lat=i
#     # end
#     # lat=((start_lat)..(end_lat)).step(0.001).to_a
#     # s=start_long
#     # for s in start_long..end_long do
#     # s+=0.001
#     # long=s
#     # end
#     # long=((start_long)..(end_long)).step(0.001).to_a
# # end
#     lat=start_lat
#     long=start_long
    
#      type="restaurant"
#     #  &#{keyword}=#{preferences.gsub(" ","+")}
     
#     #  keyword="mexican"
#     #  preferences="taco"
#     # while (lat-end_lat).abs>0 do 
#         puts "here"
#     endpoint="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{long}&rankby=distance&type=restaurant&key=AIzaSyB5aLHFgdH3mumNwTwd6Cc0Ix22yXK-knU"
#     sample_uri = URI(endpoint) #opens a portal to the data at that link
    
#     sample_response = Net::HTTP.get(sample_uri) #go grab the data in the portal
    
#     sample_parsedResponse = JSON.parse(sample_response) #makes data easy to read
#     sample_parsedResponse["results"].each do |i|
#         puts i["name"]
#     end
#     # do |key, value|
#     #     pp "The #{key} is #{value}"
#     # end
#     puts lat
#     puts long
#     # lat=lat+(end_lat-start_lat)/5.0
#     # long=long+(end_long-start_long)/5.0

#     # end


# end
# 35.9940° N, 78.8986° W
# 40.7128° N, 74.0059° W
# 40.8429° N, 73.2929° W
    # find_coordinates(48.8566,2.3522,35.9940,78.8986)
    # puts find_places(lat, long, restaurant, Mexican, taco)
    


# Make a request to the Fusion API token endpoint to get the access token.
# 
# host - the API's host
# path - the oauth2 token path
#
# Examples
#
#   bearer_token
#   # => "Bearer some_fake_access_token"
#
# Returns your access token




# Make a request to the Fusion search endpoint. Full documentation is online at:
# https://www.yelp.com/developers/documentation/v3/business_search
#
# term - search term used to find businesses
# location - what geographic location the search should happen
#
# Examples
#
#   search("burrito", "san francisco")
#   # => {
#          "total": 1000000,
#          "businesses": [
#            "name": "El Farolito"
#            ...
#          ]
#        }
#
#   search("sea food", "Seattle")
#   # => {
#          "total": 1432,
#          "businesses": [
#            "name": "Taylor Shellfish Farms"
#            ...
#          ]
#        }
#


# search("new york")
# search(42.3314,-83.0458,42.2808,-83.7430, 10000)
        
        
        
 
   
    