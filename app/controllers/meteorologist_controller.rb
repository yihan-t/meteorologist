require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    #get latitude and longitude
    url_geo = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address
    url_geo = url_geo.gsub(" ","+")

    parsed_data_geo = JSON.parse(open(url_geo).read)
    lat = parsed_data_geo["results"][0]["geometry"]["location"]["lat"]
    lng = parsed_data_geo["results"][0]["geometry"]["location"]["lng"]

    #get weather
    secretkey = "260807eb4ede50c08a7c127717e6fa9c"
    url_w = "https://api.darksky.net/forecast/" + secretkey + "/" + lat.to_s + "," + lng.to_s
    parsed_data = JSON.parse(open(url_w).read)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
