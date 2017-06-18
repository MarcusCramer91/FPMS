if("RJSONIO" %in% rownames(installed.packages()) == FALSE) install.packages("RJSONIO")
if("igraph" %in% rownames(installed.packages()) == FALSE) install.packages("igraph")
require(RJSONIO)
require(ggplot2)
require(igraph)
require(ggmap)
require(RgoogleMaps)
source("source/R/Geo_helper.R")

testData = read.csv("data/testcases/Addresses.csv")
testData_lonlats = geocodeAddresses(testData)
write.table(testData_lonlats, paste("data/testcases/Lonlats.csv"), row.names = FALSE, sep = ",")

center = c(((max(testData_lonlats$lon) + min(testData_lonlats$lon))/2), ((max(testData_lonlats$lat) + min(testData_lonlats$lat))/2))
zoom <- min(MaxZoom(range(testData_lonlats$lon), range(testData_lonlats$lat)))

#mapImageData = get_googlemap(c(lon=7.628496, lat=51.964711), zoom=13)
mapImageData = get_googlemap(center, zoom=zoom, size = c(640, 400))

jpeg("images/testdata100.jpeg", width = 750)
ggmap(mapImageData, extend = "device") + geom_point(aes(x=lon, y=lat), data=testData_lonlats, size=4) + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank(), axis.text.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks = element_blank(), legend.title = element_text(size = 30, face = "bold"),
        legend.text = element_text(size = 30), legend.position = "none")
dev.off()

testData_lonlats = read.csv("data/testcases/Lonlats.csv")

#####################################################
# generate test cases
# 20 customers test case
set.seed(0)
for (i in c(20,30,40,50,60,70,80,90)) {
  for (j in 1:10) {
  # sample lonlats
  lonlats = testData_lonlats[(sample(1:100, i)+1),]
  lonlats = rbind(testData_lonlats[1,],lonlats)
  write.table(lonlats, paste("data/testcases/Lonlats_", i, "_", j, ".csv", sep = ""), row.names = FALSE, sep = ";")
  # generate orders
  orders = data.frame(id = seq(1:i), weight = round(runif(i,1,15)), time = round(runif(i,1,30)), location_id = 2:(i+1))
  write.table(orders, paste("data/testcases/Orders_", i, "_", j, ".csv", sep = ""), row.names = FALSE, sep = ";")
  # generate distance matrix (work with air distances due to google maps api restrictions)
  travelTimesMat = round(calculateAirDistanceMatrix(lonlats)*20000)+30 # factor 20000 to approximate real travel times, + 30 to make them more realistic
  write.table(travelTimesMat, paste("data/testcases/TravelTimes_", i, "_", j, ".csv", sep = ""), col.names = FALSE, row.names = FALSE, sep = ";")
  }
}
