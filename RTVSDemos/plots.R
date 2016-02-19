
# Plotting on maps

# Data for airports.dat and routes.dat from Open Flights repository: https://github.com/jpatokal/openflights

airports <- read.csv("airports.dat", header = FALSE)
colnames(airports) <- c("ID", "name", "city", "country", "IATA_FAA", "ICAO", "lat", "lon", "altitude", "timezone", "DST", "Region")

# Now would be a good time to view routes inside Variable Explorer (Shift+Alt+V)
# Make sure that you click on the magnifying glass to see our table viewer

# Or you can view the data the old-school R way

head(airports)

routes <- read.csv("routes.dat", header = FALSE)
colnames(routes) <- c("airline", "airlineID", "sourceAirport", "sourceAirportID", "destinationAirport", "destinationAirportID", "codeshare", "stops", "equipment")

# Use the plyr library to filter some data. TODO: convert to using dplyr

library(plyr)

# Extract a count of number of flights departing from an airport and create
# a new data frame, where "nrow" is the name of the column with the flight count

departures <- ddply(routes, .(sourceAirportID), "nrow")

# Rename the column to flights to better represent the semantics of the data

names(departures)[2] <- "departures"

# Merge the departures data set with the original data set that contains that lattitude
# and longitude of airports 

airports_with_departures <- merge(airports, departures, by.x = "ID", by.y = "sourceAirportID")

library(ggmap)

# Get a map centered on USA, at zoom level 3

map <- get_map(location = "USA", zoom = 3)

# Plot circles whose radius is determined by the sqrt of the number of flight departurs from that airport

ggmap(map) + geom_point(aes(x = lon, y = lat, size = sqrt(departures)), data = airports_with_departures, alpha = 0.25)

#######################################################################################################################
# Plotting on interactive maps

library(googleVis)

# Generate a new computed column called LatLong that concatenates the lat and lon columns into a string that is lat:lon

airports_with_departures$LatLong <- paste(airports_with_departures$lat, airports_with_departures$lon, sep = ':')

# Generate a tooltip that contains the name of the airport and its IATA_FAA airport code in parenthesis

airports_with_departures$tooltip <- sprintf("%s (%s)", airports_with_departures$name, airports_with_departures$IATA_FAA)

# Filter out airports with < 100 departures

airports_with_more_than_50_departures <- filter(airports_with_departures, departures > 50)

airportMap <- gvisMap(airports_with_more_than_50_departures, "LatLong", "tooltip",
                      options = list(showTip = TRUE,
                                     enableScrollWheel = TRUE,
                                     height = "1000px",
                                     mapType = 'terrain',
                                     useMapTypeControl = TRUE))

plot(airportMap)

# Generate a chart that contains all airports, not just ones that have > 50 flights. Note this one is not interactive

airportMap <- gvisGeoChart(airports_with_departures, "LatLong", sizevar = "departures", hovervar = "tooltip",
                      options = list(showTip = TRUE,
                                     enableScrollWheel = TRUE,
                                     mapType = 'terrain',
                                     width = "100%",
                                     height = "100%",
                                     useMapTypeControl = TRUE))

plot(airportMap)
