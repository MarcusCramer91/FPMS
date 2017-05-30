convergenceData = read.csv("data/ConvergenceCPLEX_default.csv")

plotData = data.frame(time = rep(convergenceData$runtime, 3), results = c(convergenceData[,2],convergenceData[,3], convergenceData[,4]), 
                      groups = c(rep("Standard", nrow(convergenceData)), rep("Lower bounds", nrow(convergenceData)),
                                 rep("LB + Route limit", nrow(convergenceData))))

require(ggplot2)
pdf("images/cplexconvergence_30cust_naive.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Implementation") + 
  xlab("Computation time in s") +
  ylab("Travel distance") + geom_hline(yintercept = 12254, na.rm = FALSE,
                                       show.legend = NA, size = 2)
dev.off()


plotData = data.frame(time = rep(convergenceData$runtime, 3), results = c(convergenceData[,5],convergenceData[,6], convergenceData[,7]), 
                      groups = c(rep("Standard", nrow(convergenceData)), rep("Lower bounds", nrow(convergenceData)),
                                 rep("LB + Route limit", nrow(convergenceData))))

pdf("images/cplexconvergenceGap_30cust_naive.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Implementation") + 
  xlab("Computation time in s") +
  ylab("Gap to lower bound in %")
dev.off()