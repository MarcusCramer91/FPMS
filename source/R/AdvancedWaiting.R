###########
# advanced waiting strategies
require(ggplot2)
results = read.csv("results/days/optimal_Day1_tw120.csv", header = FALSE)
colnames(results) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routeLengths = read.csv("results/days/RouteLengths_tw120.csv", header = FALSE)
routeLengths = routeLengths[,-ncol(routeLengths)]
minimum = apply(routeLengths, 1, function(x) min(na.omit(x)))
maximum = apply(routeLengths, 1, function(x) max(na.omit(x)))
avg = apply(routeLengths, 1, function(x) mean(na.omit(x)))

# normalize
plotdata = as.data.frame(cbind(time = results$time/60,
                               value = c(avg/max(avg), minimum/max(minimum), maximum/max(maximum), 
                                         results$secondsAll/results$ncust/max(results$secondsAll/results$ncust)),
                               group = c(rep("Average route length", length(avg)),
                                         rep("Minimum route length", length(maximum)),
                                         rep("Maximum route length", length(minimum)),
                                         rep("Overall time per customer", length(minimum)))), stringsAsFactors = FALSE)
plotdata$time = as.numeric(plotdata$time)
plotdata$value = as.numeric(plotdata$value)

pdf("images/wait_routeLengths_tw120.pdf")
ggplot(data = plotdata, aes(x = time, y = value, color = group)) + geom_line(size = 2) + geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Normalized value") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Aggregation"))  +
  annotate("text", x = results$time/60, y = minimum/max(minimum) + 0.03, 
           label = floor(minimum/60), size = 7)
dev.off()

# compute correlations
cor(results$secondsAll/results$ncust, maximum)
cor(results$secondsAll/results$ncust, minimum)
cor(results$secondsAll/results$ncust, avg)

# check average METs per customer
plotdata = as.data.frame(cbind(time = results$time/60,
                               value = c((results$MET/results$ncust)/max(results$MET/results$ncust), 
                                         (results$secondsAll/results$ncust)/max(results$secondsAll/results$ncust)),
                               group = c(rep("Average MET per customer", nrow(results)),
                                         rep("Overall time per customer", nrow(results)))), stringsAsFactors = FALSE)
plotdata$time = as.numeric(plotdata$time)
plotdata$value = as.numeric(plotdata$value)

pdf("images/wait_mets_tw120.pdf")
ggplot(data = plotdata, aes(x = time, y = value, color = group)) + geom_line(size = 2) + geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Normalized value") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Aggregation")) +
  annotate("text", x = results$time/60, y = (results$MET/results$ncust)/max(results$MET/results$ncust) + 0.01, 
           label = floor(results$MET/results$ncust/60), size = 7)
dev.off()


# repeat for tw90
require(ggplot2)
results = read.csv("results/days/optimal_Day1_tw90.csv", header = FALSE)
colnames(results) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routeLengths = read.csv("results/days/RouteLengths_tw90.csv", header = FALSE)
routeLengths = routeLengths[,-ncol(routeLengths)]
minimum = apply(routeLengths, 1, function(x) min(na.omit(x)))
maximum = apply(routeLengths, 1, function(x) max(na.omit(x)))
avg = apply(routeLengths, 1, function(x) mean(na.omit(x)))

# normalize
plotdata = as.data.frame(cbind(time = results$time/60,
                               value = c(avg/max(avg), minimum/max(minimum), maximum/max(maximum), 
                                         results$secondsAll/results$ncust/max(results$secondsAll/results$ncust)),
                               group = c(rep("Average route length", length(avg)),
                                         rep("Minimum route length", length(maximum)),
                                         rep("Maximum route length", length(minimum)),
                                         rep("Overall time per customer", length(minimum)))), stringsAsFactors = FALSE)
plotdata$time = as.numeric(plotdata$time)
plotdata$value = as.numeric(plotdata$value)

pdf("images/wait_routeLengths_tw90.pdf")
ggplot(data = plotdata, aes(x = time, y = value, color = group)) + geom_line(size = 2) + geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Normalized value") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Aggregation"))  +
  annotate("text", x = results$time/60, y = minimum/max(minimum) + 0.03, 
           label = floor(minimum/60), size = 7)
dev.off()

# check average METs per customer
plotdata = as.data.frame(cbind(time = results$time/60,
                               value = c((results$MET/results$ncust)/max(results$MET/results$ncust), 
                                         (results$secondsAll/results$ncust)/max(results$secondsAll/results$ncust)),
                               group = c(rep("Average MET per customer", nrow(results)),
                                         rep("Overall time per customer", nrow(results)))), stringsAsFactors = FALSE)
plotdata$time = as.numeric(plotdata$time)
plotdata$value = as.numeric(plotdata$value)

pdf("images/wait_mets_tw90.pdf")
ggplot(data = plotdata, aes(x = time, y = value, color = group)) + geom_line(size = 2) + geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Normalized value") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Aggregation")) +
  annotate("text", x = results$time/60, y = (results$MET/results$ncust)/max(results$MET/results$ncust) + 0.01, 
           label = floor(results$MET/results$ncust/60), size = 7)
dev.off()


# plot results of route length-based waiting strategy

default1 = read.csv("results/days/optimal_Day1_tw120.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength1 = read.csv("results/days_tw120/1500_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw120/1800_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw120/2100_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw120/2400_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw120/2700_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6 = read.csv("results/days_tw120/3000_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength6) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength7 = read.csv("results/days_tw120/3300_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength7) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength8 = read.csv("results/days_tw120/3600_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength8) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength9 = read.csv("results/days_tw120/3900_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength9) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength10 = read.csv("results/days_tw120/4200_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


default2 = read.csv("results/days_tw120/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength1fp = read.csv("results/days_tw120/1500_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw120/1800_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw120/2100_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw120/2400_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw120/2700_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6fp = read.csv("results/days_tw120/3000_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength6fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength7fp = read.csv("results/days_tw120/3300_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength7fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength8fp = read.csv("results/days_tw120/3600_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength8fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength9fp = read.csv("results/days_tw120/3900_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength9fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength10fp = read.csv("results/days_tw120/4200_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength10fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = rep(c("25", "30", "35", "40", "45", "50", "55", "60", "65", "70"),2), costs = c(sum(routelength1$secondsAll),
                                                                                       sum(routelength2$secondsAll),
                                                                                       sum(routelength3$secondsAll),
                                                                                       sum(routelength4$secondsAll),
                                                                                       sum(routelength5$secondsAll),
                                                                                       sum(routelength6$secondsAll),
                                                                                       sum(routelength7$secondsAll),
                                                                                       sum(routelength8$secondsAll),
                                                                                       sum(routelength9$secondsAll),
                                                                                       sum(routelength10$secondsAll),
                                                                                       sum(routelength1fp$secondsAll),
                                                                                       sum(routelength2fp$secondsAll),
                                                                                       sum(routelength3fp$secondsAll),
                                                                                       sum(routelength4fp$secondsAll),
                                                                                       sum(routelength5fp$secondsAll),
                                                                                       sum(routelength6fp$secondsAll),
                                                                                       sum(routelength7fp$secondsAll),
                                                                                       sum(routelength8fp$secondsAll),
                                                                                       sum(routelength9fp$secondsAll),
                                                                                       sum(routelength10fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 10), rep("ADA_HEUR", 10)))

require(scales)
require(ggplot2)
pdf("images/wait_routelengthwaiting_tw120.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Minimum route length (minutes)") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()


# get costs per customer except for the last two decisions
avgCosts = c(mean(routelength1$secondsAll[-c(nrow(routelength1),nrow(routelength1)-1)]/routelength1$ncust[-c(nrow(routelength1),nrow(routelength1)-1)]),
             mean(routelength2$secondsAll[-c(nrow(routelength2),nrow(routelength2)-1)]/routelength2$ncust[-c(nrow(routelength2),nrow(routelength2)-1)]),
             mean(routelength3$secondsAll[-c(nrow(routelength3),nrow(routelength3)-1)]/routelength3$ncust[-c(nrow(routelength3),nrow(routelength3)-1)]),
             mean(routelength4$secondsAll[-c(nrow(routelength4),nrow(routelength4)-1)]/routelength4$ncust[-c(nrow(routelength4),nrow(routelength4)-1)]),
             mean(routelength5$secondsAll[-c(nrow(routelength5),nrow(routelength5)-1)]/routelength5$ncust[-c(nrow(routelength5),nrow(routelength5)-1)]),
             mean(routelength6$secondsAll[-c(nrow(routelength6),nrow(routelength6)-1)]/routelength6$ncust[-c(nrow(routelength6),nrow(routelength6)-1)]),
             mean(routelength7$secondsAll[-c(nrow(routelength7),nrow(routelength7)-1)]/routelength7$ncust[-c(nrow(routelength7),nrow(routelength7)-1)]),
             mean(routelength8$secondsAll[-c(nrow(routelength8),nrow(routelength8)-1)]/routelength8$ncust[-c(nrow(routelength8),nrow(routelength8)-1)]),
             mean(routelength9$secondsAll[-c(nrow(routelength9),nrow(routelength9)-1)]/routelength9$ncust[-c(nrow(routelength9),nrow(routelength9)-1)]),
             mean(routelength10$secondsAll[-c(nrow(routelength10),nrow(routelength10)-1)]/routelength10$ncust[-c(nrow(routelength10),nrow(routelength10)-1)]))
 

plotdata = data.frame(setting = c("25", "30", "35", "40", "45", "50", "55", "60", "65", "70"), costs = avgCosts)            
pdf("images/wait_routelengthwaiting_tw120_avgCostsWithoutLastTwo.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs)) + geom_line(size = 2, aes(group = 1)) + 
  geom_point(size = 4) + theme_bw() + 
  scale_x_discrete(name ="Minimum route length (minutes)") + scale_y_continuous(name = "Average time spent per customer", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = mean(default$secondsAll[-c(ncol(default),ncol(default)-1)]/default$ncust[-c(ncol(default),ncol(default)-1)]), size = 2)
dev.off()

# tw = 90

default1 = read.csv("results/days/optimal_Day1_tw90.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength1 = read.csv("results/days_tw90/1680_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw90/1800_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw90/1920_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw90/2040_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw90/2160_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

default2 = read.csv("results/days_tw90/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength1fp = read.csv("results/days_tw90/1680_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw90/1800_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw90/1920_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw90/2040_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw90/2160_fp_routeGoodnessRouteLength_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = rep(c("28", "30", "32", "34", "36")), costs = c(sum(routelength1$secondsAll),
                                                                                                         sum(routelength2$secondsAll),
                                                                                                         sum(routelength3$secondsAll),
                                                                                                         sum(routelength4$secondsAll),
                                                                           sum(routelength5$secondsAll),
                                                                           sum(routelength1fp$secondsAll),
                                                                           sum(routelength2fp$secondsAll),
                                                                           sum(routelength3fp$secondsAll),
                                                                           sum(routelength4fp$secondsAll),
                                                                           sum(routelength5fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 5), rep("ADA_HEUR", 5)))

require(scales)
require(ggplot2)
pdf("images/wait_routelengthwaiting_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Minimum route length (minutes)") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()

# get costs per customer except for the last two decisions
avgCosts = c(mean(routelength1$secondsAll[-c(nrow(routelength1),nrow(routelength1)-1)]/routelength1$ncust[-c(nrow(routelength1),nrow(routelength1)-1)]),
             mean(routelength2$secondsAll[-c(nrow(routelength2),nrow(routelength2)-1)]/routelength2$ncust[-c(nrow(routelength2),nrow(routelength2)-1)]),
             mean(routelength3$secondsAll[-c(nrow(routelength3),nrow(routelength3)-1)]/routelength3$ncust[-c(nrow(routelength3),nrow(routelength3)-1)]),
             mean(routelength4$secondsAll[-c(nrow(routelength4),nrow(routelength4)-1)]/routelength4$ncust[-c(nrow(routelength4),nrow(routelength4)-1)]),
             mean(routelength5$secondsAll[-c(nrow(routelength5),nrow(routelength5)-1)]/routelength5$ncust[-c(nrow(routelength5),nrow(routelength5)-1)]))


plotdata = data.frame(setting = c("28", "30", "32", "34", "36"), costs = avgCosts)            
pdf("images/wait_routelengthwaiting_tw90_avgCostsWithoutLastTwo.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs)) + geom_line(size = 2, aes(group = 1)) + 
  geom_point(size = 4) + theme_bw() + 
  scale_x_discrete(name ="Minimum route length (minutes)") + scale_y_continuous(name = "Average time spent per customer", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = mean(default$secondsAll[-c(ncol(default),ncol(default)-1)]/default$ncust[-c(ncol(default),ncol(default)-1)]), size = 2)
dev.off()

# plot MET based waiting strategy

default1 = read.csv("results/days/optimal_Day1_tw120.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

default2 = read.csv("results/days_tw120/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1 = read.csv("results/days_tw120/4320_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw120/4440_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw120/4560_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw120/4680_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw120/4800_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6 = read.csv("results/days_tw120/4920_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength6) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1fp = read.csv("results/days_tw120/4320_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw120/4440_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw120/4560_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw120/4680_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw120/4800_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6fp = read.csv("results/days_tw120/4920_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength6fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = rep(c("72", "74", "76", "78", "80", "82"), 2), costs = c(sum(routelength1$secondsAll),
                                                                                       sum(routelength2$secondsAll),
                                                                                       sum(routelength3$secondsAll),
                                                                                       sum(routelength4$secondsAll),
                                                                                       sum(routelength5$secondsAll),
                                                                                 sum(routelength6$secondsAll),
                                                                                 sum(routelength1fp$secondsAll),
                                                                                 sum(routelength2fp$secondsAll),
                                                                                 sum(routelength3fp$secondsAll),
                                                                                 sum(routelength4fp$secondsAll),
                                                                                 sum(routelength5fp$secondsAll),
                                                                                 sum(routelength6fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 6), rep("ADA_HEUR", 6)))

require(scales)
require(ggplot2)
pdf("images/wait_metwaiting_tw120.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Minimum average MET (minutes)") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()

# tw = 90

default1 = read.csv("results/days/optimal_Day1_tw90.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

default2 = read.csv("results/days_tw90/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1 = read.csv("results/days_tw90/3720_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw90/3840_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw90/3960_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw90/4080_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw90/4200_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6 = read.csv("results/days_tw90/4320_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength6) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1fp = read.csv("results/days_tw90/3720_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw90/3840_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw90/3960_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw90/4080_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw90/4200_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength6fp = read.csv("results/days_tw90/4320_fp_routeGoodnessMET_Day1.csv", header = FALSE)
colnames(routelength6fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = rep(c("62", "64", "66", "68", "70", "72"), 2), costs = c(sum(routelength1$secondsAll),
                                                                                         sum(routelength2$secondsAll),
                                                                                         sum(routelength3$secondsAll),
                                                                                         sum(routelength4$secondsAll),
                                                                                         sum(routelength5$secondsAll),
                                                                                         sum(routelength6$secondsAll),
                                                                                         sum(routelength1fp$secondsAll),
                                                                                         sum(routelength2fp$secondsAll),
                                                                                         sum(routelength3fp$secondsAll),
                                                                                         sum(routelength4fp$secondsAll),
                                                                                         sum(routelength5fp$secondsAll),
                                                                                         sum(routelength6fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 6), rep("ADA_HEUR", 6)))

require(scales)
require(ggplot2)
pdf("images/wait_metwaiting_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Minimum average MET (minutes)") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()

# plot look-ahead
default1 = read.csv("results/days/optimal_Day1_tw120.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
default2 = read.csv("results/days_tw120/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1 = read.csv("results/days_tw120/1_lookAhead_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw120/2_lookAhead_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw120/3_lookAhead_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw120/4_lookAhead_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw120/5_lookAhead_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1fp = read.csv("results/days_tw120/1_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw120/2_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw120/3_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw120/4_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw120/5_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = rep(c("1", "2", "3", "4", "5"),2), costs = c(sum(routelength1$secondsAll),
                                                                                 sum(routelength2$secondsAll),
                                                                                 sum(routelength3$secondsAll),
                                                                      sum(routelength4$secondsAll),
                                                                      sum(routelength5$secondsAll),
                                                                      sum(routelength1fp$secondsAll),
                                                                      sum(routelength2fp$secondsAll),
                                                                      sum(routelength3fp$secondsAll),
                                                                      sum(routelength4fp$secondsAll),
                                                                      sum(routelength5fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 5), rep("ADA_HEUR", 5)))

require(scales)
require(ggplot2)
pdf("images/wait_lookahead_tw120.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Look ahead iterations") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()

# tw 90


default1 = read.csv("results/days/optimal_Day1_tw90.csv", header = FALSE)
colnames(default1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
default2 = read.csv("results/days_tw90/FP_Day1.csv", header = FALSE)
colnames(default2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1 = read.csv("results/days_tw90/1_lookAhead_Day1.csv", header = FALSE)
colnames(routelength1) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2 = read.csv("results/days_tw90/2_lookAhead_Day1.csv", header = FALSE)
colnames(routelength2) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3 = read.csv("results/days_tw90/3_lookAhead_Day1.csv", header = FALSE)
colnames(routelength3) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4 = read.csv("results/days_tw90/4_lookAhead_Day1.csv", header = FALSE)
colnames(routelength4) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5 = read.csv("results/days_tw90/5_lookAhead_Day1.csv", header = FALSE)
colnames(routelength5) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

routelength1fp = read.csv("results/days_tw90/1_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength1fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength2fp = read.csv("results/days_tw90/2_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength2fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength3fp = read.csv("results/days_tw90/3_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength3fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength4fp = read.csv("results/days_tw90/4_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength4fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
routelength5fp = read.csv("results/days_tw90/5_fp_lookAhead_Day1.csv", header = FALSE)
colnames(routelength5fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = rep(c("1", "2", "3", "4", "5"),2), costs = c(sum(routelength1$secondsAll),
                                                                             sum(routelength2$secondsAll),
                                                                             sum(routelength3$secondsAll),
                                                                             sum(routelength4$secondsAll),
                                                                             sum(routelength5$secondsAll),
                                                                             sum(routelength1fp$secondsAll),
                                                                             sum(routelength2fp$secondsAll),
                                                                             sum(routelength3fp$secondsAll),
                                                                             sum(routelength4fp$secondsAll),
                                                                             sum(routelength5fp$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 5), rep("ADA_HEUR", 5)))

require(scales)
require(ggplot2)
pdf("images/wait_lookahead_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  geom_point(size = 4, aes(colour = group)) + theme_bw() + 
  scale_x_discrete(name ="Look ahead iterations") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(default1$secondsAll), size = 2, colour = "#00BFC4") + 
  geom_hline(yintercept = sum(default2$secondsAll), size = 2, colour = "#F8766D") + 
  guides(color=guide_legend(nrow = 2, title="Solution approach")) 
dev.off()


# analyze how many vehicles are required per iteration
ncars1 = read.csv("results/days_tw120/nCars_colgen_tw120.csv")
colnames(ncars1) = c("time", "ncars")
ncars2 = read.csv("results/days_tw120/nCars_optimal_fp_tw120.csv")
colnames(ncars2) = c("time", "ncars")
ncars3 = read.csv("results/days_tw120/nCars_default_fp_tw120.csv")
colnames(ncars3) = c("time", "ncars")
ncars4 = read.csv("results/days_tw120/nCars_default_fporig_tw120.csv")
colnames(ncars4) = c("time", "ncars")

plotdata = data.frame(time = c(ncars1$time, ncars4$time)/60, 
                      ncars = c(ncars1$ncars, ncars4$ncars),
                      group = c(rep("Optimal stabilized cutting planes", times = nrow(ncars1)),
                                rep("Default ORIG_HEUR", times = nrow(ncars1))))
plotdata$time = as.numeric(as.character(plotdata$time))


pdf("images/wait_ncars_120.pdf")
ggplot(data = plotdata, aes(x = time, y = ncars, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "No. of active cars", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Configuration")) 
dev.off()


ncars1 = read.csv("results/days_tw90/nCars_colgen_tw90.csv")
colnames(ncars1) = c("time", "ncars")
ncars2 = read.csv("results/days_tw90/nCars_optimal_fp_tw90.csv")
colnames(ncars2) = c("time", "ncars")
ncars3 = read.csv("results/days_tw90/nCars_default_fp_tw90.csv")
colnames(ncars3) = c("time", "ncars")
ncars4 = read.csv("results/days_tw90/nCars_default_fporig_tw90.csv")
colnames(ncars4) = c("time", "ncars")

plotdata = data.frame(time = c(ncars1$time, ncars4$time)/60, 
                      ncars = c(ncars1$ncars, ncars4$ncars),
                      group = c(rep("Optimal stabilized cutting planes", times = nrow(ncars1)),
                                rep("Default ORIG_HEUR", times = nrow(ncars1))))
plotdata$time = as.numeric(as.character(plotdata$time))


pdf("images/wait_ncars_90.pdf")
ggplot(data = plotdata, aes(x = time, y = ncars, group = group)) + geom_line(size = 2, aes(colour = group)) + 
  theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "No. of active cars", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Configuration")) 
dev.off()
