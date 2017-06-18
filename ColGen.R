data_espptwcc_heuristic = read.csv("results/colgenespptwcc_heur.csv", header = FALSE)

plotData = data.frame(time = rep(data_espptwcc_heuristic[,1],2), results = c(integer = data_espptwcc_heuristic[,2],relaxed = data_espptwcc_heuristic[,3]),
                      groups = c(rep("Integer solution", nrow(data_espptwcc_heuristic)), rep("Relaxed solution", nrow(data_espptwcc_heuristic))))

require(ggplot2)
pdf("images/colgen_oneIt_ESPPTWCC_heuristic.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "") + 
  xlim(c(0,300)) +
  ylim(c(20000,80000)) +
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

data_spptwcc = read.csv("results/colgenspptwcc.csv", header = FALSE)
plotData = data.frame(time = rep(data_spptwcc[,1],2), results = c(integer = data_spptwcc[,2],relaxed = data_spptwcc[,3]),
                      groups = c(rep("Integer solution", nrow(data_spptwcc)), rep("Relaxed solution", nrow(data_spptwcc))))

require(ggplot2)
pdf("images/colgen_oneIt_SPPTWCC.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "") + 
  xlim(c(0,300)) +
  ylim(c(20000,80000)) +
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()



data_spptwcc2 = read.csv("results/colgenspptwcc2.csv", header = FALSE)
plotData = data.frame(time = rep(data_spptwcc2[,1],2), results = c(integer = data_spptwcc2[,2],relaxed = data_spptwcc2[,3]),
                      groups = c(rep("Integer solution", nrow(data_spptwcc2)), rep("Relaxed solution", nrow(data_spptwcc2))))

require(ggplot2)
pdf("images/colgen_oneIt_SPPTWCC2.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "") + 
  xlim(c(0,300)) +
  ylim(c(20000,80000)) +
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()



data_spptwcc2_heuristic = read.csv("results/colgenspptwcc2_heur.csv", header = FALSE)
plotData = data.frame(time = rep(data_spptwcc2_heuristic[,1],2), results = c(integer = data_spptwcc2_heuristic[,2],relaxed = data_spptwcc2_heuristic[,3]),
                      groups = c(rep("Integer solution", nrow(data_spptwcc2_heuristic)), rep("Relaxed solution", nrow(data_spptwcc2_heuristic))))

require(ggplot2)
pdf("images/colgen_oneIt_SPPTWCC2_heuristic.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "") + 
  xlim(c(0,300)) +
  ylim(c(20000,80000)) +
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


data_spptwcc_heuristic = read.csv("results/colgenspptwcc_heur.csv", header = FALSE)
plotData = data.frame(time = rep(data_spptwcc_heuristic[,1],2), results = c(integer = data_spptwcc_heuristic[,2],relaxed = data_spptwcc_heuristic[,3]),
                      groups = c(rep("Integer solution", nrow(data_spptwcc_heuristic)), rep("Relaxed solution", nrow(data_spptwcc_heuristic))))

require(ggplot2)
pdf("images/colgen_oneIt_SPPTWCC_heuristic.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "") + 
  xlim(c(0,300)) +
  ylim(c(20000,80000)) +
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# fuse all data

timeStamps = c(data_spptwcc[,1], data_spptwcc2[,1], data_spptwcc_heuristic[,1], data_spptwcc2_heuristic[,1],
               data_espptwcc_heuristic[,1])
timeStamps = as.data.frame(cbind(time = as.numeric(timeStamps), 
                                 groups = c(rep(1, length(data_spptwcc[,1])), rep(2, length(data_spptwcc2[,1])), 
                                            rep(3, length(data_spptwcc_heuristic[,1])), rep(4, length(data_spptwcc2_heuristic[,1])), 
                                            rep(5, length(data_espptwcc_heuristic[,1])))))
timeStamps = timeStamps[sort.int(timeStamps[,1], index.return = TRUE)$ix,]
results = numeric(nrow(timeStamps))
for (i in 1:nrow(timeStamps)) {
  if (timeStamps[i,2] == 1) {
    results[i] = data_spptwcc[which(data_spptwcc[,1] == timeStamps[i,1]),2]
  }
  else if (timeStamps[i,2] == 2) {
    results[i] = data_spptwcc2[which(data_spptwcc2[,1] == timeStamps[i,1]),2]
  }
  else if (timeStamps[i,2] == 3) {
    results[i] = data_spptwcc_heuristic[which(data_spptwcc_heuristic[,1] == timeStamps[i,1]),2]
  }
  else if (timeStamps[i,2] == 4) {
    results[i] = data_spptwcc2_heuristic[which(data_spptwcc2_heuristic[,1] == timeStamps[i,1]),2]
  }
  else {
    results[i] = data_espptwcc_heuristic[which(data_espptwcc_heuristic[,1] == timeStamps[i,1]),2]
  }
}

plotData = as.data.frame(cbind(timeStamps, results))
colnames(plotData) = c("time", "groups", "result")
require(ggplot2)
options(scipen=10000)
pdf("images/colgen_oneIt_comparison.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 14), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", labels = c("SPPTWCC", "SPPTWCC2", "SPPTWCC_HEUR", "SPPTWCC2_HEUR", "ESPPTWCC_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance") + guides(colour = guide_legend(nrow = 2))
dev.off()

# compare espptwcc_heur with and without initial fp solution
data_espptwcc_heuristic = read.csv("results/colgenespptwcc_heur.csv", header = FALSE)
data_espptwcc_heuristic_fp = read.csv("results/colgenespptwcc_heur_fpInitial.csv", header = FALSE)
timeStamps = c(data_espptwcc_heuristic[,1], data_espptwcc_heuristic_fp[,1])
timeStamps = as.data.frame(cbind(time = as.numeric(timeStamps), 
                                 groups = c(rep(1, length(data_espptwcc_heuristic[,1])), rep(2, length(data_espptwcc_heuristic_fp[,1])))))
timeStamps = timeStamps[sort.int(timeStamps[,1], index.return = TRUE)$ix,]

results = numeric(nrow(timeStamps))
for (i in 1:nrow(timeStamps)) {
  if (timeStamps[i,2] == 1) {
    results[i] = data_espptwcc_heuristic[which(data_espptwcc_heuristic[,1] == timeStamps[i,1]),2]
  }
  else {
    results[i] = data_espptwcc_heuristic_fp[which(data_espptwcc_heuristic_fp[,1] == timeStamps[i,1]),2]
  }
}

plotData = as.data.frame(cbind(timeStamps, results))
colnames(plotData) = c("time", "groups", "result")

options(scipen=10000)
pdf("images/colgen_espptwcc_heur_initialComparison.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", labels = c("Dummy initial paths", "Flaschenpost initial paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


# compare espptwcc_heur with initial fp solution with different numbers of paths returned

data_espptwcc_heuristic_fp_1path = read.csv("results/colgenespptwcc_heur_fpInitial.csv", header = FALSE)
data_espptwcc_heuristic_fp_10paths = read.csv("results/colgenespptwcc_heur_fpInitial_10paths.csv", header = FALSE)
data_espptwcc_heuristic_fp_20paths = read.csv("results/colgenespptwcc_heur_fpInitial_20paths.csv", header = FALSE)

timeStamps = c(data_espptwcc_heuristic_fp_1path[,1], data_espptwcc_heuristic_fp_10paths[,1], data_espptwcc_heuristic_fp_20paths[,1])
timeStamps = as.data.frame(cbind(time = as.numeric(timeStamps), 
                                 groups = c(rep(1, length(data_espptwcc_heuristic_fp_1path[,1])), rep(2, length(data_espptwcc_heuristic_fp_10paths[,1])),
                                            rep(3, length(data_espptwcc_heuristic_fp_20paths[,1])))))
timeStamps = timeStamps[sort.int(timeStamps[,1], index.return = TRUE)$ix,]

results = numeric(nrow(timeStamps))
for (i in 1:nrow(timeStamps)) {
  if (timeStamps[i,2] == 1) {
    results[i] = data_espptwcc_heuristic_fp_1path[which(data_espptwcc_heuristic_fp_1path[,1] == timeStamps[i,1]),2]
  }
  else if (timeStamps[i,2] == 2) {
    results[i] = data_espptwcc_heuristic_fp_10paths[which(data_espptwcc_heuristic_fp_10paths[,1] == timeStamps[i,1]),2]
  }
  else {
    results[i] = data_espptwcc_heuristic_fp_20paths[which(data_espptwcc_heuristic_fp_20paths[,1] == timeStamps[i,1]),2]
  }
}

plotData = as.data.frame(cbind(timeStamps, results))

options(scipen=10000)
pdf("images/colgen_espptwcc_heur_pathsReturnedComparison.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", labels = c("1 path", "10 paths", "20 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


# compare espptwcc_heur with initial fp solution with recomputation vs without
data_espptwcc_heuristic_fp = read.csv("results/colgenespptwcc_heur_fpInitial.csv", header = FALSE)
data_espptwcc_heuristic_fp_reco = read.csv("results/colgenespptwcc_heur_fp_recomp.csv", header = FALSE)

timeStamps = c(data_espptwcc_heuristic_fp[,1], data_espptwcc_heuristic_fp_reco[,1])
timeStamps = as.data.frame(cbind(time = as.numeric(timeStamps), 
                                 groups = c(rep(1, length(data_espptwcc_heuristic_fp[,1])), rep(2, length(data_espptwcc_heuristic_fp_reco[,1])))))
timeStamps = timeStamps[sort.int(timeStamps[,1], index.return = TRUE)$ix,]

results = numeric(nrow(timeStamps))
for (i in 1:nrow(timeStamps)) {
  if (timeStamps[i,2] == 1) {
    results[i] = data_espptwcc_heuristic_fp[which(data_espptwcc_heuristic_fp[,1] == timeStamps[i,1]),2]
  }
  else {
    results[i] = data_espptwcc_heuristic_fp_reco[which(data_espptwcc_heuristic_fp_reco[,1] == timeStamps[i,1]),2]
  }
}

plotData = as.data.frame(cbind(timeStamps, results))

options(scipen=10000)
pdf("images/colgen_espptwcc_heur_fp_reco.pdf")
ggplot(data = plotData, aes(x = time, y = results, group = groups, colour = as.factor(groups))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", labels = c("No recomputation", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


# plot development of euclidian distance of dual variables to their optima
dualsFp = read.csv("results/colgenespptwcc_heur_fp_duals.csv", header = FALSE)
dualsFp = dualsFp[,-ncol(dualsFp)]
optimaFp = dualsFp[nrow(dualsFp),]
distanceFp = numeric(nrow(dualsFp))
for (i in 1:nrow(dualsFp)) {
  temp = 0
  for (j in 2:ncol(dualsFp)) {
    temp = temp + as.numeric((dualsFp[i,j]-optimaFp[j])^2)
  }
  temp = sqrt(temp)
  distanceFp[i] = temp
}


duals = read.csv("results/colgenespptwcc_heur_duals.csv", header = FALSE)
duals = duals[,-ncol(duals)]
optima = duals[nrow(duals),]
distance = numeric(nrow(duals))
for (i in 1:nrow(duals)) {
  temp = 0
  for (j in 2:ncol(duals)) {
    temp = temp + as.numeric((duals[i,j]-optima[j])^2)
  }
  temp = sqrt(temp)
  distance[i] = temp
}

plot(duals[,1], distance)
points(dualsFp[,1], distanceFp, col = "red")

plot(dualsFp[,1], dualsFp[,7])

########################################################
# test cases
espptwcc_heur_fp_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("espptwcc_heur_fp", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_20 = cbind(espptwcc_heur_fp_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_30 = cbind(espptwcc_heur_fp_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_40 = cbind(espptwcc_heur_fp_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_50 = cbind(espptwcc_heur_fp_50, alignedData)
    }
  }
}

espptwcc_heur_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_20 = cbind(espptwcc_heur_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_30 = cbind(espptwcc_heur_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_40 = cbind(espptwcc_heur_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_50 = cbind(espptwcc_heur_50, alignedData)
    }
  }
}

spptwcc_heur_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc_heur_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc_heur_20 = cbind(spptwcc_heur_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc_heur_30 = cbind(spptwcc_heur_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc_heur_40 = cbind(spptwcc_heur_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc_heur_50 = cbind(spptwcc_heur_50, alignedData)
    }
  }
}

spptwcc_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc_20 = cbind(spptwcc_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc_30 = cbind(spptwcc_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      spptwcc_40 = cbind(spptwcc_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      spptwcc_50 = cbind(spptwcc_50, alignedData)
    }
  }
}

spptwcc2_20 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_30 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_40 = data.frame(time = seq(1, 180, by = 1))
spptwcc2_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc2", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      spptwcc2_20 = cbind(spptwcc2_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      spptwcc2_30 = cbind(spptwcc2_30, alignedData)
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
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_spptwcc2_heur", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
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

espptwcc_heur_fp_5paths_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_5paths_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_5paths_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_5paths_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_5paths", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_5paths_20 = cbind(espptwcc_heur_fp_5paths_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_5paths_30 = cbind(espptwcc_heur_fp_5paths_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_5paths_40 = cbind(espptwcc_heur_fp_5paths_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_5paths_50 = cbind(espptwcc_heur_fp_5paths_50, alignedData)
    }
  }
}

espptwcc_heur_fp_10paths_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_10paths_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_10paths_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_10paths_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_10paths", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_10paths_20 = cbind(espptwcc_heur_fp_10paths_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_10paths_30 = cbind(espptwcc_heur_fp_10paths_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_10paths_40 = cbind(espptwcc_heur_fp_10paths_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_10paths_50 = cbind(espptwcc_heur_fp_10paths_50, alignedData)
    }
  }
}

espptwcc_heur_fp_20paths_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_20paths_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_20paths_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_20paths_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_20paths", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_20paths_20 = cbind(espptwcc_heur_fp_20paths_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_20paths_30 = cbind(espptwcc_heur_fp_20paths_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_20paths_40 = cbind(espptwcc_heur_fp_20paths_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_20paths_50 = cbind(espptwcc_heur_fp_20paths_50, alignedData)
    }
  }
}

espptwcc_heur_fp_50paths_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_50paths", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_50paths_20 = cbind(espptwcc_heur_fp_50paths_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_50paths_30 = cbind(espptwcc_heur_fp_50paths_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_50paths_40 = cbind(espptwcc_heur_fp_50paths_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_50paths_50 = cbind(espptwcc_heur_fp_50paths_50, alignedData)
    }
  }
}

espptwcc_heur_fp_recomp_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_recomp_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_recomp_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_recomp_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_recomp", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_recomp_20 = cbind(espptwcc_heur_fp_recomp_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_recomp_30 = cbind(espptwcc_heur_fp_recomp_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_recomp_40 = cbind(espptwcc_heur_fp_recomp_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_recomp_50 = cbind(espptwcc_heur_fp_recomp_50, alignedData)
    }
  }
}

espptwcc_heur_fp_50paths_box_20 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_box_30 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_box_40 = data.frame(time = seq(1, 180, by = 1))
espptwcc_heur_fp_50paths_box_50 = data.frame(time = seq(1, 180, by = 1))
allResults = list.files("results/colgen")
for (i in 1:length(allResults)) {
  if (grepl("_espptwcc_heur_fp_50paths_box", allResults[i])) {
    data = read.csv(paste("results/colgen/", allResults[i], sep = ""), header = FALSE)
    alignedData = data.frame(integer = numeric(180), relaxed = numeric(180))
    for (j in 1:nrow(alignedData)) {
      alignedData[j,] = data[which((data[data[,1] < j,1]-j) == max(data[data[,1] < j,1]-j)),2:3]
    }
    if (grepl("_20_", allResults[i])) {
      espptwcc_heur_fp_50paths_box_20 = cbind(espptwcc_heur_fp_50paths_box_20, alignedData)
    }
    else if (grepl("_30_", allResults[i])) {
      espptwcc_heur_fp_50paths_box_30 = cbind(espptwcc_heur_fp_50paths_box_30, alignedData)
    }
    else if (grepl("_40_", allResults[i])) {
      espptwcc_heur_fp_50paths_box_40 = cbind(espptwcc_heur_fp_50paths_box_40, alignedData)
    }
    else if (grepl("_50_", allResults[i])) {
      espptwcc_heur_fp_50paths_box_50 = cbind(espptwcc_heur_fp_50paths_box_50, alignedData)
    }
  }
}


espptwcc_heur_fp_all = cbind(espptwcc_heur_fp_20, espptwcc_heur_fp_30[,-1], espptwcc_heur_fp_40[,-1], espptwcc_heur_fp_50[,-1])
espptwcc_heur_all = cbind(espptwcc_heur_20, espptwcc_heur_30[,-1], espptwcc_heur_40[,-1], espptwcc_heur_50[,-1])
spptwcc_all = cbind(spptwcc_20, spptwcc_30[,-1], spptwcc_40[,-1], spptwcc_50[,-1])
spptwcc_heur_all = cbind(spptwcc_heur_20, spptwcc_heur_30[,-1], spptwcc_heur_40[,-1], spptwcc_heur_50[,-1])
spptwcc2_all = cbind(spptwcc2_20, spptwcc2_30[,-1], spptwcc2_40[,-1], spptwcc2_50[,-1])
spptwcc2_heur_all = cbind(spptwcc2_heur_20, spptwcc2_heur_30[,-1], spptwcc2_heur_40[,-1], spptwcc2_heur_50[,-1])
espptwcc_heur_fp_5paths_all = cbind(espptwcc_heur_fp_5paths_20, espptwcc_heur_fp_5paths_30[,-1], espptwcc_heur_fp_5paths_40[,-1], espptwcc_heur_fp_5paths_50[,-1])
espptwcc_heur_fp_10paths_all = cbind(espptwcc_heur_fp_10paths_20, espptwcc_heur_fp_10paths_30[,-1], espptwcc_heur_fp_10paths_40[,-1], espptwcc_heur_fp_10paths_50[,-1])
espptwcc_heur_fp_20paths_all = cbind(espptwcc_heur_fp_20paths_20, espptwcc_heur_fp_20paths_30[,-1], espptwcc_heur_fp_20paths_40[,-1], espptwcc_heur_fp_20paths_50[,-1])
espptwcc_heur_fp_50paths_all = cbind(espptwcc_heur_fp_50paths_20, espptwcc_heur_fp_50paths_30[,-1], espptwcc_heur_fp_50paths_40[,-1], espptwcc_heur_fp_50paths_50[,-1])
espptwcc_heur_fp_recomp_all = cbind(espptwcc_heur_fp_recomp_20, espptwcc_heur_fp_recomp_30[,-1], espptwcc_heur_fp_recomp_40[,-1], espptwcc_heur_fp_recomp_50[,-1])
espptwcc_heur_fp_50paths_box_all = cbind(espptwcc_heur_fp_50paths_box_20, espptwcc_heur_fp_50paths_box_30[,-1], espptwcc_heur_fp_50paths_box_40[,-1], espptwcc_heur_fp_50paths_box_50[,-1])

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

pdf("images/sppComparison1.pdf")
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

pdf("images/sppComparisonRelaxed1.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# plot dummy initial vs. flaschenpost initial
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 2),
                                distance = c(apply(espptwcc_heur_all[,seq(2, ncol(espptwcc_heur_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_all[,seq(2, ncol(espptwcc_heur_fp_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_all)),
                                          rep(2, nrow(espptwcc_heur_fp_all))))

pdf("images/sppComparison2.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 2),
                                distance = c(apply(espptwcc_heur_all[,seq(3, ncol(espptwcc_heur_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_all[,seq(3, ncol(espptwcc_heur_fp_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_all)),
                                          rep(2, nrow(espptwcc_heur_fp_all))))

pdf("images/sppComparisonRelaxed2.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# plot different paths returned

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_all[,seq(2, ncol(espptwcc_heur_fp_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_all[,seq(2, ncol(espptwcc_heur_fp_5paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_all[,seq(2, ncol(espptwcc_heur_fp_10paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_all[,seq(2, ncol(espptwcc_heur_fp_20paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_all[,seq(2, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_all)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_all)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_all)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_all)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_all))))

pdf("images/sppComparison3.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_all[,seq(3, ncol(espptwcc_heur_fp_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_all[,seq(3, ncol(espptwcc_heur_fp_5paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_all[,seq(3, ncol(espptwcc_heur_fp_10paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_all[,seq(3, ncol(espptwcc_heur_fp_20paths_all), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_all[,seq(3, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_all)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_all)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_all)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_all)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_all))))

pdf("images/sppComparisonRelaxed3.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# plot 20 paths returned vs. recomputation
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_all[,seq(2, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_all[,seq(2, ncol(espptwcc_heur_fp_recomp_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_all)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_all))))

pdf("images/sppComparison4.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_all[,seq(3, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_all[,seq(3, ncol(espptwcc_heur_fp_recomp_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_all)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_all))))

pdf("images/sppComparisonRelaxed4.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# plot box method vs. non-box method
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_all[,seq(2, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_all[,seq(2, ncol(espptwcc_heur_fp_50paths_box_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_all)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_all))))

pdf("images/sppComparison5.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_all[,seq(3, ncol(espptwcc_heur_fp_50paths_all), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_all[,seq(3, ncol(espptwcc_heur_fp_50paths_box_all), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_all)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_all))))

pdf("images/sppComparisonRelaxed5.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()


#########################
# plot test cases dependent on problem size
#########################
# plot initial spp algorithms comparison
# 20 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_20[,seq(2, ncol(spptwcc_20), by = 2)], 1, mean),
                                             apply(spptwcc2_20[,seq(2, ncol(spptwcc2_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_20[,seq(2, ncol(espptwcc_heur_20), by = 2)], 1, mean),
                                             apply(spptwcc_heur_20[,seq(2, ncol(spptwcc_heur_20), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_20[,seq(2, ncol(spptwcc2_heur_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_20)),
                                          rep(2, nrow(spptwcc2_20)),
                                          rep(3, nrow(espptwcc_heur_20)),
                                          rep(4, nrow(spptwcc_heur_20)),
                                          rep(5, nrow(spptwcc2_heur_20))))

pdf("images/sppComparison1_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_20[,seq(3, ncol(spptwcc_20), by = 2)], 1, mean),
                                             apply(spptwcc2_20[,seq(3, ncol(spptwcc2_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_20[,seq(3, ncol(espptwcc_heur_20), by = 2)], 1, mean),
                                             apply(spptwcc_heur_20[,seq(3, ncol(spptwcc_heur_20), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_20[,seq(3, ncol(spptwcc2_heur_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_20)),
                                          rep(2, nrow(spptwcc2_20)),
                                          rep(3, nrow(espptwcc_heur_20)),
                                          rep(4, nrow(spptwcc_heur_20)),
                                          rep(5, nrow(spptwcc2_heur_20))))

pdf("images/sppComparisonRelaxed1_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 30 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_30[,seq(2, ncol(spptwcc_30), by = 2)], 1, mean),
                                             apply(spptwcc2_30[,seq(2, ncol(spptwcc2_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_30[,seq(2, ncol(espptwcc_heur_30), by = 2)], 1, mean),
                                             apply(spptwcc_heur_30[,seq(2, ncol(spptwcc_heur_30), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_30[,seq(2, ncol(spptwcc2_heur_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_30)),
                                          rep(2, nrow(spptwcc2_30)),
                                          rep(3, nrow(espptwcc_heur_30)),
                                          rep(4, nrow(spptwcc_heur_30)),
                                          rep(5, nrow(spptwcc2_heur_30))))

pdf("images/sppComparison1_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_30[,seq(3, ncol(spptwcc_30), by = 2)], 1, mean),
                                             apply(spptwcc2_30[,seq(3, ncol(spptwcc2_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_30[,seq(3, ncol(espptwcc_heur_30), by = 2)], 1, mean),
                                             apply(spptwcc_heur_30[,seq(3, ncol(spptwcc_heur_30), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_30[,seq(3, ncol(spptwcc2_heur_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_30)),
                                          rep(2, nrow(spptwcc2_30)),
                                          rep(3, nrow(espptwcc_heur_30)),
                                          rep(4, nrow(spptwcc_heur_30)),
                                          rep(5, nrow(spptwcc2_heur_30))))

pdf("images/sppComparisonRelaxed1_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_40[,seq(2, ncol(spptwcc_40), by = 2)], 1, mean),
                                             apply(spptwcc2_40[,seq(2, ncol(spptwcc2_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_40[,seq(2, ncol(espptwcc_heur_40), by = 2)], 1, mean),
                                             apply(spptwcc_heur_40[,seq(2, ncol(spptwcc_heur_40), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_40[,seq(2, ncol(spptwcc2_heur_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_40)),
                                          rep(2, nrow(spptwcc2_40)),
                                          rep(3, nrow(espptwcc_heur_40)),
                                          rep(4, nrow(spptwcc_heur_40)),
                                          rep(5, nrow(spptwcc2_heur_40))))

pdf("images/sppComparison1_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_40[,seq(3, ncol(spptwcc_40), by = 2)], 1, mean),
                                             apply(spptwcc2_40[,seq(3, ncol(spptwcc2_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_40[,seq(3, ncol(espptwcc_heur_40), by = 2)], 1, mean),
                                             apply(spptwcc_heur_40[,seq(3, ncol(spptwcc_heur_40), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_40[,seq(3, ncol(spptwcc2_heur_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_40)),
                                          rep(2, nrow(spptwcc2_40)),
                                          rep(3, nrow(espptwcc_heur_40)),
                                          rep(4, nrow(spptwcc_heur_40)),
                                          rep(5, nrow(spptwcc2_heur_40))))

pdf("images/sppComparisonRelaxed1_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 50 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_50[,seq(2, ncol(spptwcc_50), by = 2)], 1, mean),
                                             apply(spptwcc2_50[,seq(2, ncol(spptwcc2_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_50[,seq(2, ncol(espptwcc_heur_50), by = 2)], 1, mean),
                                             apply(spptwcc_heur_50[,seq(2, ncol(spptwcc_heur_50), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_50[,seq(2, ncol(spptwcc2_heur_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_50)),
                                          rep(2, nrow(spptwcc2_50)),
                                          rep(3, nrow(espptwcc_heur_50)),
                                          rep(4, nrow(spptwcc_heur_50)),
                                          rep(5, nrow(spptwcc2_heur_50))))

pdf("images/sppComparison1_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_all[,1], 5),
                                distance = c(apply(spptwcc_50[,seq(3, ncol(spptwcc_50), by = 2)], 1, mean),
                                             apply(spptwcc2_50[,seq(3, ncol(spptwcc2_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_50[,seq(3, ncol(espptwcc_heur_50), by = 2)], 1, mean),
                                             apply(spptwcc_heur_50[,seq(3, ncol(spptwcc_heur_50), by = 2)], 1, mean),
                                             apply(spptwcc2_heur_50[,seq(3, ncol(spptwcc2_heur_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(spptwcc_50)),
                                          rep(2, nrow(spptwcc2_50)),
                                          rep(3, nrow(espptwcc_heur_50)),
                                          rep(4, nrow(spptwcc_heur_50)),
                                          rep(5, nrow(spptwcc2_heur_50))))

pdf("images/sppComparisonRelaxed1_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("SPPTWCC", "SPPTWCC2", "ESPPTWCC_HEUR", "SPPTWCC_HEUR", "SPPTWCC2_HEUR")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# plot with and without FP initial solution
# 20 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 2),
                                distance = c(apply(espptwcc_heur_20[,seq(2, ncol(espptwcc_heur_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20[,seq(2, ncol(espptwcc_heur_fp_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_20)),
                                          rep(2, nrow(espptwcc_heur_fp_20))))

pdf("images/sppComparison2_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 2),
                                distance = c(apply(espptwcc_heur_20[,seq(3, ncol(espptwcc_heur_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20[,seq(3, ncol(espptwcc_heur_fp_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_20)),
                                          rep(2, nrow(espptwcc_heur_fp_20))))

pdf("images/sppComparisonRelaxed2_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

#30 customers 
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 2),
                                distance = c(apply(espptwcc_heur_30[,seq(2, ncol(espptwcc_heur_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_30[,seq(2, ncol(espptwcc_heur_fp_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_30)),
                                          rep(2, nrow(espptwcc_heur_fp_30))))

pdf("images/sppComparison2_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 2),
                                distance = c(apply(espptwcc_heur_30[,seq(3, ncol(espptwcc_heur_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_30[,seq(3, ncol(espptwcc_heur_fp_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_30)),
                                          rep(2, nrow(espptwcc_heur_fp_30))))

pdf("images/sppComparisonRelaxed2_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 2),
                                distance = c(apply(espptwcc_heur_40[,seq(2, ncol(espptwcc_heur_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_40[,seq(2, ncol(espptwcc_heur_fp_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_40)),
                                          rep(2, nrow(espptwcc_heur_fp_40))))

pdf("images/sppComparison2_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 2),
                                distance = c(apply(espptwcc_heur_40[,seq(3, ncol(espptwcc_heur_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_40[,seq(3, ncol(espptwcc_heur_fp_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_40)),
                                          rep(2, nrow(espptwcc_heur_fp_40))))

pdf("images/sppComparisonRelaxed2_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# 50 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 2),
                                distance = c(apply(espptwcc_heur_50[,seq(2, ncol(espptwcc_heur_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50[,seq(2, ncol(espptwcc_heur_fp_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_50)),
                                          rep(2, nrow(espptwcc_heur_fp_50))))

pdf("images/sppComparison2_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 2),
                                distance = c(apply(espptwcc_heur_50[,seq(3, ncol(espptwcc_heur_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50[,seq(3, ncol(espptwcc_heur_fp_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_50)),
                                          rep(2, nrow(espptwcc_heur_fp_50))))

pdf("images/sppComparisonRelaxed2_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("Without FP solution", "With FP solution")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()


# plot different paths returned
# 20 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_20[,seq(2, ncol(espptwcc_heur_fp_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_20[,seq(2, ncol(espptwcc_heur_fp_5paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_20[,seq(2, ncol(espptwcc_heur_fp_10paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_20[,seq(2, ncol(espptwcc_heur_fp_20paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_20[,seq(2, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_20)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_20)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_20)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_20))))

pdf("images/sppComparison3_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_20[,seq(3, ncol(espptwcc_heur_fp_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_20[,seq(3, ncol(espptwcc_heur_fp_5paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_20[,seq(3, ncol(espptwcc_heur_fp_10paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_20[,seq(3, ncol(espptwcc_heur_fp_20paths_20), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_20[,seq(3, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_20)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_20)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_20)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_20))))

pdf("images/sppComparisonRelaxed3_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# 30 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_30[,seq(2, ncol(espptwcc_heur_fp_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_30[,seq(2, ncol(espptwcc_heur_fp_5paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_30[,seq(2, ncol(espptwcc_heur_fp_10paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_30[,seq(2, ncol(espptwcc_heur_fp_20paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_30[,seq(2, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_30)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_30)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_30)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_30)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_30))))

pdf("images/sppComparison3_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_30[,seq(3, ncol(espptwcc_heur_fp_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_30[,seq(3, ncol(espptwcc_heur_fp_5paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_30[,seq(3, ncol(espptwcc_heur_fp_10paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_30[,seq(3, ncol(espptwcc_heur_fp_20paths_30), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_30[,seq(3, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_30)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_30)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_30)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_30)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_30))))

pdf("images/sppComparisonRelaxed3_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_40[,seq(2, ncol(espptwcc_heur_fp_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_40[,seq(2, ncol(espptwcc_heur_fp_5paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_40[,seq(2, ncol(espptwcc_heur_fp_10paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_40[,seq(2, ncol(espptwcc_heur_fp_20paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_40[,seq(2, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_40)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_40)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_40)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_40)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_40))))

pdf("images/sppComparison3_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_40[,seq(3, ncol(espptwcc_heur_fp_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_40[,seq(3, ncol(espptwcc_heur_fp_5paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_40[,seq(3, ncol(espptwcc_heur_fp_10paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_40[,seq(3, ncol(espptwcc_heur_fp_20paths_40), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_40[,seq(3, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_40)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_40)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_40)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_40)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_40))))

pdf("images/sppComparisonRelaxed3_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# 50 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_50[,seq(2, ncol(espptwcc_heur_fp_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_50[,seq(2, ncol(espptwcc_heur_fp_5paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_50[,seq(2, ncol(espptwcc_heur_fp_10paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_50[,seq(2, ncol(espptwcc_heur_fp_20paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_50[,seq(2, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_50)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_50)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_50)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_50))))

pdf("images/sppComparison3_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 5),
                                distance = c(apply(espptwcc_heur_fp_50[,seq(3, ncol(espptwcc_heur_fp_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_5paths_50[,seq(3, ncol(espptwcc_heur_fp_5paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_10paths_50[,seq(3, ncol(espptwcc_heur_fp_10paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_20paths_50[,seq(3, ncol(espptwcc_heur_fp_20paths_50), by = 2)], 1, mean),
                                             apply(espptwcc_heur_fp_50paths_50[,seq(3, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50)),
                                          rep(2, nrow(espptwcc_heur_fp_5paths_50)),
                                          rep(3, nrow(espptwcc_heur_fp_10paths_50)),
                                          rep(4, nrow(espptwcc_heur_fp_20paths_50)),
                                          rep(5, nrow(espptwcc_heur_fp_50paths_50))))

pdf("images/sppComparisonRelaxed3_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("1 path", "5 paths", "10 paths", "20 paths", "50 paths")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")
dev.off()

# plot recomputation
# plot 20 paths returned vs. recomputation
# 20 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_20[,seq(2, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_20[,seq(2, ncol(espptwcc_heur_fp_recomp_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_20)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_20))))

pdf("images/sppComparison4_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_20[,seq(3, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_20[,seq(3, ncol(espptwcc_heur_fp_recomp_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_20)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_20))))

pdf("images/sppComparisonRelaxed4_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 30 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_30[,seq(2, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_30[,seq(2, ncol(espptwcc_heur_fp_recomp_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_30)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_30))))

pdf("images/sppComparison4_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_30[,seq(3, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_30[,seq(3, ncol(espptwcc_heur_fp_recomp_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_30)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_30))))

pdf("images/sppComparisonRelaxed4_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_fp_50paths_40[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_40[,seq(2, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_40[,seq(2, ncol(espptwcc_heur_fp_recomp_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_40)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_40))))

pdf("images/sppComparison4_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_40[,seq(3, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_40[,seq(3, ncol(espptwcc_heur_fp_recomp_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_40)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_40))))

pdf("images/sppComparisonRelaxed4_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 50 customers 
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_fp_50paths_50[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_50[,seq(2, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_50[,seq(2, ncol(espptwcc_heur_fp_recomp_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_50)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_50))))

pdf("images/sppComparison4_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_50[,seq(3, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_recomp_50[,seq(3, ncol(espptwcc_heur_fp_recomp_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_20paths_50)),
                                          rep(2, nrow(espptwcc_heur_fp_recomp_50))))

pdf("images/sppComparisonRelaxed4_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("50 paths", "Recomputation")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()


# plot box method vs. non-box method
# 20 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_20[,seq(2, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_20[,seq(2, ncol(espptwcc_heur_fp_50paths_box_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_20)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_20))))

pdf("images/sppComparison5_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_20[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_20[,seq(3, ncol(espptwcc_heur_fp_50paths_20), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_20[,seq(3, ncol(espptwcc_heur_fp_50paths_box_20), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_20)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_20))))

pdf("images/sppComparisonRelaxed5_20.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 30 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_30[,seq(2, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_30[,seq(2, ncol(espptwcc_heur_fp_50paths_box_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_30)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_30))))

pdf("images/sppComparison5_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_30[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_30[,seq(3, ncol(espptwcc_heur_fp_50paths_30), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_30[,seq(3, ncol(espptwcc_heur_fp_50paths_box_30), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_30)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_30))))

pdf("images/sppComparisonRelaxed5_30.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 40 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_40[,seq(2, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_40[,seq(2, ncol(espptwcc_heur_fp_50paths_box_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_40)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_40))))

pdf("images/sppComparison5_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_40[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_40[,seq(3, ncol(espptwcc_heur_fp_50paths_40), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_40[,seq(3, ncol(espptwcc_heur_fp_50paths_box_40), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_40)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_40))))

pdf("images/sppComparisonRelaxed5_40.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

# 50 customers
aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_50[,seq(2, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_50[,seq(2, ncol(espptwcc_heur_fp_50paths_box_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_50)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_50))))

pdf("images/sppComparison5_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()

aggregatedPlotData = data.frame(time = rep(espptwcc_heur_50[,1], 4),
                                distance = c(apply(espptwcc_heur_fp_50paths_50[,seq(3, ncol(espptwcc_heur_fp_50paths_50), by = 2)], 1, mean), 
                                             apply(espptwcc_heur_fp_50paths_box_50[,seq(3, ncol(espptwcc_heur_fp_50paths_box_50), by = 2)], 1, mean)),
                                group = c(rep(1, nrow(espptwcc_heur_fp_50paths_50)),
                                          rep(2, nrow(espptwcc_heur_fp_50paths_box_50))))

pdf("images/sppComparisonRelaxed5_50.pdf")
ggplot(data = aggregatedPlotData, aes(x = time, y = distance, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "", label = c("No box applied", "Box applied")) + 
  xlab("Computation time in s") +
  ylab("Travel distance")+ guides(colour = guide_legend(nrow = 2))
dev.off()