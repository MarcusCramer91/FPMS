allResults = list.files("results")

results_20_2 = data.frame(time = seq(10, 300, by = 10))
results_30_3 = data.frame(time = seq(10, 300, by = 10))
results_40_4 = data.frame(time = seq(10, 300, by = 10))
results_50_5 = data.frame(time = seq(10, 300, by = 10))

for (i in 1:length(allResults)) {
  if (grepl("c10", allResults[i])) {
    if (file.size(paste("results/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/", allResults[i], sep = ""), header = FALSE)
    if (nrow(data) > 30) data = data[1:30,]
    # remove weirdly high values
    data[data[,1]>10000,1] = NA
    data[data[,2]>=1,2] = NA
    if (nrow(data) < 30) {
      for (j in (nrow(data)+1):30) {
        data = rbind(data, c(data[nrow(data),1], 0))
      }
    }
    if (grepl("22_2", allResults[i])) {
      results_20_2 = cbind(results_20_2, data)
    }
    else if (grepl("32_3", allResults[i])) {
      results_30_3 = cbind(results_30_3, data)
    }
    else if (grepl("42_4", allResults[i])) {
      results_40_4 = cbind(results_40_4, data)
    }
    else if (grepl("52_5", allResults[i])) {
      results_50_5 = cbind(results_50_5, data)
    }
  }
}
require(ggplot2)
plotData_20_2 = data.frame(time = results_20_2[,1], 
                              distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$distanceMean, plotData_20_2$distanceLower, 
                                                                      plotData_20_2$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$distanceMean, plotData_30_3$distanceLower, 
                                                                      plotData_30_3$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$distanceMean, plotData_40_4$distanceLower, 
                                                                      plotData_40_4$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$distanceMean, plotData_50_5$distanceLower, 
                                                                      plotData_50_5$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$gapMean, plotData_20_2$gapLower, 
                                                                      plotData_20_2$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$gapMean, plotData_30_3$gapLower, 
                                                                      plotData_30_3$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$gapMean, plotData_40_4$gapLower, 
                                                                      plotData_40_4$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$gapMean, plotData_50_5$gapLower, 
                                                                      plotData_50_5$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()





#############################
# r instances
allResults = list.files("results")

results_20_2 = data.frame(time = seq(10, 300, by = 10))
results_30_3 = data.frame(time = seq(10, 300, by = 10))
results_40_4 = data.frame(time = seq(10, 300, by = 10))
results_50_5 = data.frame(time = seq(10, 300, by = 10))

for (i in 1:length(allResults)) {
  if (grepl("r10", allResults[i])) {
    if (file.size(paste("results/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/", allResults[i], sep = ""), header = FALSE)
    if (nrow(data) > 30) data = data[1:30,]
    # remove weirdly high values
    data[data[,1]>10000,1] = NA
    data[data[,2]>=1,2] = NA
    if (nrow(data) < 30) {
      for (j in (nrow(data)+1):30) {
        data = rbind(data, c(data[nrow(data),1], 0))
      }
    }
    if (grepl("22_2", allResults[i])) {
      results_20_2 = cbind(results_20_2, data)
    }
    else if (grepl("32_3", allResults[i])) {
      results_30_3 = cbind(results_30_3, data)
    }
    else if (grepl("42_4", allResults[i])) {
      results_40_4 = cbind(results_40_4, data)
    }
    else if (grepl("52_5", allResults[i])) {
      results_50_5 = cbind(results_50_5, data)
    }
  }
}
require(ggplot2)
plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$distanceMean, plotData_20_2$distanceLower, 
                                                                      plotData_20_2$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$distanceMean, plotData_30_3$distanceLower, 
                                                                      plotData_30_3$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$distanceMean, plotData_40_4$distanceLower, 
                                                                      plotData_40_4$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$distanceMean, plotData_50_5$distanceLower, 
                                                                      plotData_50_5$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$gapMean, plotData_20_2$gapLower, 
                                                                      plotData_20_2$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$gapMean, plotData_30_3$gapLower, 
                                                                      plotData_30_3$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$gapMean, plotData_40_4$gapLower, 
                                                                      plotData_40_4$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$gapMean, plotData_50_5$gapLower, 
                                                                      plotData_50_5$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


###############################
# assess solomon colgen
###############################
allResults = list.files("results")

results_20_2 = data.frame(time = seq(10, 300, by = 10))
results_30_3 = data.frame(time = seq(10, 300, by = 10))
results_40_4 = data.frame(time = seq(10, 300, by = 10))
results_50_5 = data.frame(time = seq(10, 300, by = 10))

for (i in 1:length(allResults)) {
  if (grepl("c10", allResults[i])) {
    if (file.size(paste("results/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/", allResults[i], sep = ""), header = FALSE)
    if (nrow(data) > 30) data = data[1:30,]
    # remove weirdly high values
    data[data[,1]>10000,1] = NA
    data[data[,2]>=1,2] = NA
    if (nrow(data) < 30) {
      for (j in (nrow(data)+1):30) {
        data = rbind(data, c(data[nrow(data),1], 0))
      }
    }
    if (grepl("22_2", allResults[i])) {
      results_20_2 = cbind(results_20_2, data)
    }
    else if (grepl("32_3", allResults[i])) {
      results_30_3 = cbind(results_30_3, data)
    }
    else if (grepl("42_4", allResults[i])) {
      results_40_4 = cbind(results_40_4, data)
    }
    else if (grepl("52_5", allResults[i])) {
      results_50_5 = cbind(results_50_5, data)
    }
  }
}
require(ggplot2)
plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$distanceMean, plotData_20_2$distanceLower, 
                                                                      plotData_20_2$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$distanceMean, plotData_30_3$distanceLower, 
                                                                      plotData_30_3$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$distanceMean, plotData_40_4$distanceLower, 
                                                                      plotData_40_4$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$distanceMean, plotData_50_5$distanceLower, 
                                                                      plotData_50_5$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_distance.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$gapMean, plotData_20_2$gapLower, 
                                                                      plotData_20_2$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$gapMean, plotData_30_3$gapLower, 
                                                                      plotData_30_3$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$gapMean, plotData_40_4$gapLower, 
                                                                      plotData_40_4$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$gapMean, plotData_50_5$gapLower, 
                                                                      plotData_50_5$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_gap.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()





#############################
# r instances
allResults = list.files("results")

results_20_2 = data.frame(time = seq(10, 300, by = 10))
results_30_3 = data.frame(time = seq(10, 300, by = 10))
results_40_4 = data.frame(time = seq(10, 300, by = 10))
results_50_5 = data.frame(time = seq(10, 300, by = 10))

for (i in 1:length(allResults)) {
  if (grepl("r10", allResults[i])) {
    if (file.size(paste("results/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/", allResults[i], sep = ""), header = FALSE)
    if (nrow(data) > 30) data = data[1:30,]
    # remove weirdly high values
    data[data[,1]>10000,1] = NA
    data[data[,2]>=1,2] = NA
    if (nrow(data) < 30) {
      for (j in (nrow(data)+1):30) {
        data = rbind(data, c(data[nrow(data),1], 0))
      }
    }
    if (grepl("22_2", allResults[i])) {
      results_20_2 = cbind(results_20_2, data)
    }
    else if (grepl("32_3", allResults[i])) {
      results_30_3 = cbind(results_30_3, data)
    }
    else if (grepl("42_4", allResults[i])) {
      results_40_4 = cbind(results_40_4, data)
    }
    else if (grepl("52_5", allResults[i])) {
      results_50_5 = cbind(results_50_5, data)
    }
  }
}
require(ggplot2)
plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$distanceMean, plotData_20_2$distanceLower, 
                                                                      plotData_20_2$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$distanceMean, plotData_30_3$distanceLower, 
                                                                      plotData_30_3$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$distanceMean, plotData_40_4$distanceLower, 
                                                                      plotData_40_4$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$distanceMean, plotData_50_5$distanceLower, 
                                                                      plotData_50_5$distanceUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_distance_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

plotData_20_2 = data.frame(time = results_20_2[,1], 
                           distanceMean = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, mean), 
                           distanceLower = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, min), 
                           distanceUpper = apply(results_20_2[,seq(2, ncol(results_20_2), by = 2)], 1, max),
                           gapMean = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, mean),
                           gapLower = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, min), 
                           gapUpper = apply(results_20_2[,seq(3, ncol(results_20_2), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_20_2$time, 3), distance = c(plotData_20_2$gapMean, plotData_20_2$gapLower, 
                                                                      plotData_20_2$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_20_2_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_30_3 = data.frame(time = results_30_3[,1], 
                           distanceMean = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, mean), 
                           distanceLower = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, min), 
                           distanceUpper = apply(results_30_3[,seq(2, ncol(results_30_3), by = 2)], 1, max),
                           gapMean = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, mean),
                           gapLower = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, min), 
                           gapUpper = apply(results_30_3[,seq(3, ncol(results_30_3), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_30_3$time, 3), distance = c(plotData_30_3$gapMean, plotData_30_3$gapLower, 
                                                                      plotData_30_3$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_30_3_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()

plotData_40_4 = data.frame(time = results_40_4[,1], 
                           distanceMean = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, mean), 
                           distanceLower = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, min), 
                           distanceUpper = apply(results_40_4[,seq(2, ncol(results_40_4), by = 2)], 1, max),
                           gapMean = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, mean),
                           gapLower = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, min), 
                           gapUpper = apply(results_40_4[,seq(3, ncol(results_40_4), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_40_4$time, 3), distance = c(plotData_40_4$gapMean, plotData_40_4$gapLower, 
                                                                      plotData_40_4$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_40_4_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


plotData_50_5 = data.frame(time = results_50_5[,1], 
                           distanceMean = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, mean), 
                           distanceLower = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, min), 
                           distanceUpper = apply(results_50_5[,seq(2, ncol(results_50_5), by = 2)], 1, max),
                           gapMean = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, mean),
                           gapLower = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, min), 
                           gapUpper = apply(results_50_5[,seq(3, ncol(results_50_5), by = 2)], 1, max))

plotData = data.frame(time = rep(plotData_50_5$time, 3), distance = c(plotData_50_5$gapMean, plotData_50_5$gapLower, 
                                                                      plotData_50_5$gapUpper),
                      group = c(rep("Mean", 30), rep("Lower", 30), rep("Upper", 30)))

pdf("images/cplex_naive_solomon_50_5_gap_r.pdf")
ggplot(data = plotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Aggregation") + 
  xlab("Gap to lower bound in %") +
  ylab("Travel distance")
dev.off()


###############################
# assess solomon colgen
###############################
espptwcc_heur_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen/solomon")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/solomon/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_20 = cbind(espptwcc_heur_20, alignedData-200)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_30 = cbind(espptwcc_heur_30, alignedData-300)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_40 = cbind(espptwcc_heur_40, alignedData-400)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_50 = cbind(espptwcc_heur_50, alignedData-500)
    }
  }
}

spptwcc_heur_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen/solomon")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/solomon/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc_heur_20 = cbind(spptwcc_heur_20, alignedData-200)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc_heur_30 = cbind(spptwcc_heur_30, alignedData-300)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc_heur_40 = cbind(spptwcc_heur_40, alignedData-400)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc_heur_50 = cbind(spptwcc_heur_50, alignedData-500)
    }
  }
}

spptwcc_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen/solomon")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc", allResults[i])) {
    data = read.csv(paste("results/colgen/solomon/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc_20 = cbind(spptwcc_20, alignedData-200)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc_30 = cbind(spptwcc_30, alignedData-300)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc_40 = cbind(spptwcc_40, alignedData-400)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc_50 = cbind(spptwcc_50, alignedData-500)
    }
  }
}

spptwcc2_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen/solomon")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc2", allResults[i])) {
    data = read.csv(paste("results/colgen/solomon/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc2_20 = cbind(spptwcc2_20, alignedData-200)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc2_30 = cbind(spptwcc2_30, alignedData-300)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc2_40 = cbind(spptwcc2_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc2_50 = cbind(spptwcc2_50, alignedData)
    }
  }
}

spptwcc2_heur_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_heur_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_heur_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_heur_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen/solomon")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc2_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/solomon/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc2_heur_20 = cbind(spptwcc2_heur_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc2_heur_30 = cbind(spptwcc2_heur_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc2_heur_40 = cbind(spptwcc2_heur_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc2_heur_50 = cbind(spptwcc2_heur_50, alignedData)
    }
  }
}

espptwcc_heur_all = cbind(espptwcc_heur_20, espptwcc_heur_30[,-1], espptwcc_heur_40[,-1], espptwcc_heur_50[,-1])
spptwcc_all = cbind(spptwcc_20, spptwcc_30[,-1], spptwcc_40[,-1], spptwcc_50[,-1])
spptwcc_heur_all = cbind(spptwcc_heur_20, spptwcc_heur_30[,-1], spptwcc_heur_40[,-1], spptwcc_heur_50[,-1])
spptwcc2_all = cbind(spptwcc2_20, spptwcc2_30[,-1], spptwcc2_40[,-1], spptwcc2_50[,-1])
spptwcc2_heur_all = cbind(spptwcc2_heur_20, spptwcc2_heur_30[,-1], spptwcc2_heur_40[,-1], spptwcc2_heur_50[,-1])

# plot initial spp algorithms comparison
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_all[,seq(2, ncol(spptwcc_all), by = 2)], 1, mean),
                                             apply(spptwcc2_all[,seq(2, ncol(spptwcc2_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_all[,seq(2, ncol(espptwcc_heur_all), by = 2)], 1, mean),
                                             apply(spptwcc_heur_all[,seq(2, ncol(spptwcc_heur_all), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_all[,seq(2, ncol(spptwcc2_heur_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_all)),
                                          rep(2, nrow(spptwcc_all)),
                                          rep(3, nrow(spptwcc_heur_all)),
                                          rep(4, nrow(spptwcc2_all)),
                                          rep(5, nrow(spptwcc2_heur_all))))

pdf("images/solomon_sppComparison.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_all[,seq(3, ncol(spptwcc_all), by = 2)], 1, mean),
                                             apply(spptwcc2_all[,seq(3, ncol(spptwcc2_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_all[,seq(3, ncol(espptwcc_heur_all), by = 2)], 1, mean),
                                             apply(spptwcc_heur_all[,seq(3, ncol(spptwcc_heur_all), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_all[,seq(3, ncol(spptwcc2_heur_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_all)),
                                          rep(2, nrow(spptwcc_all)),
                                          rep(3, nrow(spptwcc_heur_all)),
                                          rep(4, nrow(spptwcc2_all)),
                                          rep(5, nrow(spptwcc2_heur_all))))

pdf("images/solomon_sppComparisonRelaxed.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()
