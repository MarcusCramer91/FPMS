
lonlats1 = read.csv("data/testcases/LonLats_20_1.csv")


kmeans1 = kmeans(lonlats1, centers = 2)
             
             
             
             
             
allResults = list.files("results/colgen/stabilized100")
summaries = data.frame(colgenDrivingCosts = numeric(10*8),
                       colgenOverallCosts = numeric(10*8),
                       meanOrderTime = numeric(10*8),
                       meanWeight = numeric(10*8),
                       clusteredness = numeric(10*8),
                       separateness = numeric(10*8),
                       separatenessImproved = numeric(10*8))

source("source/R/Geo_helper.R")
counter = 1
for (i in seq(20,90, by = 10)) {
  for (j in 1:10) {
    current = allResults[grepl(paste("Summary_whole_600depth first_", i, "_",j, ".csv", sep = ""), allResults)]
    result = read.csv(paste("results/colgen/stabilized100/", current, sep = ""), header = FALSE)
    lonlats = read.csv(paste("data/testcases/LonLats_",i, "_", j, ".csv", sep = ""))
    orders = read.csv(paste("data/testcases/Orders_",i, "_", j, ".csv", sep = ""))
    travelTimes = read.csv(paste("data/testcases/TravelTimes_",i, "_", j, ".csv", sep = ""), header = FALSE)
    meanOrderTime = mean(orders$time)
    meanWeight = mean(orders$weight)
    separateness = sum(travelTimes) / (nrow(travelTimes) * ncol(travelTimes))
    clusteredness = 0
    for (k in 1:10) {
      temp = kmeans(lonlats, centers = i / 10)
      clusteredness = clusteredness + temp$tot.withinss/temp$totss
    }
    clusteredness = clusteredness / 10
    separatenessImproved = 0
    for (k in 1:nrow(travelTimes)) {
      lowest = unlist(sort(travelTimes[k,])[1:10])
      lowest = mean(lowest)
      separatenessImproved = separatenessImproved + lowest
    }
    separatenessImproved = separatenessImproved/nrow(travelTimes)
    
    summaries$meanOrderTime[counter] = meanOrderTime
    summaries$meanWeight[counter] = meanWeight
    summaries$clusteredness[counter] = clusteredness
    summaries$separateness[counter] = separateness
    summaries$separatenessImproved[counter] = separatenessImproved
    summaries$colgenDrivingCosts[counter] = result[1,7]/i
    summaries$colgenOverallCosts[counter] = result[1,6]/i
    
    counter = counter + 1
  }
  # normalize between different problem sizes
  summaries$clusteredness[(counter-10):(counter-1)] = 
    summaries$clusteredness[(counter-10):(counter-1)]/max(summaries$clusteredness[(counter-10):(counter-1)])
  summaries$separateness[(counter-10):(counter-1)] = 
    summaries$separateness[(counter-10):(counter-1)]/max(summaries$separateness[(counter-10):(counter-1)])
  summaries$separatenessImproved[(counter-10):(counter-1)] = 
    summaries$separatenessImproved[(counter-10):(counter-1)]/max(summaries$separatenessImproved[(counter-10):(counter-1)])
  
}

plot(summaries$meanOrderTime, summaries$colgenDrivingCosts)
abline(lm(summaries$colgenDrivingCosts ~ summaries$meanOrderTime))

plot(summaries$meanWeight, summaries$colgenDrivingCosts)
abline(lm(summaries$colgenDrivingCosts ~ summaries$meanWeight))

plot(summaries$separateness, summaries$colgenDrivingCosts)
abline(lm(summaries$colgenDrivingCosts ~ summaries$separateness))

plot(summaries$clusteredness, summaries$colgenDrivingCosts)
abline(lm(summaries$colgenDrivingCosts ~ summaries$clusteredness))

plot(summaries$separatenessImproved, summaries$colgenDrivingCosts)
abline(lm(summaries$colgenDrivingCosts ~ summaries$separatenessImproved))

linearModel = lm(summaries$colgenDrivingCosts ~ summaries$meanOrderTime + summaries$meanWeight + summaries$separateness +
                   summaries$clusteredness + summaries$separatenessImproved)

meanDriving = numeric(0)
for (i in 0:7) {
  meanDriving = c(meanDriving, mean(summaries$colgenDrivingCosts[(i*10+1):(i*10+10)]))
}

meanSeparatenessImproved = numeric(0)
for (i in 0:7) {
  meanSeparatenessImproved = c(meanSeparatenessImproved, mean(summaries$separatenessImproved[(i*10+1):(i*10+10)]))
}


##### analyze day results
driving_20 = read.csv("results/days/20_Day1.csv", header = FALSE)[,4]/read.csv("results/days/20_Day1.csv", header = FALSE)[3]

allResults = list.files("results/days/distmats")
separatenesses = numeric(0)

for (result in allResults) {
  travelTimes = read.csv(paste("results/days/distmats/", result, sep = ""), header = FALSE)
  travelTimes = travelTimes[,-ncol(travelTimes)]
  separateness = sum(travelTimes) / (nrow(travelTimes) * ncol(travelTimes))
  separatenesses = c(separatenesses, separateness)
}

