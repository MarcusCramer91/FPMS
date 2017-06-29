require(RJSONIO)
require(ggplot2)
require(igraph)
require(ggmap)
require(RgoogleMaps)
source("source/R/Geo_helper.R")


bound1 = c(51.983401, 7.574487)
bound2 = c(51.934073, 7.658187)
randomLons = runif(1200, bound2[1], bound1[1])
randomLats = runif(1200, bound1[2], bound2[2])
randomLonLats = as.data.frame(cbind(lon = randomLons, lat = randomLats))
depot = c(51.949880, 7.650355)
randomLonLats = rbind(depot, randomLonLats)

travelTimesMat = round(calculateAirDistanceMatrix(randomLonLats)*20000)+30

dayDistribution = c(60,60,60,60,60,60,60,120,120,120,180,180,180,240,240,300,300,360,360,360,420,420,420,
                    420,420,420,480,480,480,480,480,480,540,540,540,540,600,600,600,660,660)
orderTimes = sample(dayDistribution, 1200, replace = TRUE)
orderTimes = floor(orderTimes + runif(1200,-60,60))
orderTimes = sort(orderTimes)

plotdata = data.frame(time = seq(0,720, length.out = 13))
plotdata$orders = numeric(nrow(plotdata))
for (i in 1:(nrow(plotdata)-1)) {
  plotdata$orders[i] = length(orderTimes[orderTimes > plotdata$time[i] & orderTimes < plotdata$time[i+1]])
}

pdf("images/orderDistribution.pdf")
ggplot(data = plotdata, aes(x = time, y = orders)) + geom_bar(stat = "identity") + theme_bw() + 
  scale_x_continuous(limits = c(0, 720), name ="Order time") + scale_y_continuous(name = "Number of orders") +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") 
dev.off()


hist(orderTimes)

write.table(randomLonLats, paste("data/daytestcases/LonlatsDay1.csv", sep = ""), row.names = FALSE, sep = ",")
# generate orders
orders = data.frame(id = seq(1:1200), weight = round(runif(1200,1,15)), time = orderTimes, location_id = 2:(1200+1))
write.table(orders, paste("data/daytestcases/OrdersDay1.csv", sep = ""), row.names = FALSE, sep = ",")
# generate distance matrix (work with air distances due to google maps api restrictions)
write.table(travelTimesMat, paste("data/daytestcases/TravelTimesDay1.csv", sep = ""), col.names = FALSE, row.names = FALSE, sep = ",")
