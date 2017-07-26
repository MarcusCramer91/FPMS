allResults = list.files("results/colgen/stabilized100")

summaries = data.frame(instance = character(length(allResults[grepl("Summary", allResults)])),
                       fpPaths = numeric(length(allResults[grepl("Summary", allResults)])),
                       finalPaths = numeric(length(allResults[grepl("Summary", allResults)])), 
                       relaxed = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCosts = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCostsDriven = numeric(length(allResults[grepl("Summary", allResults)])),
                       costs = numeric(length(allResults[grepl("Summary", allResults)])),
                       costsDriven = numeric(length(allResults[grepl("Summary", allResults)])))
summaries$instance = as.character(summaries$instance)

for (i in 1:length(allResults)) {
  if (grepl("Summary", allResults[i])) {
    if (file.size(paste("results/colgen/stabilized100/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/colgen/stabilized100/", allResults[i], sep = ""), header = FALSE)
    colnames(data) = colnames(summaries)[2:8]
    if (ncol(data == 7)) summaries[i,] = c(instance = as.character(allResults[i]), data[1,])
  }
}
sharedFPResults100 = read.csv("results/fp/fpResults100_revised.csv", header = FALSE)
for (i in 1:nrow(sharedFPResults100)) {
  summaries$fpPaths[i] = sharedFPResults100$V2[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                               nchar(summaries$instance[i])-4), 
                                                     sharedFPResults100$V1)][1]
  summaries$fpCostsDriven[i] = sharedFPResults100$V3[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                     nchar(summaries$instance[i])-4), 
                                                           sharedFPResults100$V1)][1]
  summaries$fpCosts[i] = sharedFPResults100$V4[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                               nchar(summaries$instance[i])-4), 
                                                     sharedFPResults100$V1)][1]
}

summaries$improvementAll = as.numeric(format((summaries$fpCosts-summaries$costs)/summaries$fpCosts*100, digits = 2))
summaries$improvementDriven = as.numeric(format((summaries$fpCostsDriven-summaries$costsDriven)/summaries$fpCostsDriven*100, digits = 2))


# generate latex code
# large tables
cat("\\begin{longtable} {p{.07\\linewidth} p{.04\\linewidth} p{.04\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth}} \n", file = "results100.txt", append = TRUE)
cat("\\hline \n", file = "results100.txt", append = TRUE)
cat("& \\multicolumn{2}{c}{\\textbf{No. paths}} & \\multicolumn{2}{c}{\\textbf{Overall time}} & \\multicolumn{2}{c}{\\textbf{Driving time}} & 
    \\multicolumn{2}{c}{\\textbf{Improvement in \\%}} \\\\", file = "results100.txt", append = TRUE)
cat("\\textbf{Instance} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{All} & \\textbf{Driving} \\\\ \n", file = "results100.txt", append = TRUE)
cat("\\hline \n", file = "results100.txt", append = TRUE)
cat("\\toprule \n", file = "results100.txt", append = TRUE)
for (i in c(20,30,40,50,60,70,80,90)) {
  cur = summaries[grepl(paste(i,"_",sep =""), summaries$instance),]
  for (j in 1:10) {
    current = summaries[grepl(paste(i,"_",j,".csv", sep =""), summaries$instance),]
    if (nrow(current) == 0) next
    catString = paste(i,"\\_",j, "&",current$fpPaths,"&", sep ="")
    if (current$fpPaths > current$finalPaths) catString = paste(catString, "\\textbf{", 
                                                                format(current$finalPaths, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$finalPaths, nsmall = 0, big.mark = ","), "&", sep = "")
    catString = paste(catString, format(current$fpCosts, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$fpCosts > current$costs) catString = paste(catString, "\\textbf{", 
                                                           format(current$costs, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costs, nsmall = 0, big.mark = ","), "&", sep = "")
    
    catString = paste(catString, format(current$fpCostsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    if (current$fpCostsDriven > current$costsDriven) catString = paste(catString, "\\textbf{", 
                                                                       format(current$costsDriven, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$improvementAll > 0) catString = paste(catString, "\\textbf{", format(current$improvementAll, nsmall = 2), "}&", sep = "")
    else catString = paste(catString, format(current$improvementAll, nsmall = 2), "&", sep = "")
    
    if (current$improvementDriven > 0) catString = paste(catString, "\\textbf{", format(current$improvementDriven, nsmall = 2), "}", sep = "")
    else catString = paste(catString, format(current$improvementDriven, nsmall = 2), sep = "")
    catString = paste(catString, "\\\\ \n", sep = "")
    print(catString)
    cat(catString, file = "results100.txt", append = TRUE)
  }
  cat(paste("\\midrule \n Avg. &", format(mean(cur$fpPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$finalPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCosts), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costs), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCostsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$improvementAll), nsmall = 2, digits = 2), "&", 
            format(mean(cur$improvementDriven), nsmall = 2,digits = 2), "\\\\ \\midrule \n", sep = ""), file = "results100.txt", append = TRUE)
  if (i != 90) cat("\\midrule \n", file = "results100.txt", append = TRUE)
}
cat("\\bottomrule \n", file = "results100.txt", append = TRUE)

cat("\\caption{Comparison of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time with a maximum vehicle capacity of 100 and a time window of 120 (improvement in bold)} \n", file = "results100.txt", append = TRUE)
cat("\\label{tab:stabilizedVsFp100} \n", file = "results100.txt", append = TRUE)
cat("\\end{longtable} \n", file = "results100.txt", append = TRUE)


allResults = list.files("results/colgen/stabilized70")

summaries = data.frame(instance = character(length(allResults[grepl("Summary", allResults)])),
                       fpPaths = numeric(length(allResults[grepl("Summary", allResults)])),
                       finalPaths = numeric(length(allResults[grepl("Summary", allResults)])), 
                       relaxed = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCosts = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCostsDriven = numeric(length(allResults[grepl("Summary", allResults)])),
                       costs = numeric(length(allResults[grepl("Summary", allResults)])),
                       costsDriven = numeric(length(allResults[grepl("Summary", allResults)])))
summaries$instance = as.character(summaries$instance)

for (i in 1:length(allResults)) {
  if (grepl("Summary", allResults[i])) {
    if (file.size(paste("results/colgen/stabilized70/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/colgen/stabilized70/", allResults[i], sep = ""), header = FALSE)
    colnames(data) = colnames(summaries)[2:8]
    if (ncol(data == 7)) summaries[i,] = c(instance = as.character(allResults[i]), data[1,])
  }
}
sharedFPResults70 = read.csv("results/fp/fpResults70_revised.csv", header = FALSE)
for (i in 1:nrow(sharedFPResults70)) {
  summaries$fpPaths[i] = sharedFPResults70$V2[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                               nchar(summaries$instance[i])-4), 
                                                    sharedFPResults70$V1)][1]
  summaries$fpCostsDriven[i] = sharedFPResults70$V3[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                     nchar(summaries$instance[i])-4), 
                                                          sharedFPResults70$V1)][1]
  summaries$fpCosts[i] = sharedFPResults70$V4[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                               nchar(summaries$instance[i])-4), 
                                                    sharedFPResults70$V1)][1]
}

summaries$improvementAll = as.numeric(format((summaries$fpCosts-summaries$costs)/summaries$fpCosts*100, digits = 2))
summaries$improvementDriven = as.numeric(format((summaries$fpCostsDriven-summaries$costsDriven)/summaries$fpCostsDriven*100, digits = 2))




cat("\\begin{longtable} {p{.07\\linewidth} p{.04\\linewidth} p{.04\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} } \n", file = "results70.txt", append = TRUE)
cat("\\hline \n", file = "results70.txt", append = TRUE)
cat("& \\multicolumn{2}{c}{\\textbf{No. paths}} & \\multicolumn{2}{c}{\\textbf{Overall time}} & \\multicolumn{2}{c}{\\textbf{Driving time}} & 
    \\multicolumn{2}{c}{\\textbf{Improvement in \\%}} \\\\", file = "results70.txt", append = TRUE)
cat("\\textbf{Instance} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{All} & \\textbf{Driving} \\\\ \n", file = "results70.txt", append = TRUE)
cat("\\hline \n", file = "results70.txt", append = TRUE)
cat("\\toprule \n", file = "results70.txt", append = TRUE)
for (i in c(20,30,40,50,60,70,80,90)) {
  cur = summaries[grepl(paste(i,"_",sep =""), summaries$instance),]
  for (j in 1:10) {
    current = summaries[grepl(paste(i,"_",j,".csv", sep =""), summaries$instance),]
    if (nrow(current) == 0) next
    catString = paste(i,"\\_",j, "&",current$fpPaths,"&", sep ="")
    if (current$fpPaths > current$finalPaths) catString = paste(catString, "\\textbf{", 
                                                                format(current$finalPaths, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$finalPaths, nsmall = 0, big.mark = ","), "&", sep = "")
    catString = paste(catString, format(current$fpCosts, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$fpCosts > current$costs) catString = paste(catString, "\\textbf{", 
                                                           format(current$costs, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costs, nsmall = 0, big.mark = ","), "&", sep = "")
    
    catString = paste(catString, format(current$fpCostsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    if (current$fpCostsDriven > current$costsDriven) catString = paste(catString, "\\textbf{", 
                                                                       format(current$costsDriven, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$improvementAll > 0) catString = paste(catString, "\\textbf{", format(current$improvementAll, nsmall = 2), "}&", sep = "")
    else catString = paste(catString, format(current$improvementAll, nsmall = 2), "&", sep = "")
    
    if (current$improvementDriven > 0) catString = paste(catString, "\\textbf{", format(current$improvementDriven, nsmall = 2), "}", sep = "")
    else catString = paste(catString, format(current$improvementDriven, nsmall = 2), sep = "")
    catString = paste(catString, "\\\\ \n", sep = "")
    print(catString)
    cat(catString, file = "results70.txt", append = TRUE)
  }
  cat(paste("\\midrule \n Avg. &", format(mean(cur$fpPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$finalPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCosts), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costs), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCostsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$improvementAll), nsmall = 2, digits = 2), "&", 
            format(mean(cur$improvementDriven), nsmall = 2,digits = 2), "\\\\ \\midrule \n", sep = ""), file = "results70.txt", append = TRUE)
  if (i != 90) cat("\\midrule \n", file = "results70.txt", append = TRUE)
}
cat("\\bottomrule \n", file = "results70.txt", append = TRUE)

cat("\\caption{Comparison of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time with a maximum vehicle capacity of 70 and a time window of 120 (improvement in bold)} \n", file = "results70.txt", append = TRUE)
cat("\\label{tab:stabilizedVsFp70} \n", file = "results70.txt", append = TRUE)
cat("\\end{longtable} \n", file = "results70.txt", append = TRUE)



allResults = list.files("results/colgen/stabilized100_tw90")

summaries = data.frame(instance = character(length(allResults[grepl("Summary", allResults)])),
                       fpPaths = numeric(length(allResults[grepl("Summary", allResults)])),
                       finalPaths = numeric(length(allResults[grepl("Summary", allResults)])), 
                       relaxed = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCosts = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCostsDriven = numeric(length(allResults[grepl("Summary", allResults)])),
                       costs = numeric(length(allResults[grepl("Summary", allResults)])),
                       costsDriven = numeric(length(allResults[grepl("Summary", allResults)])))
summaries$instance = as.character(summaries$instance)

for (i in 1:length(allResults)) {
  if (grepl("Summary", allResults[i])) {
    if (file.size(paste("results/colgen/stabilized100_tw90/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/colgen/stabilized100_tw90/", allResults[i], sep = ""), header = FALSE)
    colnames(data) = colnames(summaries)[2:8]
    if (ncol(data == 7)) summaries[i,] = c(instance = as.character(allResults[i]), data[1,])
  }
}
sharedFPResults100_tw90 = read.csv("results/fp/fpResults100_tw90_revised.csv", header = FALSE)
for (i in 1:nrow(sharedFPResults100_tw90)) {
  summaries$fpPaths[i] = sharedFPResults100_tw90$V2[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                              nchar(summaries$instance[i])-4), 
                                                          sharedFPResults100_tw90$V1)][1]
  summaries$fpCostsDriven[i] = sharedFPResults100_tw90$V3[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                    nchar(summaries$instance[i])-4), 
                                                                sharedFPResults100_tw90$V1)][1]
  summaries$fpCosts[i] = sharedFPResults100_tw90$V4[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                              nchar(summaries$instance[i])-4), 
                                                          sharedFPResults100_tw90$V1)][1]
}

summaries$improvementAll = as.numeric(format((summaries$fpCosts-summaries$costs)/summaries$fpCosts*100, digits = 2))
summaries$improvementDriven = as.numeric(format((summaries$fpCostsDriven-summaries$costsDriven)/summaries$fpCostsDriven*100, digits = 2))




cat("\\begin{longtable} {p{.07\\linewidth} p{.04\\linewidth} p{.04\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} } \n", file = "results100_tw90.txt", append = TRUE)
cat("\\hline \n", file = "results100_tw90.txt", append = TRUE)
cat("& \\multicolumn{2}{c}{\\textbf{No. paths}} & \\multicolumn{2}{c}{\\textbf{Overall time}} & \\multicolumn{2}{c}{\\textbf{Driving time}} & 
    \\multicolumn{2}{c}{\\textbf{Improvement in \\%}} \\\\", file = "results100_tw90.txt", append = TRUE)
cat("\\textbf{Instance} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{All} & \\textbf{Driving} \\\\ \n", file = "results100_tw90.txt", append = TRUE)
cat("\\hline \n", file = "results100_tw90.txt", append = TRUE)
cat("\\toprule \n", file = "results100_tw90.txt", append = TRUE)
for (i in c(20,30,40,50,60,70,80,90)) {
  cur = summaries[grepl(paste(i,"_",sep =""), summaries$instance),]
  for (j in 1:10) {
    current = summaries[grepl(paste(i,"_",j,".csv", sep =""), summaries$instance),]
    if (nrow(current) == 0) next
    catString = paste(i,"\\_",j, "&",current$fpPaths,"&", sep ="")
    if (current$fpPaths > current$finalPaths) catString = paste(catString, "\\textbf{", 
                                                                format(current$finalPaths, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$finalPaths, nsmall = 0, big.mark = ","), "&", sep = "")
    catString = paste(catString, format(current$fpCosts, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$fpCosts > current$costs) catString = paste(catString, "\\textbf{", 
                                                           format(current$costs, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costs, nsmall = 0, big.mark = ","), "&", sep = "")
    
    catString = paste(catString, format(current$fpCostsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    if (current$fpCostsDriven > current$costsDriven) catString = paste(catString, "\\textbf{", 
                                                                       format(current$costsDriven, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$improvementAll > 0) catString = paste(catString, "\\textbf{", format(current$improvementAll, nsmall = 2), "}&", sep = "")
    else catString = paste(catString, format(current$improvementAll, nsmall = 2), "&", sep = "")
    
    if (current$improvementDriven > 0) catString = paste(catString, "\\textbf{", format(current$improvementDriven, nsmall = 2), "}", sep = "")
    else catString = paste(catString, format(current$improvementDriven, nsmall = 2), sep = "")
    catString = paste(catString, "\\\\ \n", sep = "")
    print(catString)
    cat(catString, file = "results100_tw90.txt", append = TRUE)
  }
  cat(paste("\\midrule \n Avg. &", format(mean(cur$fpPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$finalPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCosts), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costs), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCostsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$improvementAll), nsmall = 2, digits = 2), "&", 
            format(mean(cur$improvementDriven), nsmall = 2,digits = 2), "\\\\ \\midrule \n", sep = ""), file = "results100_tw90.txt", append = TRUE)
  if (i != 90) cat("\\midrule \n", file = "results100_tw90.txt", append = TRUE)
}
cat("\\bottomrule \n", file = "results100_tw90.txt", append = TRUE)

cat("\\caption{Comparison of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time with a maximum vehicle capacity of 100 and a time window of 90 (improvement in bold)} \n", file = "results100_tw90.txt", append = TRUE)
cat("\\label{tab:stabilizedVsFp100_tw90} \n", file = "results100_tw90.txt", append = TRUE)
cat("\\end{longtable} \n", file = "results100_tw90.txt", append = TRUE)





allResults = list.files("results/colgen/stabilized70_tw90")

summaries = data.frame(instance = character(length(allResults[grepl("Summary", allResults)])),
                       fpPaths = numeric(length(allResults[grepl("Summary", allResults)])),
                       finalPaths = numeric(length(allResults[grepl("Summary", allResults)])), 
                       relaxed = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCosts = numeric(length(allResults[grepl("Summary", allResults)])),
                       fpCostsDriven = numeric(length(allResults[grepl("Summary", allResults)])),
                       costs = numeric(length(allResults[grepl("Summary", allResults)])),
                       costsDriven = numeric(length(allResults[grepl("Summary", allResults)])))
summaries$instance = as.character(summaries$instance)

for (i in 1:length(allResults)) {
  if (grepl("Summary", allResults[i])) {
    if (file.size(paste("results/colgen/stabilized70_tw90/", allResults[i], sep = "")) == 0) next
    data = read.csv(paste("results/colgen/stabilized70_tw90/", allResults[i], sep = ""), header = FALSE)
    colnames(data) = colnames(summaries)[2:8]
    if (ncol(data == 7)) summaries[i,] = c(instance = as.character(allResults[i]), data[1,])
  }
}
sharedFPResults70_tw90 = read.csv("results/fp/fpResults70_tw90_revised.csv", header = FALSE)
for (i in 1:nrow(sharedFPResults70_tw90)) {
  summaries$fpPaths[i] = sharedFPResults70_tw90$V2[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                    nchar(summaries$instance[i])-4), 
                                                         sharedFPResults70_tw90$V1)][1]
  summaries$fpCostsDriven[i] = sharedFPResults70_tw90$V3[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                          nchar(summaries$instance[i])-4), 
                                                               sharedFPResults70_tw90$V1)][1]
  summaries$fpCosts[i] = sharedFPResults70_tw90$V4[grepl(substring(summaries$instance[i], nchar(summaries$instance[i])-8,
                                                                    nchar(summaries$instance[i])-4), 
                                                         sharedFPResults70_tw90$V1)][1]
}

summaries$improvementAll = as.numeric(format((summaries$fpCosts-summaries$costs)/summaries$fpCosts*100, digits = 2))
summaries$improvementDriven = as.numeric(format((summaries$fpCostsDriven-summaries$costsDriven)/summaries$fpCostsDriven*100, digits = 2))




cat("\\begin{longtable} {p{.07\\linewidth} p{.04\\linewidth} p{.04\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} } \n", file = "results70_tw90.txt", append = TRUE)
cat("\\hline \n", file = "results70_tw90.txt", append = TRUE)
cat("& \\multicolumn{2}{c}{\\textbf{No. paths}} & \\multicolumn{2}{c}{\\textbf{Overall time}} & \\multicolumn{2}{c}{\\textbf{Driving time}} & 
    \\multicolumn{2}{c}{\\textbf{Improvement in \\%}} \\\\", file = "results70_tw90.txt", append = TRUE)
cat("\\textbf{Instance} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{All} & \\textbf{Driving} \\\\ \n", file = "results70_tw90.txt", append = TRUE)
cat("\\hline \n", file = "results70_tw90.txt", append = TRUE)
cat("\\toprule \n", file = "results70_tw90.txt", append = TRUE)
for (i in c(20,30,40,50,60,70,80,90)) {
  cur = summaries[grepl(paste(i,"_",sep =""), summaries$instance),]
  for (j in 1:10) {
    current = summaries[grepl(paste(i,"_",j,".csv", sep =""), summaries$instance),]
    if (nrow(current) == 0) next
    catString = paste(i,"\\_",j, "&",current$fpPaths,"&", sep ="")
    if (current$fpPaths > current$finalPaths) catString = paste(catString, "\\textbf{", 
                                                                format(current$finalPaths, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$finalPaths, nsmall = 0, big.mark = ","), "&", sep = "")
    catString = paste(catString, format(current$fpCosts, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$fpCosts > current$costs) catString = paste(catString, "\\textbf{", 
                                                           format(current$costs, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costs, nsmall = 0, big.mark = ","), "&", sep = "")
    
    catString = paste(catString, format(current$fpCostsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    if (current$fpCostsDriven > current$costsDriven) catString = paste(catString, "\\textbf{", 
                                                                       format(current$costsDriven, nsmall = 0, big.mark = ","), "}&", sep = "")
    else catString = paste(catString, format(current$costsDriven, nsmall = 0, big.mark = ","), "&", sep = "")
    
    if (current$improvementAll > 0) catString = paste(catString, "\\textbf{", format(current$improvementAll, nsmall = 2), "}&", sep = "")
    else catString = paste(catString, format(current$improvementAll, nsmall = 2), "&", sep = "")
    
    if (current$improvementDriven > 0) catString = paste(catString, "\\textbf{", format(current$improvementDriven, nsmall = 2), "}", sep = "")
    else catString = paste(catString, format(current$improvementDriven, nsmall = 2), sep = "")
    catString = paste(catString, "\\\\ \n", sep = "")
    print(catString)
    cat(catString, file = "results70_tw90.txt", append = TRUE)
  }
  cat(paste("\\midrule \n Avg. &", format(mean(cur$fpPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$finalPaths), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCosts), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costs), nsmall=2, big.mark=","), "&", 
            format(mean(cur$fpCostsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$costsDriven), nsmall=2, big.mark=","), "&", 
            format(mean(cur$improvementAll), nsmall = 2, digits = 2), "&", 
            format(mean(cur$improvementDriven), nsmall = 2,digits = 2), "\\\\ \\midrule \n", sep = ""), file = "results70_tw90.txt", append = TRUE)
  if (i != 90) cat("\\midrule \n", file = "results70_tw90.txt", append = TRUE)
}
cat("\\bottomrule \n", file = "results70_tw90.txt", append = TRUE)

cat("\\caption{Comparison of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time with a maximum vehicle capacity of 70 and a time window of 90 (improvement in bold)} \n", file = "results70_tw90.txt", append = TRUE)
cat("\\label{tab:stabilizedVsFp70_tw90} \n", file = "results70_tw90.txt", append = TRUE)
cat("\\end{longtable} \n", file = "results70_tw90.txt", append = TRUE)

# summary table


cat("\\begin{table} \n", file = "results_summary.txt", append = TRUE)
cat("\\centering \n", file = "results_summary.txt", append = TRUE)
cat("\\begin{tabular}{p{0.15\\linewidth} p{0.1\\linewidth} p{0.1\\linewidth}} \n", file = "results_summary.txt", append = TRUE)
cat("\\multirow{2}{*}{\\parbox[t]{2cm}{\\textbf{Number of customers}}} & \\multicolumn{4}{c}{\\textbf{Maximum vehicle capacity}} \\\\", file = "results_summary.txt", append = TRUE)
cat("& 70 & 100 \\\\ \n", file = "results_summary.txt", append = TRUE)
cat("\\toprule \n", file = "results_summary.txt", append = TRUE)
capacities = c(70,100)
customers = c(20,30,40,50,60,70,80,90)
colcount = 1
for (w in capacities) {
  allResults = list.files(paste("results/colgen/stabilized", w, sep = ""))
  
  summaries = data.frame(instance = character(length(allResults[grepl("Summary", allResults)])),
                         fpPaths = numeric(length(allResults[grepl("Summary", allResults)])),
                         finalPaths = numeric(length(allResults[grepl("Summary", allResults)])), 
                         relaxed = numeric(length(allResults[grepl("Summary", allResults)])),
                         fpCosts = numeric(length(allResults[grepl("Summary", allResults)])),
                         fpCostsDriven = numeric(length(allResults[grepl("Summary", allResults)])),
                         costs = numeric(length(allResults[grepl("Summary", allResults)])),
                         costsDriven = numeric(length(allResults[grepl("Summary", allResults)])))
  summaries$instance = as.character(summaries$instance)
  sharedFPResults = read.csv(paste("results/fp/fpResults", w, "_revised.csv", sep = ""), header = FALSE)
  summaries$fpPaths = sharedFPResults$V2
  summaries$fpCostsDriven = sharedFPResults$V3
  summaries$fpCosts = sharedFPResults$V4
  
  for (i in 1:length(allResults)) {
    print(i)
    if (grepl("Summary", allResults[i])) {
      if (file.size(paste("results/colgen/stabilized", w,"/", allResults[i], sep = "")) == 0) next
      data = read.csv(paste("results/colgen/stabilized", w,"/", allResults[i], sep = ""), header = FALSE)
      colnames(data) = colnames(summaries)[2:8]
      if (ncol(data == 7)) summaries[i,] = c(instance = as.character(allResults[i]), data[1,])
    }
  }
  
  rowcount = 1
  averageImprovements = matrix(nrow = length(customers), ncol = length(capacities))
  for (i in customers) {
    
    averageImprovement = format((mean(summaries$fpCosts[grepl(i,summaries$instance)])-mean(summaries$costs[grepl(i,summaries$instance)])) /
      mean(summaries$fpCosts[grepl(i,summaries$instance)]) * 100, digits = 2)
    averageImprovements[rowcount, colcount] = averageImprovement
    rowcount = rowcount + 1
  }
  colcount = colcount + 1
}
for (i in 1:length(customers)) {
  catString = as.character(customers[i])
  for (j in length(capacities)) {
    catString = paste(catString, "&", as.character(averageImprovements[i,j]), sep ="")
  }
  catString = paste(catString, "\\\\ \n", sep ="")
  print(catString)
  cat(catString, file = "results_summary.txt", append = TRUE)
}


cat("\\bottomrule \n", file = "results_summary.txt", append = TRUE)

cat("\\end{tabular} \n", file = "results_summary.txt", append = TRUE)
cat("\\caption{Summary of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time (improvement in bold)} \n", file = "results_summary.txt", append = TRUE)
cat("\\label{tab:stabilizedVsSummary} \n", file = "results_summary.txt", append = TRUE)
cat("\\end{table} \n", file = "results_summary.txt", append = TRUE)



# test for solomon
allResults = list.files("results/colgen/solomonESPPTWCC")

results = data.frame(instance = character(0), costs = numeric(0))
for (i in 1:length(allResults)) {
  if (grepl("Summary", allResults[i])) {
    data = cbind(allResults[i], read.csv(paste("results/colgen/solomonESPPTWCC/", allResults[i], sep = ""), header = FALSE)[2])
    colnames(data) = c("instance", "costs")
    results = rbind(results, data)
  }
}


# mu analysis
muColgen = read.csv("results/musColGen.csv", header = FALSE)

muColgen = rbind(rep(0, ncol(muColgen)), muColgen)
muColgen = muColgen[muColgen[,ncol(muColgen)] <= 300000,]
distancesColgen = data.frame(time = numeric(nrow(muColgen)), dist = numeric(nrow(muColgen)))
for (i in 1:nrow(muColgen)) {
  distancesColgen[i,2] = sum(abs(muColgen[i,1:(ncol(muColgen)-1)]-muColgen[nrow(muColgen),1:(ncol(muColgen)-1)]))
  distancesColgen[i,1] = muColgen[i,ncol(muColgen)]
}

muStabilized = read.csv("results/musStabilized.csv", header = FALSE)
muStabilized = rbind(rep(0, ncol(muStabilized)), muStabilized)
muStabilized = muStabilized[muStabilized[,ncol(muStabilized)] <= 300000,]

distancesStabilized = data.frame(time = numeric(nrow(muStabilized)), dist = numeric(nrow(muStabilized)))
for (i in 1:nrow(muStabilized)) {
  distancesStabilized[i,2] = sum(abs(muStabilized[i,1:(ncol(muStabilized)-1)]-muStabilized[nrow(muStabilized),1:(ncol(muStabilized)-1)]))
  distancesStabilized[i,1] = muStabilized[i,ncol(muStabilized)]
}
plot(distancesColgen)
plot(distancesStabilized)

plotData = rbind(distancesColgen, distancesStabilized)
plotData$time = plotData$time/1000
plotData = cbind(plotData, group = c(rep("Column generation", nrow(distancesColgen)), rep("Cutting planes", nrow(distancesStabilized))))

pdf("images/dualsConvergence.pdf")
ggplot(data = plotData, aes(x = time, y = dist, group = group, colour = as.factor(group))) + geom_line(size = 2) + theme_bw() + 
  theme(legend.text = element_text(size = 16), legend.title = element_text(size = 16, face = "bold"), 
        axis.title = element_text(size = 16, colour = "black"), axis.text = element_text(size = 14, colour = "black"), legend.position = "top") + 
  scale_colour_discrete(name = "Procedure") + 
  xlab("Computation time in s") +
  ylab("Euclidian distance")
dev.off()