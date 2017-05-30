data = read.csv("data/ReducedCostsMatrix_dummy.csv", header = FALSE, nrow = 1)
length(data)
mat = matrix(nrow = 32, ncol = 32)
counter = 1
for (i in 1:32) {
  for (j in 1:32) {
    mat[i,j] = as.numeric(data[counter])
    counter = counter + 1
  }
}

write.csv(mat, "data/ReducedCostsMatrix_inspect.csv")
