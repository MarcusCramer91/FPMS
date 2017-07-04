require(scales)
require(ggplot2)
days_fp = read.csv("results/days_tw120/FP_Day1.csv", header = FALSE)
colnames(days_fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")



# wait until a certain problem size is reached
days_20 = read.csv("results/days_tw120/20_Day1.csv", header = FALSE)
colnames(days_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_30 = read.csv("results/days_tw120/30_Day1.csv", header = FALSE)
colnames(days_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_40 = read.csv("results/days_tw120/40_Day1.csv", header = FALSE)
colnames(days_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_50 = read.csv("results/days_tw120/50_Day1.csv", header = FALSE)
colnames(days_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_60 = read.csv("results/days_tw120/60_Day1.csv", header = FALSE)
colnames(days_60) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_70 = read.csv("results/days_tw120/70_Day1.csv", header = FALSE)
colnames(days_70) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_80 = read.csv("results/days_tw120/80_Day1.csv", header = FALSE)
colnames(days_80) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_90 = read.csv("results/days_tw120/90_Day1.csv", header = FALSE)
colnames(days_90) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$costsAll/60),
                                                                           sum(days_30$costsAll/60), 
                                                                           sum(days_40$costsAll/60),
                                                                           sum(days_50$costsAll/60),
                                                                           sum(days_60$costsAll/60),
                                                                           sum(days_70$costsAll/60),
                                                                           sum(days_80$costsAll/60),
                                                                           sum(days_90$costsAll/60)))

pdf("images/wait_problemSizes_totalCosts.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Total costs", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$costsAll/60), size = 2)
dev.off()


plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$secondsAll),
                                                                           sum(days_30$secondsAll), 
                                                                           sum(days_40$secondsAll),
                                                                           sum(days_50$secondsAll),
                                                                           sum(days_60$secondsAll),
                                                                           sum(days_70$secondsAll),
                                                                           sum(days_80$secondsAll),
                                                                           sum(days_90$secondsAll)))

pdf("images/wait_problemSizes_totalSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Overall route length (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2)
dev.off()



plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$secondsDriving),
                                                                           sum(days_30$secondsDriving), 
                                                                           sum(days_40$secondsDriving),
                                                                           sum(days_50$secondsDriving),
                                                                           sum(days_60$secondsDriving),
                                                                           sum(days_70$secondsDriving),
                                                                           sum(days_80$secondsDriving),
                                                                           sum(days_90$secondsDriving)))

pdf("images/wait_problemSizes_drivingSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent driving (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsDriving), size = 2) 
dev.off()

# plot waiting times

waiting20 = read.csv("results/days_tw120/20_Days1_waitingTimes.csv", header = TRUE)
waiting30 = read.csv("results/days_tw120/30_Days1_waitingTimes.csv", header = TRUE)
waiting40 = read.csv("results/days_tw120/40_Days1_waitingTimes.csv", header = TRUE)
waiting50 = read.csv("results/days_tw120/50_Days1_waitingTimes.csv", header = TRUE)
waiting60 = read.csv("results/days_tw120/60_Days1_waitingTimes.csv", header = TRUE)
waiting70 = read.csv("results/days_tw120/70_Days1_waitingTimes.csv", header = TRUE)
waiting80 = read.csv("results/days_tw120/80_Days1_waitingTimes.csv", header = TRUE)
waiting90 = read.csv("results/days_tw120/90_Days1_waitingTimes.csv", header = TRUE)

timepoints = seq(0, 43200, by = 60)
mergedData = data.frame(w20 = numeric(length(timepoints)),
                        w30 = numeric(length(timepoints)),
                        w40 = numeric(length(timepoints)),
                        w50 = numeric(length(timepoints)),
                        w60 = numeric(length(timepoints)),
                        w70 = numeric(length(timepoints)),
                        w80 = numeric(length(timepoints)))
for (i in 1:length(timepoints)) {
  if (sum(waiting20$X0 == timepoints[i]) > 0) {
    mergedData$w20[i] = waiting20$X[waiting20$X0 == timepoints[i]]
  }
  else mergedData$w20[i] = NA
  
  if (sum(waiting30$X0 == timepoints[i]) > 0) {
    mergedData$w30[i] = waiting30$X[waiting30$X0 == timepoints[i]]
  }
  else mergedData$w30[i] = NA
  
  if (sum(waiting40$X0 == timepoints[i]) > 0) {
    mergedData$w40[i] = waiting40$X[waiting40$X0 == timepoints[i]]
  }
  else mergedData$w40[i] = NA
  
  if (sum(waiting50$X0 == timepoints[i]) > 0) {
    mergedData$w50[i] = waiting50$X[waiting50$X0 == timepoints[i]]
  }
  else mergedData$w50[i] = NA
  
  if (sum(waiting60$X0 == timepoints[i]) > 0) {
    mergedData$w60[i] = waiting60$X[waiting60$X0 == timepoints[i]]
  }
  else mergedData$w60[i] = NA
  
  if (sum(waiting70$X0 == timepoints[i]) > 0) {
    mergedData$w70[i] = waiting70$X[waiting70$X0 == timepoints[i]]
  }
  else mergedData$w70[i] = NA
  
  if (sum(waiting80$X0 == timepoints[i]) > 0) {
    mergedData$w80[i] = waiting80$X[waiting80$X0 == timepoints[i]]
  }
  else mergedData$w80[i] = NA
  
  if (sum(waiting90$X0 == timepoints[i]) > 0) {
    mergedData$w90[i] = waiting90$X[waiting90$X0 == timepoints[i]]
  }
  else mergedData$w90[i] = NA
}

plotdata = data.frame(time = timepoints,
                      wait = c(mergedData$w20, 
                               mergedData$w30, 
                               mergedData$w40, 
                               mergedData$w50, 
                               mergedData$w60, 
                               mergedData$w70, 
                               mergedData$w80, 
                               mergedData$w90), 
                      Size = c(rep("20 customers", nrow(mergedData)), 
                              rep("30 customers", nrow(mergedData)), 
                              rep("40 customers", nrow(mergedData)), 
                              rep("50 customers", nrow(mergedData)), 
                              rep("60 customers", nrow(mergedData)), 
                              rep("70 customers", nrow(mergedData)), 
                              rep("80 customers", nrow(mergedData)), 
                              rep("90 customers", nrow(mergedData))))


pdf("images/wait_problemSizes_waitingTimes.pdf")
ggplot(data = NULL) + 
  geom_line(data = plotdata[!is.na(plotdata$wait),], aes(x = time/60, y = wait, colour = Size), size = 2) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Waiting times") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top")
dev.off()

# wait until a certain period is passed

wait10 = read.csv("results/days_tw120/wait_600_Day1.csv", header = FALSE)
colnames(wait10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait15 = read.csv("results/days_tw120/wait_900_Day1.csv", header = FALSE)
colnames(wait15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait20 = read.csv("results/days_tw120/wait_1200_Day1.csv", header = FALSE)
colnames(wait20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait25 = read.csv("results/days_tw120/wait_1500_Day1.csv", header = FALSE)
colnames(wait25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait30 = read.csv("results/days_tw120/wait_1800_Day1.csv", header = FALSE)
colnames(wait30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait35 = read.csv("results/days_tw120/wait_2100_Day1.csv", header = FALSE)
colnames(wait35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait40 = read.csv("results/days_tw120/wait_2400_Day1.csv", header = FALSE)
colnames(wait40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = c("10", "15", "20", "25", "30", "35", "40"), costs = c(sum(wait10$secondsDriving),
                                                                                       sum(wait15$secondsDriving),
                                                                                       sum(wait20$secondsDriving),
                                                                                       sum(wait25$secondsDriving),
                                                                                       sum(wait30$secondsDriving),
                                                                                       sum(wait35$secondsDriving),
                                                                                       sum(wait40$secondsDriving)))

pdf("images/wait_waitingTimes_drivingSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent driving (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsDriving), size = 2) 
dev.off()


# do the same for time window = 90
days_fp = read.csv("results/days_tw90/FP_Day1.csv", header = FALSE)
colnames(days_fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")



# wait until a certain problem size is reached
days_20 = read.csv("results/days_tw90/20_Day1.csv", header = FALSE)
colnames(days_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_30 = read.csv("results/days_tw90/30_Day1.csv", header = FALSE)
colnames(days_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_40 = read.csv("results/days_tw90/40_Day1.csv", header = FALSE)
colnames(days_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_50 = read.csv("results/days_tw90/50_Day1.csv", header = FALSE)
colnames(days_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_60 = read.csv("results/days_tw90/60_Day1.csv", header = FALSE)
colnames(days_60) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_70 = read.csv("results/days_tw90/70_Day1.csv", header = FALSE)
colnames(days_70) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_80 = read.csv("results/days_tw90/80_Day1.csv", header = FALSE)
colnames(days_80) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_90 = read.csv("results/days_tw90/90_Day1.csv", header = FALSE)
colnames(days_90) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$costsAll/60),
                                                                                             sum(days_30$costsAll/60), 
                                                                                             sum(days_40$costsAll/60),
                                                                                             sum(days_50$costsAll/60),
                                                                                             sum(days_60$costsAll/60),
                                                                                             sum(days_70$costsAll/60),
                                                                                             sum(days_80$costsAll/60),
                                                                                             sum(days_90$costsAll/60)))

pdf("images/wait_problemSizes_totalCosts_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Total costs", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$costsAll/60), size = 2)
dev.off()


plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$secondsAll),
                                                                                             sum(days_30$secondsAll), 
                                                                                             sum(days_40$secondsAll),
                                                                                             sum(days_50$secondsAll),
                                                                                             sum(days_60$secondsAll),
                                                                                             sum(days_70$secondsAll),
                                                                                             sum(days_80$secondsAll),
                                                                                             sum(days_90$secondsAll)))

pdf("images/wait_problemSizes_totalSeconds_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Overall route length (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2)
dev.off()



plotdata = data.frame(setting = c("20", "30", "40", "50", "60", "70", "80", "90"), costs = c(sum(days_20$secondsDriving),
                                                                                             sum(days_30$secondsDriving), 
                                                                                             sum(days_40$secondsDriving),
                                                                                             sum(days_50$secondsDriving),
                                                                                             sum(days_60$secondsDriving),
                                                                                             sum(days_70$secondsDriving),
                                                                                             sum(days_80$secondsDriving),
                                                                                             sum(days_90$secondsDriving)))

pdf("images/wait_problemSizes_drivingSeconds_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent driving (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsDriving), size = 2) 
dev.off()

# plot waiting times

waiting20 = read.csv("results/days_tw90/20_Days1_waitingTimes.csv", header = TRUE)
waiting30 = read.csv("results/days_tw90/30_Days1_waitingTimes.csv", header = TRUE)
waiting40 = read.csv("results/days_tw90/40_Days1_waitingTimes.csv", header = TRUE)
waiting50 = read.csv("results/days_tw90/50_Days1_waitingTimes.csv", header = TRUE)
waiting60 = read.csv("results/days_tw90/60_Days1_waitingTimes.csv", header = TRUE)
waiting70 = read.csv("results/days_tw90/70_Days1_waitingTimes.csv", header = TRUE)
waiting80 = read.csv("results/days_tw90/80_Days1_waitingTimes.csv", header = TRUE)
waiting90 = read.csv("results/days_tw90/90_Days1_waitingTimes.csv", header = TRUE)

timepoints = seq(0, 43200, by = 60)
mergedData = data.frame(w20 = numeric(length(timepoints)),
                        w30 = numeric(length(timepoints)),
                        w40 = numeric(length(timepoints)),
                        w50 = numeric(length(timepoints)),
                        w60 = numeric(length(timepoints)),
                        w70 = numeric(length(timepoints)),
                        w80 = numeric(length(timepoints)))
for (i in 1:length(timepoints)) {
  if (sum(waiting20$X0 == timepoints[i]) > 0) {
    mergedData$w20[i] = waiting20$X[waiting20$X0 == timepoints[i]]
  }
  else mergedData$w20[i] = NA
  
  if (sum(waiting30$X0 == timepoints[i]) > 0) {
    mergedData$w30[i] = waiting30$X[waiting30$X0 == timepoints[i]]
  }
  else mergedData$w30[i] = NA
  
  if (sum(waiting40$X0 == timepoints[i]) > 0) {
    mergedData$w40[i] = waiting40$X[waiting40$X0 == timepoints[i]]
  }
  else mergedData$w40[i] = NA
  
  if (sum(waiting50$X0 == timepoints[i]) > 0) {
    mergedData$w50[i] = waiting50$X[waiting50$X0 == timepoints[i]]
  }
  else mergedData$w50[i] = NA
  
  if (sum(waiting60$X0 == timepoints[i]) > 0) {
    mergedData$w60[i] = waiting60$X[waiting60$X0 == timepoints[i]]
  }
  else mergedData$w60[i] = NA
  
  if (sum(waiting70$X0 == timepoints[i]) > 0) {
    mergedData$w70[i] = waiting70$X[waiting70$X0 == timepoints[i]]
  }
  else mergedData$w70[i] = NA
  
  if (sum(waiting80$X0 == timepoints[i]) > 0) {
    mergedData$w80[i] = waiting80$X[waiting80$X0 == timepoints[i]]
  }
  else mergedData$w80[i] = NA
  
  if (sum(waiting90$X0 == timepoints[i]) > 0) {
    mergedData$w90[i] = waiting90$X[waiting90$X0 == timepoints[i]]
  }
  else mergedData$w90[i] = NA
}

plotdata = data.frame(time = timepoints,
                      wait = c(mergedData$w20, 
                               mergedData$w30, 
                               mergedData$w40, 
                               mergedData$w50, 
                               mergedData$w60, 
                               mergedData$w70, 
                               mergedData$w80, 
                               mergedData$w90), 
                      Size = c(rep("20 customers", nrow(mergedData)), 
                               rep("30 customers", nrow(mergedData)), 
                               rep("40 customers", nrow(mergedData)), 
                               rep("50 customers", nrow(mergedData)), 
                               rep("60 customers", nrow(mergedData)), 
                               rep("70 customers", nrow(mergedData)), 
                               rep("80 customers", nrow(mergedData)), 
                               rep("90 customers", nrow(mergedData))))


pdf("images/wait_problemSizes_waitingTimes_tw90.pdf")
ggplot(data = NULL) + 
  geom_line(data = plotdata[!is.na(plotdata$wait),], aes(x = time/60, y = wait, colour = Size), size = 2) + theme_bw() + 
  scale_x_continuous(name ="Time point") + scale_y_continuous(name = "Waiting times") +
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top")
dev.off()

# wait until a certain period is passed

wait10 = read.csv("results/days_tw90/wait_600_Day1.csv", header = FALSE)
colnames(wait10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait15 = read.csv("results/days_tw90/wait_900_Day1.csv", header = FALSE)
colnames(wait15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait20 = read.csv("results/days_tw90/wait_1200_Day1.csv", header = FALSE)
colnames(wait20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait25 = read.csv("results/days_tw90/wait_1500_Day1.csv", header = FALSE)
colnames(wait25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait30 = read.csv("results/days_tw90/wait_1800_Day1.csv", header = FALSE)
colnames(wait30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait35 = read.csv("results/days_tw90/wait_2100_Day1.csv", header = FALSE)
colnames(wait35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait40 = read.csv("results/days_tw90/wait_2400_Day1.csv", header = FALSE)
colnames(wait40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = c("10", "15", "20", "25", "30", "35", "40"), costs = c(sum(wait10$secondsDriving),
                                                                                       sum(wait15$secondsDriving),
                                                                                       sum(wait20$secondsDriving),
                                                                                       sum(wait25$secondsDriving),
                                                                                       sum(wait30$secondsDriving),
                                                                                       sum(wait35$secondsDriving),
                                                                                       sum(wait40$secondsDriving)))

pdf("images/wait_waitingTimes_drivingSeconds_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = 1)) + geom_line(stat = "summary", fun.y = sum, size = 2) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent driving (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "none") +
  geom_hline(yintercept = sum(days_fp$secondsDriving), size = 2) 
dev.off()