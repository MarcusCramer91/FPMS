generateDistmat = function(min, max, dim) {
  distances = runif(n = ceiling(dim*(dim-1)/2), min = min, max = max)
  distmat = matrix(nrow = dim, ncol = dim)
  diag(distmat) = 0
  counter = 1
  for (i in 1:(nrow(distmat)-1)) {
    for (j in (i+1):ncol(distmat)) {
      distmat[i,j] = distances[counter]
      counter = counter + 1
    }
  }
  distmat[is.na(distmat)] = 0
  distmat = distmat + t(distmat)
  return(distmat)
}

distmat10 = generateDistmat(0,10,10)
write.table(distmat10, "data/DummyDistmat10.csv", col.names = FALSE, row.names = FALSE, sep = ",")

distmat11 = generateDistmat(0,10,11)
write.table(distmat11, "data/DummyDistmat11.csv", col.names = FALSE, row.names = FALSE, sep = ",")

distmat12 = generateDistmat(0,10,12)
write.table(distmat12, "data/DummyDistmat12.csv", col.names = FALSE, row.names = FALSE, sep = ",")

distmat15 = generateDistmat(0,10,15)
write.table(distmat15, "data/DummyDistmat15.csv", col.names = FALSE, row.names = FALSE, sep = ",")
