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
  guides(color=guide_legend(nrow = 2, title="Aggregation"))
dev.off()

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
  guides(color=guide_legend(nrow = 2, title="Aggregation"))
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