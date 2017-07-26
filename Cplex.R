convergenceData = read.csv("results/CramerInstance_30_1_results.csv")

plotData = data.frame(time = seq(10, 3600, by = 10), results = convergenceData[,1])

require(ggplot2)
pdf("images/cplexconvergence_30cust_naive.pdf")
ggplot(data = plotData, aes(x = time, y = results)) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  xlab("Computation time in s") +
  ylab("Travel distance") 
dev.off()


plotData = data.frame(time = seq(10, 3600, by = 10), results = convergenceData[,2])

pdf("images/cplexconvergenceGap_30cust_naive.pdf")
ggplot(data = plotData, aes(x = time, y = results)) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  xlab("Computation time in s") +
  ylab("Gap to lower bound in %")
dev.off()