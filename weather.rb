require 'open-uri'
require 'json'

#Weather API returns Kelvins so we'll have to convert these
def KelvinToCelcius(kelvin)
	return (kelvin - 273.15).round(2)
end

def KelvinToFahrenheit(kelvin)
	return (kelvin * 9/5 - 459.67).round(2)
end

if ARGV.empty?
	puts "Find weather in the following format: '[City], [State]'"
else

search = Array.new

ARGV.each do |argv|
	search << argv
end

search = search.join

baseurl =  "http://api.openweathermap.org/data/2.5/weather?q="
appid = "&APPID=aade92db2619aca3f567b1ac542128b5"

fullurl = "#{baseurl}#{search}#{appid}"

data = open(fullurl).read
json = JSON.parse(data)

if json["cod"] = 404
	abort("City not found. Please try again.")
end

#assigning variables
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
puts "Description: #{json['weather'].first['description']}" #Narrative gets returned as an array
puts "Wind: #{json['wind']['speed']} mph"
puts "Cloudiness: #{json['clouds']['all']}%"

end
#Example API call provided by http://openweathermap.org/
=begin
{"coord":{"lon":139,"lat":35},
"sys":{"country":"JP","sunrise":1369769524,"sunset":1369821049},
"weather":[{"id":804,"main":"clouds","description":"overcast clouds","icon":"04n"}],
"main":{"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":292.04},
"wind":{"speed":7.31,"deg":187.002},
"rain":{"3h":0},
"clouds":{"all":92},
"dt":1369824698,
"id":1851632,
"name":"Shuzenji",
"cod":200}
=end 