pathToLonLats = "data/Dummy30Lonlats.csv"
plotLonLats = read.csv(pathToLonLats)
nodes = list(c(1, 25, 23, 22, 31, 8, 9, 2, 5, 7, 10, 1), 
             c(1, 20, 14, 12, 15, 18, 30, 17, 21, 13, 16, 19, 1),
             c(1, 3, 28, 11, 26, 27, 29, 24, 1), 
             c(1, 4, 6, 1))

require(ggplot2)
fromLonLat = data.frame(lon = numeric(0), lat = numeric(0))
toLonLat = data.frame(lon = numeric(0), lat = numeric(0))
for (i in 1:length(nodes)) {
  fromLonLat = rbind(fromLonLat, plotLonLats[nodes[[i]][-length(nodes[[i]])],2:3])
  toLonLat = rbind(toLonLat, plotLonLats[nodes[[i]][-1],2:3])
}
plotData = cbind(fromLonLat, toLonLat)
colnames(plotData) = c("fromlon", "fromlat", "tolon", "tolat")
plotData$group = c(rep(1, length(nodes[[1]])-1),
                   rep(2, length(nodes[[2]])-1),
                   rep(3, length(nodes[[3]])-1),
                   rep(4, length(nodes[[4]])-1))
plotData$group = as.factor(plotData$group)


pdf("images/30_Initial.pdf")
ggplot(plotLonLats, aes(x = lon, y = lat)) + geom_point(size = 4) + theme_bw() + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
           axis.title.x=element_blank(), axis.text.y = element_blank(),
           axis.title.y=element_blank(), legend.position = "none") + 
  geom_curve(data = plotData, aes(x = fromlon, y = fromlat, xend = tolon, yend = tolat, color = group),
             arrow = arrow(length = unit(0.5, "cm"), type = "closed"), curvature = 0.15, ncp = 50, size = 1)
dev.off()

nodes = list(c(1, 20, 14, 12, 17, 18, 15, 21, 13, 16, 19, 1), 
             c(1, 25, 2, 23, 22, 29, 24, 30, 26, 27, 1),
             c(1, 8, 9, 10, 7, 6, 5, 3, 4, 28, 11, 31, 1))

require(ggplot2)
fromLonLat = data.frame(lon = numeric(0), lat = numeric(0))
toLonLat = data.frame(lon = numeric(0), lat = numeric(0))
for (i in 1:length(nodes)) {
  fromLonLat = rbind(fromLonLat, plotLonLats[nodes[[i]][-length(nodes[[i]])],2:3])
  toLonLat = rbind(toLonLat, plotLonLats[nodes[[i]][-1],2:3])
}
plotData = cbind(fromLonLat, toLonLat)
colnames(plotData) = c("fromlon", "fromlat", "tolon", "tolat")
plotData$group = c(rep(1, length(nodes[[1]])-1),
                   rep(2, length(nodes[[2]])-1),
                   rep(3, length(nodes[[3]])-1))
plotData$group = as.factor(plotData$group)


pdf("images/30_Colgen.pdf")
ggplot(plotLonLats, aes(x = lon, y = lat)) + geom_point(size = 4) + theme_bw() + 
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.title.x=element_blank(), axis.text.y = element_blank(),
        axis.title.y=element_blank(), legend.position = "none") + 
  geom_curve(data = plotData, aes(x = fromlon, y = fromlat, xend = tolon, yend = tolat, color = group),
             arrow = arrow(length = unit(0.5, "cm"), type = "closed"), curvature = 0.15, ncp = 50, size = 1)
dev.off()
