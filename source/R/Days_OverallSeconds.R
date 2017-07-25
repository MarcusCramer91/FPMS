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


days_fp_20 = read.csv("results/days_tw120/_20cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw120/_30cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw120/_40cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw120/_50cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_60 = read.csv("results/days_tw120/_60cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_60) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_70 = read.csv("results/days_tw120/_70cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_70) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_80 = read.csv("results/days_tw120/_80cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_80) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_90 = read.csv("results/days_tw120/_90cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_90) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")



plotdata = data.frame(setting = rep(c("20", "30", "40", "50", "60", "70", "80", "90"), 2), 
                      costs = c(sum(days_20$secondsAll),
                                sum(days_30$secondsAll), 
                                sum(days_40$secondsAll),
                                sum(days_50$secondsAll),
                                sum(days_60$secondsAll),
                                sum(days_70$secondsAll),
                                sum(days_80$secondsAll),
                                sum(days_90$secondsAll),
                                
                                sum(days_fp_20$secondsAll),
                                sum(days_fp_30$secondsAll),
                                sum(days_fp_40$secondsAll),
                                sum(days_fp_50$secondsAll),
                                sum(days_fp_60$secondsAll),
                                sum(days_fp_70$secondsAll),
                                sum(days_fp_80$secondsAll),
                                sum(days_fp_90$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 8), rep("ADA_HEUR",8)))


pdf("images/wait_problemSizes_overallSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
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
wait45 = read.csv("results/days_tw120/wait_2700_Day1.csv", header = FALSE)
colnames(wait45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait50 = read.csv("results/days_tw120/wait_3000_Day1.csv", header = FALSE)
colnames(wait50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


days_fp_10 = read.csv("results/days_tw120/_10_FP_Day1.csv", header = FALSE)
colnames(days_fp_10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_15 = read.csv("results/days_tw120/_15_FP_Day1.csv", header = FALSE)
colnames(days_fp_15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_20 = read.csv("results/days_tw120/_20_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_25 = read.csv("results/days_tw120/_25_FP_Day1.csv", header = FALSE)
colnames(days_fp_25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw120/_30_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_35 = read.csv("results/days_tw120/_35_FP_Day1.csv", header = FALSE)
colnames(days_fp_35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw120/_40_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_45 = read.csv("results/days_tw120/_45_FP_Day1.csv", header = FALSE)
colnames(days_fp_45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw120/_50_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll),
                                                                                                          
                                                                                                          sum(days_fp_10$secondsAll),
                                                                                                          sum(days_fp_15$secondsAll),
                                                                                                          sum(days_fp_20$secondsAll),
                                                                                                          sum(days_fp_25$secondsAll),
                                                                                                          sum(days_fp_30$secondsAll),
                                                                                                          sum(days_fp_35$secondsAll),
                                                                                                          sum(days_fp_40$secondsAll),
                                                                                                          sum(days_fp_45$secondsAll),
                                                                                                          sum(days_fp_50$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 9), rep("ADA_HEUR",9)))

pdf("images/wait_waitingTimes_overallSeconds.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
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


days_fp_20 = read.csv("results/days_tw90/_20cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw90/_30cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw90/_40cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw90/_50cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_60 = read.csv("results/days_tw90/_60cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_60) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_70 = read.csv("results/days_tw90/_70cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_70) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_80 = read.csv("results/days_tw90/_80cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_80) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_90 = read.csv("results/days_tw90/_90cust_FP_Day1.csv", header = FALSE)
colnames(days_fp_90) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")



plotdata = data.frame(setting = rep(c("20", "30", "40", "50", "60", "70", "80", "90"), 2), 
                      costs = c(sum(days_20$secondsAll),
                                sum(days_30$secondsAll), 
                                sum(days_40$secondsAll),
                                sum(days_50$secondsAll),
                                sum(days_60$secondsAll),
                                sum(days_70$secondsAll),
                                sum(days_80$secondsAll),
                                sum(days_90$secondsAll),
                                
                                sum(days_fp_20$secondsAll),
                                sum(days_fp_30$secondsAll),
                                sum(days_fp_40$secondsAll),
                                sum(days_fp_50$secondsAll),
                                sum(days_fp_60$secondsAll),
                                sum(days_fp_70$secondsAll),
                                sum(days_fp_80$secondsAll),
                                sum(days_fp_90$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 8), rep("ADA_HEUR",8)))


pdf("images/wait_problemSizes_overallSeconds_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 1, title="Solution approach"))
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
wait45 = read.csv("results/days_tw90/wait_2700_Day1.csv", header = FALSE)
colnames(wait45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait50 = read.csv("results/days_tw90/wait_3000_Day1.csv", header = FALSE)
colnames(wait50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

days_fp_10 = read.csv("results/days_tw90/_10_FP_Day1.csv", header = FALSE)
colnames(days_fp_10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_15 = read.csv("results/days_tw90/_15_FP_Day1.csv", header = FALSE)
colnames(days_fp_15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_20 = read.csv("results/days_tw90/_20_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_25 = read.csv("results/days_tw90/_25_FP_Day1.csv", header = FALSE)
colnames(days_fp_25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw90/_30_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_35 = read.csv("results/days_tw90/_35_FP_Day1.csv", header = FALSE)
colnames(days_fp_35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw90/_40_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_45 = read.csv("results/days_tw90/_45_FP_Day1.csv", header = FALSE)
colnames(days_fp_45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw90/_50_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll),
                                                                                                          
                                                                                                          sum(days_fp_10$secondsAll),
                                                                                                          sum(days_fp_15$secondsAll),
                                                                                                          sum(days_fp_20$secondsAll),
                                                                                                          sum(days_fp_25$secondsAll),
                                                                                                          sum(days_fp_30$secondsAll),
                                                                                                          sum(days_fp_35$secondsAll),
                                                                                                          sum(days_fp_40$secondsAll),
                                                                                                          sum(days_fp_45$secondsAll),
                                                                                                          sum(days_fp_50$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 9), rep("ADA_HEUR",9)))

pdf("images/wait_waitingTimes_overallSeconds_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()



#######################
# repeat for uniform day distribution
days_fp = read.csv("results/days_tw90/FP_Day1.csv", header = FALSE)
colnames(days_fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

wait10 = read.csv("results/days_tw90_uniform/wait_600_Day1.csv", header = FALSE)
colnames(wait10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait15 = read.csv("results/days_tw90_uniform/wait_900_Day1.csv", header = FALSE)
colnames(wait15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait20 = read.csv("results/days_tw90_uniform/wait_1200_Day1.csv", header = FALSE)
colnames(wait20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait25 = read.csv("results/days_tw90_uniform/wait_1500_Day1.csv", header = FALSE)
colnames(wait25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait30 = read.csv("results/days_tw90_uniform/wait_1800_Day1.csv", header = FALSE)
colnames(wait30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait35 = read.csv("results/days_tw90_uniform/wait_2100_Day1.csv", header = FALSE)
colnames(wait35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait40 = read.csv("results/days_tw90_uniform/wait_2400_Day1.csv", header = FALSE)
colnames(wait40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait45 = read.csv("results/days_tw90_uniform/wait_2700_Day1.csv", header = FALSE)
colnames(wait45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait50 = read.csv("results/days_tw90_uniform/wait_3000_Day1.csv", header = FALSE)
colnames(wait50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

days_fp_10 = read.csv("results/days_tw90_uniform/_10_FP_Day1.csv", header = FALSE)
colnames(days_fp_10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_15 = read.csv("results/days_tw90_uniform/_15_FP_Day1.csv", header = FALSE)
colnames(days_fp_15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_20 = read.csv("results/days_tw90_uniform/_20_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_25 = read.csv("results/days_tw90_uniform/_25_FP_Day1.csv", header = FALSE)
colnames(days_fp_25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw90_uniform/_30_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_35 = read.csv("results/days_tw90_uniform/_35_FP_Day1.csv", header = FALSE)
colnames(days_fp_35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw90_uniform/_40_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_45 = read.csv("results/days_tw90_uniform/_45_FP_Day1.csv", header = FALSE)
colnames(days_fp_45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw90_uniform/_50_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll),
                                                                                                          
                                                                                                          sum(days_fp_10$secondsAll),
                                                                                                          sum(days_fp_15$secondsAll),
                                                                                                          sum(days_fp_20$secondsAll),
                                                                                                          sum(days_fp_25$secondsAll),
                                                                                                          sum(days_fp_30$secondsAll),
                                                                                                          sum(days_fp_35$secondsAll),
                                                                                                          sum(days_fp_40$secondsAll),
                                                                                                          sum(days_fp_45$secondsAll),
                                                                                                          sum(days_fp_50$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 9), rep("ADA_HEUR",9)))


require(scales)
pdf("images/wait_waitingTimes_overallSeconds_tw90_uniform.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 1, title="Solution approach"))
dev.off()



days_fp = read.csv("results/days_tw120/FP_Day1.csv", header = FALSE)
colnames(days_fp) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


wait10 = read.csv("results/days_tw120_uniform/wait_600_Day1.csv", header = FALSE)
colnames(wait10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait15 = read.csv("results/days_tw120_uniform/wait_900_Day1.csv", header = FALSE)
colnames(wait15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait20 = read.csv("results/days_tw120_uniform/wait_1200_Day1.csv", header = FALSE)
colnames(wait20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait25 = read.csv("results/days_tw120_uniform/wait_1500_Day1.csv", header = FALSE)
colnames(wait25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait30 = read.csv("results/days_tw120_uniform/wait_1800_Day1.csv", header = FALSE)
colnames(wait30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait35 = read.csv("results/days_tw120_uniform/wait_2100_Day1.csv", header = FALSE)
colnames(wait35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait40 = read.csv("results/days_tw120_uniform/wait_2400_Day1.csv", header = FALSE)
colnames(wait40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait45 = read.csv("results/days_tw120_uniform/wait_2700_Day1.csv", header = FALSE)
colnames(wait45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
wait50 = read.csv("results/days_tw120_uniform/wait_3000_Day1.csv", header = FALSE)
colnames(wait50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")

days_fp_10 = read.csv("results/days_tw120_uniform/_10_FP_Day1.csv", header = FALSE)
colnames(days_fp_10) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_15 = read.csv("results/days_tw120_uniform/_15_FP_Day1.csv", header = FALSE)
colnames(days_fp_15) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_20 = read.csv("results/days_tw120_uniform/_20_FP_Day1.csv", header = FALSE)
colnames(days_fp_20) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_25 = read.csv("results/days_tw120_uniform/_25_FP_Day1.csv", header = FALSE)
colnames(days_fp_25) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_30 = read.csv("results/days_tw120_uniform/_30_FP_Day1.csv", header = FALSE)
colnames(days_fp_30) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_35 = read.csv("results/days_tw120_uniform/_35_FP_Day1.csv", header = FALSE)
colnames(days_fp_35) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_40 = read.csv("results/days_tw120_uniform/_40_FP_Day1.csv", header = FALSE)
colnames(days_fp_40) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_45 = read.csv("results/days_tw120_uniform/_45_FP_Day1.csv", header = FALSE)
colnames(days_fp_45) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")
days_fp_50 = read.csv("results/days_tw120_uniform/_50_FP_Day1.csv", header = FALSE)
colnames(days_fp_50) = c("time", "npaths", "ncust", "secondsDriving", "secondsAll", "costsDriving", "costsAll","MET")


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll),
                                                                                                          
                                                                                                          sum(days_fp_10$secondsAll),
                                                                                                          sum(days_fp_15$secondsAll),
                                                                                                          sum(days_fp_20$secondsAll),
                                                                                                          sum(days_fp_25$secondsAll),
                                                                                                          sum(days_fp_30$secondsAll),
                                                                                                          sum(days_fp_35$secondsAll),
                                                                                                          sum(days_fp_40$secondsAll),
                                                                                                          sum(days_fp_45$secondsAll),
                                                                                                          sum(days_fp_50$secondsAll)),
                      group = c(rep("Stabilized cutting planes", 9), rep("ADA_HEUR",9)))

pdf("images/wait_waitingTimes_overallSeconds_tw120_uniform.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  geom_hline(yintercept = sum(days_fp$secondsAll), size = 2) +
  guides(color=guide_legend(nrow = 2, title="Solution approach"))
dev.off()
