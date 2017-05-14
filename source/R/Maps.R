if("ggmap" %in% rownames(installed.packages()) == FALSE) install.packages("ggmap")
if("RgoogleMaps" %in% rownames(installed.packages()) == FALSE) install.packages("RgoogleMaps")
require(ggmap)
require(RgoogleMaps)

mymap = readPNG("data/staticmap.png")
mymap = GetMap(center = c(51.964711,7.628496), zoom = 14, destfile = "data/staticmap.png", NEWMAP = FALSE)

mapImageData = get_googlemap(c(lon=7.628496, lat=51.964711), zoom=12)
save(mapImageData, file="data/savedMap.rda")

# from file source/R/Geo.R
myData = longLats[1:10,]

# for some reason, pdf only prints the map
# png prints nothing and generates an empty file
jpeg("images/example_map.jpeg", width = 800, height = 800)
ggmap(mapImageData, extend = "device") + geom_point(aes(x=lon, y=lat), data=myData, colour="red", size=4) + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank(), axis.text.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks = element_blank())
dev.off()


# show maps of flaws of the current approach
addresses = read.csv("data/flaw1.csv")
lonlats = geoCodeAddresses(addresses)
myData = as.data.frame(cbind(lonlats, cluster = numeric(nrow(lonlats))))
myData$cluster = c(rep(1,times = 9), 3, rep(2, times = 10))
myData$cluster = as.factor(myData$cluster)

write.csv(lonlats, "data/Dummy_lonlats.csv")

center = c(((max(myData$lon) + min(myData$lon))/2), ((max(myData$lat) + min(myData$lat))/2))
zoom <- min(MaxZoom(range(myData$lon), range(myData$lat)))

#mapImageData = get_googlemap(c(lon=7.628496, lat=51.964711), zoom=13)
mapImageData = get_googlemap(center, zoom=zoom, size = c(640, 200))

jpeg("images/flaw1_map.jpeg", width = 1600)
ggmap(mapImageData, extend = "device") + geom_point(aes(x=lon, y=lat, shape = cluster), data=myData, size=8) + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank(), axis.text.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks = element_blank(), legend.title = element_text(size = 30, face = "bold"),
        legend.text = element_text(size = 30), legend.position = "bottom") + 
  scale_shape_discrete(solid = TRUE, name = "Assignment\t", labels = c("First trip\t", "Second trip\t", "Problematic customer\t"))
dev.off()

#Flaschenpost depot located at Lütkenbecker Weg 10, 48155 Münster

# plot dummy data with 30 entries

center = c(((max(dummy30_lonlats$lon) + min(dummy30_lonlats$lon))/2), ((max(dummy30_lonlats$lat) + min(dummy30_lonlats$lat))/2))
zoom <- min(MaxZoom(range(dummy30_lonlats$lon), range(dummy30_lonlats$lat)))

#mapImageData = get_googlemap(c(lon=7.628496, lat=51.964711), zoom=13)
mapImageData = get_googlemap(center, zoom=zoom, size = c(640, 400))

jpeg("images/dummy30.jpeg", width = 750)
ggmap(mapImageData, extend = "device") + geom_point(aes(x=lon, y=lat), data=dummy30_lonlats, size=4) + 
  theme(axis.title.x=element_blank(), axis.title.y=element_blank(), axis.text.x = element_blank(), 
        axis.text.y = element_blank(), axis.ticks = element_blank(), legend.title = element_text(size = 30, face = "bold"),
        legend.text = element_text(size = 30), legend.position = "none")
dev.off()

ggplot(data = dummy30_lonlats, aes(x = as.numeric(lon), y = as.numeric(lat))) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = rownames(dummy30_lonlats), hjust = 0, vjust = -1), size = 12) + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(), legend.position = "none")

