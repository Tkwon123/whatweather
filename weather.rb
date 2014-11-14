require 'open-uri'
require 'json'

#Weather API returns Kelvins so we'll have to use these conversion functions later on
def KelvinToCelcius(kelvin)
	return (kelvin - 273.15).round(2)
end

def KelvinToFahrenheit(kelvin)
	return (kelvin * 9/5 - 459.67).round(2)
end

#Need parameters from the command line
if ARGV.empty?
	puts "Pass location parameters in the following format: '[City], [State]'"
else


#Stringing together the arguments to fit into a URL
search = Array.new
ARGV.each do |argv|
	search << argv
end
search = search.join

#Putting together the URL
baseurl =  "http://api.openweathermap.org/data/2.5/weather?q="
appid = "&APPID=aade92db2619aca3f567b1ac542128b5"
fullurl = "#{baseurl}#{search}#{appid}"

#Read the data at the URL 
data = open(fullurl).read
json = JSON.parse(data)

#If the city isn't found, lets get out of here!
if json['cod'] == 400
	abort("City not found. Please try again.")
end

#Assigning variables using conversion functions
tempc = KelvinToCelcius(json["main"]["temp"])
highc = KelvinToCelcius(json["main"]["temp_min"])
lowc = KelvinToCelcius(json["main"]["temp_max"])

tempf = KelvinToFahrenheit(json["main"]["temp"])
highf = KelvinToFahrenheit(json["main"]["temp_min"])
lowf = KelvinToFahrenheit(json["main"]["temp_max"])

#Output to console
puts "Forecast for #{search}"
puts "Temperature (F°) #{tempf}° (hi: #{highf}/lo: #{lowf})"
puts "Temperature (C°) #{tempc}° (hi: #{highc}/lo: #{lowc})"
puts ""
puts "Description: #{json['weather'].first['description']}"
puts "Wind: #{json['wind']['speed']} mph"
puts "Cloudiness: #{json['clouds']['all']}%"

end
