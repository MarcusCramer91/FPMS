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
