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