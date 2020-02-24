require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

ForecastIO.api_key = "677a036af258586108a34184cb91c5e6"

get "/" do
  view "search"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates
    @lat = lat_long[0]
    @long = lat_long[1]
    @lat_long = "#{@lat}, #{@long}"
    
    forecast = ForecastIO.forecast(@lat,@long).to_hash
    
    current_temperature = forecast["currently"]["temperature"]
    @current_temperature = current_temperature
    
    conditions = forecast["currently"]["summary"]
    @current_conditions = conditions

    for day in forecast["daily"]["data"]
    puts "A high temperature of #{day["temperatureHigh"]} and #{day["summary"]}"
    end
    
    daily_high = day["temperatureHigh"]
    @daily_high = daily_high

    daily_summary = day["summary"]
    @daily_summary = daily_summary


    
view "news"
end