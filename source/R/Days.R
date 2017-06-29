require(scales)
require(ggplot2)
days_fp = read.csv("results/days/FP_Day1.csv", header = FALSE)
colnames(days_fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_20 = read.csv("results/days/20_Day1.csv", header = FALSE)
colnames(days_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_30 = read.csv("results/days/30_Day1.csv", header = FALSE)
colnames(days_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_40 = read.csv("results/days/40_Day1.csv", header = FALSE)
colnames(days_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_50 = read.csv("results/days/50_Day1.csv", header = FALSE)
colnames(days_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_60 = read.csv("results/days/60_Day1.csv", header = FALSE)
colnames(days_60) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_70 = read.csv("results/days/70_Day1.csv", header = FALSE)
colnames(days_70) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70"), costs = c(sum(days_20$costsAll/60),
                                                                           sum(days_30$costsAll/60), 
                                                                           sum(days_40$costsAll/60),
                                                                           sum(days_50$costsAll/60),
                                                                           sum(days_60$costsAll/60),
                                                                           sum(days_70$costsAll/60)))

pdf("images/wait_problemSizes_totalCosts.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Total costs", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$costsAll/60), size = 2)
dev.off()


plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70"), costs = c(sum(days_20$secondsAll),
                                                                           sum(days_30$secondsAll), 
                                                                           sum(days_40$secondsAll),
                                                                           sum(days_50$secondsAll),
                                                                           sum(days_60$secondsAll),
                                                                           sum(days_70$secondsAll/60)))

pdf("images/wait_problemSizes_totalSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Overall route length (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2)
dev.off()



plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70"), costs = c(sum(days_20$secondsDriving),
                                                                           sum(days_30$secondsDriving), 
                                                                           sum(days_40$secondsDriving),
                                                                           sum(days_50$secondsDriving),
                                                                           sum(days_60$secondsDriving),
                                                                           sum(days_70$secondsDriving)))

pdf("images/wait_problemSizes_drivingSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent driving (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsDriving), size = 2) 
dev.off()
