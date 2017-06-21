
depthFirst_30_20 = data.frame(time = seq(1, 600, by = 1))
depthFirst_30_30 = data.frame(time = seq(1, 600, by = 1))
depthFirst_30_40 = data.frame(time = seq(1, 600, by = 1))
depthFirst_30_50 = data.frame(time = seq(1, 600, by = 1))
allResults = list.files("results/colgen/framework")
for (i in 1:length(allResults)) {
  if (grepl("600depth first", allResults[i])) {
    data = read.csv(paste("results/colgen/framework/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(relaxed = numeric(600), integer = numeric(600))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      depthFirst_30_20 = cbind(depthFirst_30_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      depthFirst_30_30 = cbind(depthFirst_30_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      depthFirst_30_40 = cbind(depthFirst_30_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      depthFirst_30_50 = cbind(depthFirst_30_50, alignedData)
    }
  }
}


stabilized_20 = data.frame(time = seq(1, 600, by = 1))
stabilized_30 = data.frame(time = seq(1, 600, by = 1))
stabilized_40 = data.frame(time = seq(1, 600, by = 1))
stabilized_50 = data.frame(time = seq(1, 600, by = 1))
allResults = list.files("results/colgen/stabilized100")
for (i in 1:length(allResults)) {
  if (grepl("600depth first", allResults[i])) {
    if (grepl("Summary", allResults[i])) next
    data = read.csv(paste("results/colgen/stabilized100/", allResults[i], sep = ""), header = FALSE)
    data[data > 1000000] = NA
    alignedData = data.frame(relaxed = numeric(600), integer = numeric(600))
    for (j in 1:nrow(alignedData)) {
      if (sum(data[,1] < j) == 0) {
        alignedData[j,1] = max(na.omit(data[,2]))
        alignedData[j,2] = max(na.omit(data[,3]))
      }
      else alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      stabilized_20 = cbind(stabilized_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      stabilized_30 = cbind(stabilized_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      stabilized_40 = cbind(stabilized_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      stabilized_50 = cbind(stabilized_50, alignedData)
    }
  }
}

# plot results for normal colgen with 30s branching time window and depth-first search

aggregatedPlotData = data.frame(time = rep(depthFirst_30_20[,1], 4),
                                distance = c(unlist(apply(depthFirst_30_20[,seq(3, ncol(depthFirst_30_20), by = 2)], 1, function(x) {mean(na.omit(x))})),
                                             unlist(apply(depthFirst_30_30[,seq(3, ncol(depthFirst_30_30), by = 2)], 1, function(x) {mean(na.omit(x))})),
                                             unlist(apply(depthFirst_30_40[,seq(3, ncol(depthFirst_30_40), by = 2)], 1, function(x) {mean(na.omit(x))})),
                                             unlist(apply(depthFirst_30_50[,seq(3, ncol(depthFirst_30_50), by = 2)], 1, function(x) {mean(na.omit(x))}))),
                                group = c(rep(1, nrow(depthFirst_30_20)),
                                          rep(2, nrow(depthFirst_30_30)),
                                          rep(3, nrow(depthFirst_30_40)),
                                          rep(4, nrow(depthFirst_30_50))))

aggregatedPlotData[aggregatedPlotData[,3] == 1,2] = aggregatedPlotData[aggregatedPlotData[,3] == 1,2]/max(na.omit(aggregatedPlotData[aggregatedPlotData[,3] == 1,2]))
aggregatedPlotData[aggregatedPlotData[,3] == 2,2] = aggregatedPlotData[aggregatedPlotData[,3] == 2,2]/max(na.omit(aggregatedPlotData[aggregatedPlotData[,3] == 2,2]))
aggregatedPlotData[aggregatedPlotData[,3] == 3,2] = aggregatedPlotData[aggregatedPlotData[,3] == 3,2]/max(na.omit(aggregatedPlotData[aggregatedPlotData[,3] == 3,2]))
aggregatedPlotData[aggregatedPlotData[,3] == 4,2] = aggregatedPlotData[aggregatedPlotData[,3] == 4,2]/max(na.omit(aggregatedPlotData[aggregatedPlotData[,3] == 4,2]))


pdf("images/depthFirst_600s.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("20 customers", "30 customers", "40 customers", "50 customers")) + 
  xlab("Computation time in s") +
  ylab("Normalized costs")+ guides(colour = guide_legend(nrow = 2))
dev.off()

######
# comparison between normal column generation and stabilized

# 20 customers
aggregatedPlotData = data.frame(time = rep(depthFirst_30_20[,1], 2),
                                distance = c(apply(depthFirst_30_20[,seq(3, ncol(depthFirst_30_20), by = 2)], 1, mean),
                                             apply(stabilized_20[,seq(3, ncol(stabilized_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(depthFirst_30_20)),
                                          rep(2, nrow(stabilized_20))))

pdf("images/colgenComp_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Column generation", "Stabilized cutting planes")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 30 customers
aggregatedPlotData = data.frame(time = rep(depthFirst_30_30[,1], 2),
                                distance = c(apply(depthFirst_30_30[,seq(3, ncol(depthFirst_30_30), by = 2)], 1, mean),
                                             apply(stabilized_30[,seq(3, ncol(stabilized_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(depthFirst_30_30)),
                                          rep(2, nrow(stabilized_30))))

pdf("images/colgenComp_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Column generation", "Stabilized cutting planes")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(depthFirst_30_40[,1], 2),
                                distance = c(apply(depthFirst_30_40[,seq(3, ncol(depthFirst_30_40), by = 2)], 1, mean),
                                             apply(stabilized_40[,seq(3, ncol(stabilized_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(depthFirst_30_40)),
                                          rep(2, nrow(stabilized_40))))

pdf("images/colgenComp_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Column generation", "Stabilized cutting planes")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(depthFirst_30_50[,1], 2),
                                distance = c(apply(depthFirst_30_50[,seq(3, ncol(depthFirst_30_50), by = 2)], 1, mean),
                                             apply(stabilized_50[,seq(3, ncol(stabilized_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(depthFirst_30_50)),
                                          rep(2, nrow(stabilized_50))))

pdf("images/colgenComp_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Column generation", "Stabilized cutting planes")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()