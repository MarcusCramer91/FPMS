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

summaries$improvementAll = as.numeric(format((summaries$fpCosts-summaries$costs)/summaries$fpCosts*100, digits = 2))
summaries$improvementDriven = as.numeric(format((summaries$fpCostsDriven-summaries$costsDriven)/summaries$fpCostsDriven*100, digits = 2))

# generate latex code
# large tables
cat("\\begin{longtable} {p{.07\\linewidth} p{.04\\linewidth} p{.04\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} p{.1\\linewidth} } \n", file = "results.txt", append = TRUE)
cat("\\hline \n", file = "results.txt", append = TRUE)
cat("& \\multicolumn{2}{c}{\\textbf{No. paths}} & \\multicolumn{2}{c}{\\textbf{Overall time}} & \\multicolumn{2}{c}{\\textbf{Driving time}} & 
\\multicolumn{2}{c}{\\textbf{Improvement in \\%}} \\\\", file = "results.txt", append = TRUE)
cat("\\textbf{Instance} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{FP} & \\textbf{CG} & \\textbf{All} & \\textbf{Driving} \\\\ \n", file = "results.txt", append = TRUE)
cat("\\hline \n", file = "results.txt", append = TRUE)
cat("\\toprule \n", file = "results.txt", append = TRUE)
for (i in c(20,30,40,50,60,70,80)) {
  cur = summaries[grepl(paste(i,"_",sep =""), summaries$instance),]
  for (j in 1:10) {
    current = summaries[grepl(paste(i,"_",j,".csv", sep =""), summaries$instance),]
    if (nrow(current) == 0) next
    catString = paste(i,"\\_",j, "&",current$fpPaths,"&", sep ="")
    if (current$fpPaths > current$finalPaths) catString = paste(catString, "\\textbf{", current$finalPaths, "}&", sep = "")
    else catString = paste(catString, current$finalPaths, "&", sep = "")
    catString = paste(catString, current$fpCosts, "&", sep = "")
    if (current$fpCosts > current$costs) catString = paste(catString, "\\textbf{", current$costs, "}&", sep = "")
    else catString = paste(catString, current$costs, "&", sep = "")
    catString = paste(catString, current$fpCostsDriven, "&", sep = "")
    if (current$fpCostsDriven > current$costsDriven) catString = paste(catString, "\\textbf{", current$costsDriven, "}&", sep = "")
    else catString = paste(catString, current$costsDriven, "&", sep = "")
    if (current$improvementAll > 0) catString = paste(catString, "\\textbf{", current$improvementAll, "}&", sep = "")
    else catString = paste(catString, current$improvementAll, "&", sep = "")
    if (current$improvementDriven > 0) catString = paste(catString, "\\textbf{", current$improvementDriven, "}&", sep = "")
    else catString = paste(catString, current$improvementDriven, sep = "")
    catString = paste(catString, "\\\\ \n", sep = "")
    print(catString)
    cat(catString, file = "results.txt", append = TRUE)
  }
  cat(paste("\\midrule \n Avg. &", mean(cur$fpPaths), "&", 
            mean(cur$finalPaths), "&", 
            mean(cur$fpCosts), "&", 
            mean(cur$costs), "&", 
            mean(cur$fpCostsDriven), "&", 
            mean(cur$costsDriven), "&", 
            mean(cur$improvementAll), "&", 
            mean(cur$improvementDriven), "\\\\ \\midrule \n", sep = ""), file = "results.txt", append = TRUE)
  if (i != 80) cat("\\midrule \n", file = "results.txt", append = TRUE)
}
cat("\\bottomrule \n", file = "results.txt", append = TRUE)

cat("\\caption{Comparison of initial Flaschenpost heuristic results vs. results of the stabilized cutting plane approach after 600 seconds computation time with a maximum vehicle capacity of 100 (improvement in bold)} \n", file = "results.txt", append = TRUE)
cat("\\label{tab:stabilizedVsFp100} \n", file = "results.txt", append = TRUE)
cat("\\end{longtable} \n", file = "results.txt", append = TRUE)


# summary table


cat("\\begin{table} \n", file = "results_summary.txt", append = TRUE)
cat("\\centering \n", file = "results_summary.txt", append = TRUE)
cat("\\begin{tabular}{p{0.15\\linewidth} p{0.1\\linewidth} p{0.1\\linewidth} p{0.1\\linewidth} p{0.1\\linewidth}} \n", file = "results_summary.txt", append = TRUE)
cat("\\multirow{2}{*}{\\parbox[t]{2cm}{\\textbf{Number of customers}}} & \\multicolumn{4}{c}{\\textbf{Maximum vehicle capacity}} \\\\", file = "results_summary.txt", append = TRUE)
cat("& 70 & 80 & 90 & 100 \\\\ \n", file = "results_summary.txt", append = TRUE)
cat("\\toprule \n", file = "results_summary.txt", append = TRUE)
capacities = c(100)
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
  catString = paste(catString, "\\\\", sep ="")
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
