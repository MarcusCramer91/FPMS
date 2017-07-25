
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

plotdata = data.frame(setting = rep(c("20", "30", "40", "50", "60", "70", "80", "90"), 2), 
                      costs = c(
                                889978,
                                850296,
                                832482,
                                825746,
                                819069,
                                815435,
                                829843,
                                825573,
                                sum(days_20$secondsAll),
                                sum(days_30$secondsAll), 
                                sum(days_40$secondsAll),
                                sum(days_50$secondsAll),
                                sum(days_60$secondsAll),
                                sum(days_70$secondsAll),
                                sum(days_80$secondsAll),
                                sum(days_90$secondsAll)),
                      group = c(rep("Brennecke 2017", 8), rep("Cramer 2017",8)))


pdf("images/wait_problemSizes_comparison_tw120.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Thesis"))
dev.off()


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

plotdata = data.frame(setting = rep(c("20", "30", "40", "50", "60", "70", "80", "90"), 2), 
                      costs = c(
                        1017156,
                        987592,
                        973917,
                        977030,
                        987952,
                        1009379,
                        995416,
                        1008186,
                        sum(days_20$secondsAll),
                        sum(days_30$secondsAll), 
                        sum(days_40$secondsAll),
                        sum(days_50$secondsAll),
                        sum(days_60$secondsAll),
                        sum(days_70$secondsAll),
                        sum(days_80$secondsAll),
                        sum(days_90$secondsAll)),
                      group = c(rep("Brennecke 2017", 8), rep("Cramer 2017",8)))


pdf("images/wait_problemSizes_comparison_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Problem size") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Thesis"))
dev.off()


# met 

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


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(NA,
                                                                                                          877322,
                                                                                                          842801,
                                                                                                          829523,
                                                                                                          817936,
                                                                                                          822730,
                                                                                                          818833,
                                                                                                          834726,
                                                                                                          837925,
                                                                                                          sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll)),
                      group = c(rep("Brennecke 2017", 9), rep("Cramer 2017",9)))

pdf("images/wait_waitingTimes_comparison_tw120.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Thesis"))
dev.off()


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


plotdata = data.frame(setting = rep(c("10", "15", "20", "25", "30", "35", "40", "45", "50"),2), costs = c(NA,
                                                                                                          996694,
                                                                                                          978484,
                                                                                                          965358,
                                                                                                          973750,
                                                                                                          992277,
                                                                                                          1017946,
                                                                                                          1048413,
                                                                                                          NA,
                                                                                                          sum(wait10$secondsAll),
                                                                                                          sum(wait15$secondsAll),
                                                                                                          sum(wait20$secondsAll),
                                                                                                          sum(wait25$secondsAll),
                                                                                                          sum(wait30$secondsAll),
                                                                                                          sum(wait35$secondsAll),
                                                                                                          sum(wait40$secondsAll),
                                                                                                          sum(wait45$secondsAll),
                                                                                                          sum(wait50$secondsAll)),
                      group = c(rep("Brennecke 2017", 9), rep("Cramer 2017",9)))

pdf("images/wait_waitingTimes_comparison_tw90.pdf")
ggplot(data = plotdata, aes(x = setting, y = costs, group = group)) + geom_line(size = 2, aes(color = group)) + 
  geom_point(size = 4, aes(color = group)) + theme_bw() + 
  scale_x_discrete(name ="Minutes waited") + scale_y_continuous(name = "Time spent overall (s)", labels = comma) +
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") +
  guides(color=guide_legend(nrow = 2, title="Thesis"))
dev.off()
