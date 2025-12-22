call import "android.r"
call AndroidInit

say "Finding ZIP code."
location = getLastKnownLocation()
say location
loc = json(location,"gps")
say "GPS=" loc
if loc="null" then do
	loc = json(location,"network")
	say "Network=" loc
end
if loc="null" then do
	say "Unable to find location"
	exit
end
addr = geocode(json(loc,"latitude"), json(loc,"longitude"))
say "Addr=" addr
zip = json(addr,"postal_code")
say "Zip=" zip
