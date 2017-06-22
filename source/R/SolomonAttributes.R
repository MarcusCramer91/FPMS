routes = list(c(0,81,78,76,71,70,73,77,79,80,0), 
              c(0,57,55,54,53,56,58,60,59,0),
              c(0,98,96,95,94,92,93,97,100,99,0),
              c(0,32,33,31,35,37,38,39,36,34,0),
              c(0,13,17,18,19,15,16,14,12,0),
              c(0,90,87,86,83,82,84,85,88,89,91,0),
              c(0,43,42,41,40,44,46,45,48,51,50,52,49,47,0),
              c(0,67,65,63,62,74,72,61,64,68,66,69,0),
              c(0,5,3,7,8,10,11,9,6,4,2,1,75,0),
              c(0,20,24,25,27,29,30,28,26,23,22,21,0))

distmat = read.csv("Solomon test instances/c101Distmat.csv", header = FALSE)
distmat = distmat[,-ncol(distmat)]
costs = 0
for (i in 1:length(routes)) {
  route = routes[[i]]
  cost = 0
  for (j in 1:(length(route)-1)) {
    cost = cost + distmat[route[j]+1,route[j+1]+1]
  }
  print(cost)
  costs = costs + cost
}


c101 = read.csv("Solomon test instances/c101Locations.csv", header = FALSE)
c101$group = c(1, rep())
r101 = read.csv("Solomon test instances/r101Locations.csv", header = FALSE)
r101$group = c(1, rep(2,100))
rc101 = read.csv("Solomon test instances/rc101Locations.csv", header = FALSE)
rc101$group = c(1, rep(2,100))

require(ggplot2)

pdf("images/solomon_c101.pdf")
ggplot(data = c101[1:41,], aes(x = V1, y = V2, group = group, shape = as.factor(group))) + 
  geom_point(size = 3) + geom_point(data = c101[1,], aes(x = V1, y = V2), size = 10) + theme_bw() + 
  xlab("X") +
  ylab("Y") + theme(legend.position = "non", axis.text = element_text(size = 15, color = "black"), axis.title = element_text(size = 15, color = "black"))
dev.off()

pdf("images/solomon_r101.pdf")
ggplot(data = r101, aes(x = V1, y = V2, group = group, shape = as.factor(group))) +
  geom_point(size = 3)+ geom_point(data = c101[1,], aes(x = V1, y = V2), size = 10)+ theme_bw() + 
  xlab("X") +
  ylab("Y") + theme(legend.position = "non", axis.text = element_text(size = 15, color = "black"), axis.title = element_text(size = 15, color = "black"))
dev.off()

pdf("images/solomon_rc101.pdf")
ggplot(data = rc101, aes(x = V1, y = V2, group = group, shape = as.factor(group))) + 
  geom_point(size = 3) +geom_point(data = c101[1,], aes(x = V1, y = V2), size = 10) + theme_bw() + 
  xlab("X") +
  ylab("Y") + theme(legend.position = "non", axis.text = element_text(size = 15, color = "black"), axis.title = element_text(size = 15, color = "black"))
dev.off()


route = c(0, 43, 41, 40, 44, 45, 48, 50, 52, 49, 47, 101)
route = c(0, 43, 42, 41, 40, 44, 46, 45, 48, 51, 50, 52, 49, 47, 101)

distmat = read.csv("Solomon test instances/firstreducedcostsmat.csv", header = FALSE)
distmat = distmat[,-ncol(distmat)]
cost = 0
for (j in 1:(length(route)-1)) {
  cost = cost + distmat[route[j]+1,route[j+1]+1]
}
print(cost)

allnodes = read.csv("C:\\Users\\Marcus\\Documents\\FPMS\\results\\colgen\\stabilizedSolomon\\allnodes.csv", header = FALSE) #16, 74, 93 missing
sort(unique(as.vector(allnodes[,1])))
