if("ape" %in% rownames(installed.packages()) == FALSE) install.packages("ape")
if("grid" %in% rownames(installed.packages()) == FALSE) install.packages("grid")
require(ggplot2)
require(ape)
require(grid)

# build plot data and groupings to create connections
plotData = lonlats[1:10,]
# normalize
plotData$lon = plotData$lon - min(plotData$lon)
plotData$lat = plotData$lat - min(plotData$lat)
plotData$lon = plotData$lon / max(plotData$lon)
plotData$lat = plotData$lat / max(plotData$lat)
plotDataGroup = as.data.frame(cbind(plotData[c(1,7),], group = 1))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(1,8),], group = 2))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(1,10),], group = 3))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(7,9),], group = 4))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(6,9),], group = 5))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(6,5),], group = 6))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(6,4),], group = 7))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(2,4),], group = 8))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(2,3),], group = 9))
rownames(plotDataGroup) = c("1", "7", "","8", " ","10", "   ", "9", "6", "    ", "     ", "5", "      ", "4", "2", "       ", "         ", "3")

minST = mst(travelTimesMatrix[1:10,1:10])
# java solution: 10->1, 1->8, 1->7, 7->9, 9->6, 6->5, 6->4, 4->2, 2->3
# costs (using the minimum costs of two distances): 228+86+79+134+78+86+77+98+65=931
# r solution based on the ape-package: 1->10, 1->7, 1->8, 7->9, 9->6, 6->5, 6->4, 4->2, 2->3
# costs: 228+79+86+134+78+86+77+98+65=931
# java code apparently correct


pdf("images/MST.pdf")
ggplot(data = plotDataGroup, aes(x = lat, y = lon, group = group)) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = rownames(plotDataGroup), hjust = 0, vjust = -1), size = 12) + 
  geom_line(size = 2) + scale_y_continuous(limits = c(0, 1.1)) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                               axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                               axis.title.x=element_blank(),
                                                               axis.title.y=element_blank())
dev.off()

plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(1,5),], group = 10))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(3,6),], group = 11))
plotDataGroup = rbind(plotDataGroup, cbind(plotData[c(8,10),], group = 12))
plotDataGroup$names = c("1", "7", "","8", "","10", "", "9", "6", "", "", "5", "", "4", "2", "", "", "3", "", "", "", "", "", "")
plotDataGroup = cbind(plotDataGroup, linetype = c(rep(1, 18), rep(2, 6)))
plotDataGroup$linetype = as.factor(plotDataGroup$linetype)

pdf("images/MSTplusWeightMatching.pdf")
ggplot(data = plotDataGroup, aes(x = lat, y = lon, group = group, lty = linetype)) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = names, hjust = 0, vjust = -1), size = 12) + 
  geom_line(size = 2) + scale_y_continuous(limits = c(0, 1.1)) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                                       axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                                       axis.title.x=element_blank(),
                                                                       axis.title.y=element_blank(), legend.position = "none")
dev.off()

plotDataCurve = plotData[c(2,3,6,9,7,1,8,10,1,5,6,4),]
plotDataCurve = cbind(plotDataCurve, name = c("1/13","2","3/11","4","5","6/9","7","8","","10","","12"))
curveData = data.frame(fromLat = numeric(12), toLat = numeric(12), fromLon = numeric(12), toLon = numeric(12))
curveData$fromLat = plotData$lat[c(2,3,6,9,7,1,8,10,1,5,6,4)]
curveData$toLat = plotData$lat[c(3,6,9,7,1,8,10,1,5,6,4,2)]
curveData$fromLon = plotData$lon[c(2,3,6,9,7,1,8,10,1,5,6,4)]
curveData$toLon = plotData$lon[c(3,6,9,7,1,8,10,1,5,6,4,2)]
plotDataCurve = cbind(plotDataCurve, curveData)

pdf("images/EulerianPath.pdf")
ggplot(data = plotDataCurve, aes(x = lat, y = lon)) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = plotDataCurve$name, hjust = 0, vjust = -1), size = 12) + 
  scale_y_continuous(limits = c(0, 1.1)) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                                       axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                                       axis.title.x=element_blank(),
                                                                       axis.title.y=element_blank(), legend.position = "none") +
  geom_curve(aes(x = fromLat, y = fromLon, xend = toLat, yend = toLon), 
             arrow = arrow(length = unit(0.5, "cm"), type = "closed"), curvature = 0.15, ncp = 50, size = 1)
dev.off()


plotDataCurve = plotData[c(2,3,6,9,7,1,8,10,5,4),]
curveData = data.frame(fromLat = numeric(10), toLat = numeric(10), fromLon = numeric(10), toLon = numeric(10))
curveData$fromLat = plotData$lat[c(2,3,6,9,7,1,8,10,5,4)]
curveData$toLat = plotData$lat[c(3,6,9,7,1,8,10,5,4,2)]
curveData$fromLon = plotData$lon[c(2,3,6,9,7,1,8,10,5,4)]
curveData$toLon = plotData$lon[c(3,6,9,7,1,8,10,5,4,2)]
plotDataCurve = cbind(plotDataCurve, curveData)

pdf("images/ChristofidesInitialSolution.pdf")
ggplot(data = plotDataCurve, aes(x = lat, y = lon)) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = rownames(plotDataCurve), hjust = 0, vjust = -1), size = 12) + 
  scale_y_continuous(limits = c(0, 1.1)) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                 axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                 axis.title.x=element_blank(),
                                                 axis.title.y=element_blank(), legend.position = "none") +
  geom_curve(aes(x = fromLat, y = fromLon, xend = toLat, yend = toLon), 
             arrow = arrow(length = unit(0.5, "cm"), type = "closed"), curvature = 0.15, ncp = 50, size = 1)
dev.off()

# plot optimal TSP solution

plotDataCurve = plotData[c(1,10,3,2,4,5,6,9,7,8),]
curveData = data.frame(fromLat = numeric(10), toLat = numeric(10), fromLon = numeric(10), toLon = numeric(10))
curveData$fromLat = plotData$lat[c(1,10,3,2,4,5,6,9,7,8)]
curveData$toLat = plotData$lat[c(10,3,2,4,5,6,9,7,8,1)]
curveData$fromLon = plotData$lon[c(1,10,3,2,4,5,6,9,7,8)]
curveData$toLon = plotData$lon[c(10,3,2,4,5,6,9,7,8,1)]
plotDataCurve = cbind(plotDataCurve, curveData)

pdf("images/TSPOptimalSolution.pdf")
ggplot(data = plotDataCurve, aes(x = lat, y = lon)) + geom_point(size = 8) + theme_bw() + 
  geom_text(aes(label = rownames(plotDataCurve), hjust = 0, vjust = -1), size = 12) + 
  scale_y_continuous(limits = c(0, 1.1)) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                 axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                 axis.title.x=element_blank(),
                                                 axis.title.y=element_blank(), legend.position = "none") +
  geom_curve(aes(x = fromLat, y = fromLon, xend = toLat, yend = toLon), 
             arrow = arrow(length = unit(0.5, "cm"), type = "closed"), curvature = 0.15, ncp = 50, size = 1)
dev.off()
