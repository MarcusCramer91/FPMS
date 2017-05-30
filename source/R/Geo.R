if("RJSONIO" %in% rownames(installed.packages()) == FALSE) install.packages("RJSONIO")
if("igraph" %in% rownames(installed.packages()) == FALSE) install.packages("igraph")
require(RJSONIO)
require(ggplot2)
require(igraph)
source("source/R/Geo_helper.R")

# load dummy data
data = read.csv("MOCK_DATA.csv")

# first convert to long lat
# this allows for more addresses per query, as each query is restricted to 2000 characters

# e.g. geocodeAddress("Muenster, Gasselstiege 30L")
####
# DO NOT COMMIT YOUR API KEY INTO A PUBLICLY VISIBLE GITHUB REPO
apiKey =  "asdfas"

#####################################################################################
# FOR TESTING
origin = geocodeAddress("Muenster, Dahlweg 30")
destination = geocodeAddress("Muenster, Leonardo Campus 3")
longOrigin = origin[2]
latOrigin = origin[1]
longDestination = destination[2]
latDestination = destination[1]
url = "https://maps.googleapis.com/maps/api/distancematrix/json?"
url = URLencode(paste(url, "origins=", longOrigin, ",", latOrigin, "|", longDestination, ",", latDestination, sep = ""))
url = URLencode(paste(url, "&destinations=", longOrigin, ",", latOrigin, "|", longDestination, ",", latDestination, sep = ""))
url = URLencode(paste(url, "&key=", apiKey, sep = ""))
res = fromJSON(url, simplify = FALSE)
res$rows[[1]]$elements[[1]]$duration$value
res$rows[[1]]$elements[[2]]$duration$value
res$rows[[2]]$elements[[1]]$duration$value
res$rows[[2]]$elements[[2]]$duration$value

nrow(lonlats)

travelTimes = getTravelTimes(lonlats, 20)

travelTimesMatrix = getTravelTimesMatrixFromVector(travelTimes)

write.table(travelTimesMatrix[1:10,1:10], "data/SmallRealTravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")


airDistanceMatrix = calculateAirDistanceMatrix(lonlats)
write.table(airDistanceMatrix[1:10,1:10], "data/SmallAirDistances.csv", col.names = FALSE, row.names = FALSE, sep = ",")
# find out the correlation between air distance and travel times
corData = data.frame(airDistance = as.vector(airDistanceMatrix), travelTimes = as.vector(travelTimesMatrix))
cor(corData) # 0.912628 in a small sample of 20 relatively closeby locations



# builds a matrix like 
# 0 292
# 161 0
# -> our distance matrix
#####################################################################################

# build query string (respect 2000 characters limit)


##############
# look into this (google api sucks)
# allows for a maximum of 100 matrix element returned
# limit of 2500 elements total per day
# maximum dimension of query matrix: 25x25
# would cost approximately 500€ for 1mio elements


# test another approach (project-osrm)
origin = geocodeAddress("Muenster, Gasselstiege 30L")
destination = geocodeAddress("Muenster, Leonardo Campus 3")
longOrigin = origin[2]
latOrigin = origin[1]
longDestination = destination[2]
latDestination = destination[1]
url = "http://router.project-osrm.org/route/v1/driving/"
url = URLencode(paste(url, longOrigin, ",", latOrigin, ";", longDestination, ",", latDestination, sep = ""))
url = URLencode(paste(url, "?overview=false",sep = ""))
res = fromJSON(url, simplify = FALSE)
# does not seem to work

# graphhopper could be a possibility, but seems very costly

# possible workaround:
# calculate the distance of every customer to the depot
# calculate the distance of every customer to its closest XYZ other customers
# a possibility would e.g. be 25 other customers, as the google distance matrix api allows a maximum of 25 destinations/origins
airDistanceMatrix = calculateAirDistanceMatrix(longLats)
  
getClosestNeighbors(airDistanceMatrix, 5)




# dummy data for 30 orders
dummy30 = read.csv("data/DummyAddresses_30.csv")
dummy30_lonlats = geocodeAddresses(dummy30)
write.csv(dummy30_lonlats, "data/Dummy30Lonlats.csv")
dummy30_travelTimes = getTravelTimes(dummy30_lonlats, dimension = 31)
dummy30_travelTimesMat = getTravelTimesMatrixFromVector(dummy30_travelTimes, 31)
write.table(dummy30_travelTimesMat, "data/Dummy30TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")
dummy30_airDistanceMat = calculateAirDistanceMatrix(dummy30_lonlats)
write.table(dummy30_airDistanceMat, "data/Dummy30AirDistances.csv", col.names = FALSE, row.names = FALSE, sep = ",")

dummy15_lonlats = dummy30_lonlats[1:15,]
dummy15_travelTimes = getTravelTimes(dummy15_lonlats, apiKey = "AIzaSyDyaWz1zpmwD7lThAmyFnEiUhp3sd2R6Hw", dimension = 15)
dummy15_travelTimesMat = getTravelTimesMatrixFromVector(dummy15_travelTimes, 15)
write.table(dummy15_travelTimesMat, "data/Dummy15TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")

dummy10_travelTimesMat = dummy30_travelTimesMat[1:10,1:10]
dummy11_travelTimesMat = dummy30_travelTimesMat[1:11,1:11]
dummy12_travelTimesMat = dummy30_travelTimesMat[1:12,1:12]
dummy13_travelTimesMat = dummy30_travelTimesMat[1:13,1:13]
dummy14_travelTimesMat = dummy15_travelTimesMat[1:14,1:14]
write.table(dummy10_travelTimesMat, "data/Dummy10TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")
write.table(dummy11_travelTimesMat, "data/Dummy11TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")
write.table(dummy12_travelTimesMat, "data/Dummy12TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")
write.table(dummy13_travelTimesMat, "data/Dummy13TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")
write.table(dummy14_travelTimesMat, "data/Dummy14TravelTimes.csv", col.names = FALSE, row.names = FALSE, sep = ",")

dummy10_airDistance = calculateAirDistanceMatrix(dummy30_lonlats[1:10,])
write.table(dummy10_airDistance, "data/Dummy10AirDistance.csv", col.names = FALSE, row.names = FALSE, sep = ",")

# test nearest neighbor distance matrix approach
closestNeighbors = getClosestNeighbors(dummy30_airDistanceMat, 5)

# plot resulting graph
# generate data frame for edge plotting
from = rep(1:nrow(closestNeighbors), 5)
to = numeric(nrow(closestNeighbors)*5)
counter = 1
for (i in 1:ncol(closestNeighbors)) {
  for (j in 1:nrow(closestNeighbors)) {
    to[counter] = closestNeighbors[j,i]
    counter = counter + 1 
  }
}

plotData = cbind(dummy30_lonlats, fromLat = dummy30_lonlats$lat[from],
                 fromLon = dummy30_lonlats$lon[from],
                 toLat = dummy30_lonlats$lat[to], 
                 toLon = dummy30_lonlats$lon[to])

pdf("images/nearestNeighbor_5.pdf")
ggplot(data = plotData, aes(x = lon, y = lat)) + geom_point(size = 8) + theme_bw() + 
  scale_y_continuous(limits = c(min(plotData$lat), max(plotData$lat))) + scale_x_continuous(limits = c(min(plotData$lon), max(plotData$lon))) + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), legend.position = "none") +
  geom_curve(aes(y = fromLat, x = fromLon, yend = toLat, xend = toLon), 
             curvature = 0, ncp = 50, size = 1)
dev.off()

subgraphs = identifySubgraphs(closestNeighbors)
connections = findShortestLink(subgraphs, dummy30_airDistanceMat)

plotData = rbind(plotData, c(dummy30_lonlats$lon[connections[1,1]], dummy30_lonlats$lat[connections[1,1]], 
                             dummy30_lonlats$lat[connections[1,1]], dummy30_lonlats$lon[connections[1,1]],
                             dummy30_lonlats$lat[connections[1,2]], dummy30_lonlats$lon[connections[1,2]]))
plotData$group = c(rep(1, nrow(plotData) - 1), 2)

pdf("images/nearestNeighbor_5_WithConnection.pdf")
ggplot(data = plotData, aes(x = lon, y = lat)) + geom_point(size = 8) + theme_bw() + 
  scale_y_continuous(limits = c(min(plotData$lat), max(plotData$lat))) + scale_x_continuous(limits = c(min(plotData$lon), max(plotData$lon))) + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), legend.position = "none") +
  geom_curve(aes(y = fromLat, x = fromLon, yend = toLat, xend = toLon, lty = as.factor(group)), 
             curvature = 0, ncp = 50, size = 1)
dev.off()

# get travel times for the nearest neighbors
dummy30_travelTimes_NearestNeighbor = getTravelTimesNearestNeighbor(dummy30_lonlats, closestNeighbors)
dummy30_travelTimesMat_NearestNeighbor = matrix(ncol = 31, nrow = 31)
counter = 1
for (i in 1:nrow(closestNeighbors)) {
  for (j in 1:ncol(closestNeighbors)) {
    dummy30_travelTimesMat_NearestNeighbor[i,closestNeighbors[i,j]] = dummy30_travelTimes_NearestNeighbor[counter]
    counter = counter + 1
  }
}

# get travel times for all connections of subgraphs
dummy30_travelTimes_Connections = getTravelTimesConnections(dummy30_lonlats, connections)
counter = 1
for (i in 1:nrow(connections)) {
  dummy30_travelTimesMat_NearestNeighbor[connections[i,1],connections[i,2]] = dummy30_travelTimes_Connections[counter]
  counter = counter + 1
  dummy30_travelTimesMat_NearestNeighbor[connections[i,2],connections[i,1]] = dummy30_travelTimes_Connections[counter]
  counter = counter + 1
}

# get travel times from the depot to all customers and from all customers to the depot
dummy30_travelTimesMat_Depot = getTravelTimesDepot(dummy30_lonlats)
counter = 1
for (i in 2:nrow(dummy30_travelTimesMat_NearestNeighbor)) {
  dummy30_travelTimesMat_NearestNeighbor[1,i] = dummy30_travelTimesMat_Depot[counter]
  counter = counter + 1
}
for (i in 2:nrow(dummy30_travelTimesMat_NearestNeighbor)) {
  dummy30_travelTimesMat_NearestNeighbor[i,1] = dummy30_travelTimesMat_Depot[counter]
  counter = counter + 1
}

dummy30_travelTimesMat_NearestNeighbor[is.na(dummy30_travelTimesMat_NearestNeighbor)] = 0
g = graph.adjacency(dummy30_travelTimesMat_NearestNeighbor, weighted = TRUE, mode = "directed")
s.paths = shortest.paths(g, algorithm = "dijkstra")

sortOrder = sort.int(as.vector(dummy30_travelTimesMat), index.return = TRUE)
plotData = data.frame(x = as.vector(s.paths)[sortOrder$ix], y = as.vector(dummy30_travelTimesMat)[sortOrder$ix])

pdf("images/nearestNeighbor_5_VsRealTimes.pdf")
ggplot(data = plotData, aes(x = x, y = y)) + geom_line(size = 1) + theme_bw() + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), legend.position = "none")
dev.off()
cor(plotData$x, plotData$y, method = "spearman") #0.9335292

# repeat with 10 nearest neighbors approach
closestNeighbors = getClosestNeighbors(dummy30_airDistanceMat, 10)

subgraphs = identifySubgraphs(closestNeighbors)
# no subgraphs
#connections = findShortestLink(subgraphs, dummy30_airDistanceMat) 

# get travel times for the nearest neighbors
dummy30_travelTimes_NearestNeighbor = getTravelTimesNearestNeighbor(dummy30_lonlats, closestNeighbors)
dummy30_travelTimesMat_NearestNeighbor = matrix(ncol = 31, nrow = 31)
counter = 1
for (i in 1:nrow(closestNeighbors)) {
  for (j in 1:ncol(closestNeighbors)) {
    dummy30_travelTimesMat_NearestNeighbor[i,closestNeighbors[i,j]] = dummy30_travelTimes_NearestNeighbor[counter]
    counter = counter + 1
  }
}
counter = 1
for (i in 2:nrow(dummy30_travelTimesMat_NearestNeighbor)) {
  dummy30_travelTimesMat_NearestNeighbor[1,i] = dummy30_travelTimesMat_Depot[counter]
  counter = counter + 1
}
for (i in 2:nrow(dummy30_travelTimesMat_NearestNeighbor)) {
  dummy30_travelTimesMat_NearestNeighbor[i,1] = dummy30_travelTimesMat_Depot[counter]
  counter = counter + 1
}

dummy30_travelTimesMat_NearestNeighbor[is.na(dummy30_travelTimesMat_NearestNeighbor)] = 0
g = graph.adjacency(dummy30_travelTimesMat_NearestNeighbor, weighted = TRUE, mode = "directed")
s.paths = shortest.paths(g, algorithm = "dijkstra")

sortOrder = sort.int(as.vector(dummy30_travelTimesMat), index.return = TRUE)
plotData = data.frame(x = as.vector(s.paths)[sortOrder$ix], y = as.vector(dummy30_travelTimesMat)[sortOrder$ix])

pdf("images/nearestNeighbor_10_VsRealTimes.pdf")
ggplot(data = plotData, aes(x = x, y = y)) + geom_line(size = 1) + theme_bw() + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), legend.position = "none")
dev.off()
cor(plotData$x, plotData$y, method = "spearman") #0.9484884

diff = plotData$x-plotData$y
diff = diff/plotData$y
diff = abs(diff)
diff[is.nan(diff)] = 0
mean(diff)

# check out google maps difference between different times in the day
dummy30_travelTimes8pm = getTravelTimes(dummy30_lonlats, dimension = 31)
dummy30_travelTimesMat8pm = getTravelTimesMatrixFromVector(dummy30_travelTimes8pm, 31)
