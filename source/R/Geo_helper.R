# converts addresses into lat/long
geocodeAddress <- function(address) {
  print(address)
  require(RJSONIO)
  url <- "https://maps.google.com/maps/api/geocode/json?address="
  url <- paste(url, address, "&sensor=false", sep = "")
  print(url)
  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    out <- c(x$results[[1]]$geometry$location$lng,
             x$results[[1]]$geometry$location$lat)
  } else {
    out <- NA
  }
  Sys.sleep(0.2)  # API only allows 5 requests per second
  out
}

# builds a matrix from the JSON results
buildDistanceMatrixFromJSON = function(rJSON, indices, distanceMatrix) {
  rows = length(rJSON$rows)
  iter = 1
  for (i in 1:rows) {
    for (j in (1:rows)) {
      distanceMatrix[indices[iter,1],indices[iter,2]] = rJSON$rows[[i]]$elements[[j]]$duration$value
    }
  }
  return(res)
}

calculateAirDistanceMatrix = function(longLatMat) {
  airDistanceMatrix = matrix(nrow = nrow(longLatMat), ncol = nrow(longLatMat))
  for (i in 1:nrow(longLatMat)) {
    for (j in 1:nrow(longLatMat)) {
      airDistanceMatrix[i,j] = ((longLatMat$lon[i]-longLatMat$lon[j])^2 + (longLatMat$lat[i]-longLatMat$lat[j])^2)^0.5
    }
  }
  return(airDistanceMatrix)
}

getClosestNeighbors = function(distanceMatrix, k) {
  diag(distanceMatrix) = 99999
  result = matrix(nrow = nrow(distanceMatrix), ncol = k)
  for (i in 1:nrow(distanceMatrix)) {
    allNeighbors = distanceMatrix[i,]
    allNeighbors = sort(allNeighbors, decreasing = FALSE, index.return = TRUE)
    result[i,] = allNeighbors$ix[1:k]
  }
  return(result)
}

geocodeAddresses = function(addresses) {
  longLats = data.frame(lon = numeric(nrow(addresses)), lat = numeric(nrow(addresses)))
  for (i in 1:nrow(addresses)) {
    if (i %% 10 == 0) print(paste("Progress: ", round(i/nrow(longLats), digits = 2)*100, "% done", sep =))
    res = geocodeAddress(paste(addresses$city[i], addresses$street[i]))
    longLats$lon[i] = res[1]
    longLats$lat[i] = res[2]
  }
  return(longLats)
}

getTravelTimes = function(lonlats, dimension, apiKey = NULL) {
  travelTimes = numeric()
  for (i in 1:nrow(lonlats)) {
    j = 0
    while (j < nrow(lonlats)) {
      url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
      url = paste(url, lonlats$lat[i], ",", lonlats$lon[i], "&destinations=", sep = "")
      additional = 0
      for (k in 1:25) {
        if ((j + k) > nrow(lonlats)) break
        if (i == (j+k)) {
          additional = 1
          next
        }
        url = paste(url, lonlats$lat[j+k], ",", lonlats$lon[j+k], "|", sep = "")
      }
      url = substr(url, 1, (nchar(url)-1))
      if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
      print(url)
      res = fromJSON(url, simplify = FALSE)
      if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
      if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
      print(paste("Length of json", length(res$rows[[1]]$elements)))
      for (k in 1:length(res$rows[[1]]$elements)) {
        travelTimes = c(travelTimes, res$rows[[1]]$elements[[k]]$duration$value)
      }
      #Sys.sleep(1)
      j = j + k + additional
    }
    print(paste(i, "of", nrow(lonlats), "locations queries"))
  }
  return(travelTimes)
}

# works only for up to 25 nearest neighbors
getTravelTimesNearestNeighbor = function(lonlats, nearestNeighbors, apiKey = NULL) {
  travelTimes = numeric()
  if (ncol(nearestNeighbors) > 25) stop(paste("Google Api only supports up to 25 queries"))
  
  for (i in 1:nrow(lonlats)) {
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    url = paste(url, lonlats$lat[i], ",", lonlats$lon[i], "&destinations=", sep = "")
    for (j in 1:ncol(nearestNeighbors)) {
      url = paste(url, lonlats$lat[nearestNeighbors[i,j]], ",", lonlats$lon[nearestNeighbors[i,j]], "|", sep = "")
    }
    url = substr(url, 1, (nchar(url)-1))
    if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
    res = fromJSON(url, simplify = FALSE)
    if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
    if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
    for (k in 1:length(res$rows[[1]]$elements)) {
      travelTimes = c(travelTimes, res$rows[[1]]$elements[[k]]$duration$value)
    }
    print(paste(i, "of", nrow(lonlats), "locations queries"))
  }
  return(travelTimes)
}

getTravelTimesConnections = function(lonlats, connections, apiKey = NULL) {
  travelTimes = numeric()
  if (ncol(nearestNeighbors) > 25) stop(paste("Google Api only supports up to 25 queries"))
  
  for (i in 1:nrow(connections)) {
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    url = paste(url, lonlats$lat[connections[i,1]], ",", lonlats$lon[connections[i,1]], "&destinations=", sep = "")
    url = paste(url, lonlats$lat[connections[i,2]], ",", lonlats$lon[connections[i,2]], sep = "")
    if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
    res = fromJSON(url, simplify = FALSE)
    if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
    if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
    for (k in 1:length(res$rows[[1]]$elements)) {
      travelTimes = c(travelTimes, res$rows[[1]]$elements[[k]]$duration$value)
    }
    #go both ways
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    url = paste(url, lonlats$lat[connections[i,2]], ",", lonlats$lon[connections[i,2]], "&destinations=", sep = "")
    url = paste(url, lonlats$lat[connections[i,1]], ",", lonlats$lon[connections[i,1]], sep = "")
    if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
    res = fromJSON(url, simplify = FALSE)
    if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
    if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
    for (k in 1:length(res$rows[[1]]$elements)) {
      travelTimes = c(travelTimes, res$rows[[1]]$elements[[k]]$duration$value)
    }
    
    print(paste(i, "of", nrow(connections), "locations queries"))
  }
  return(travelTimes)
}

getTravelTimesDepot = function(lonlats, apiKey = NULL) {
  travelTimes = numeric()
  j = 2
  while (j < nrow(lonlats)) {
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    url = paste(url, lonlats$lat[1], ",", lonlats$lon[1], "&destinations=", sep = "")
    for (k in 0:24) {
      if (j+k > nrow(lonlats)) break
      url = paste(url, lonlats$lat[j+k], ",", lonlats$lon[j+k], "|", sep = "")
    }
    url = substr(url, 1, (nchar(url)-1))
    if (k == 0) break
    j = j + k + 1
    if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
    res = fromJSON(url, simplify = FALSE)
    if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
    if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
    for (k in 1:length(res$rows[[1]]$elements)) {
      travelTimes = c(travelTimes, res$rows[[1]]$elements[[k]]$duration$value)
    }
  }
  
  j = 2
  # go both ways
  while (j < nrow(lonlats)) {
    dummy30_travelTimesMat_Depot
    url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
    for (k in 0:24) {
      if (j+k > nrow(lonlats)) break
      url = paste(url, lonlats$lat[j+k], ",", lonlats$lon[j+k], "|", sep = "")
    }
    url = substr(url, 1, (nchar(url)-1))
    url = paste(url, "&destinations=", lonlats$lat[1], ",", lonlats$lon[1], sep = "")
    if (k == 0) break
    j = j + k + 1
    if (!is.null(apiKey)) url = paste(url, "&key=", apiKey, sep = "")
    res = fromJSON(url, simplify = FALSE)
    if (is.null(apiKey)) Sys.sleep(5) # limited queries if no apikey provided
    if (res$status != "OK") stop("Google API query did not return the expected results. Error:", res$status)
    for (k in 1:length(res$rows)) {
      travelTimes = c(travelTimes, res$rows[[k]]$elements[[1]]$duration$value)
    }
  }

  return(travelTimes)
}

getTravelTimesMatrixFromVector = function(travelTimesVector, dimensions) {
  travelTimesMatrix = matrix(nrow = dimensions, ncol = dimensions)
  diag(travelTimesMatrix) = 0
  counter = 1
  for (i in 1:nrow(travelTimesMatrix)) {
    for (j in 1:nrow(travelTimesMatrix)) {
      if (i == j) next
      travelTimesMatrix[i,j] = travelTimesVector[counter]
      counter = counter + 1
    }
  }
  return(travelTimesMatrix)
}

identifySubgraphs = function(nearestNeighbors) {
  # build initial set
  sets = list()
  currentSet = numeric()
  for (i in 1:nrow(nearestNeighbors)) {
    currentNeighbors = i
    currentNeighbors = c(currentNeighbors, nearestNeighbors[i,])
    if (length(sets) == 0) sets = list(currentNeighbors)
    else {
      contained = FALSE
      for (j in 1:length(sets)) {
        if (sum(currentNeighbors %in% sets[[j]]) > 0) {
          sets[[j]] = unique(c(sets[[j]], currentNeighbors))
          contained = TRUE
          break
        }
        if (contained == FALSE) sets = c(sets, list(currentNeighbors))
      }
    }
  }
  
  # combine sets if they have matching elements
  
  repeat {
    changeOccurred = FALSE
    for (i in 1:length(sets)) {
      for (j in (i+1):length(sets)) {
        if (j > length(sets)) break
        if (sum(sets[[i]] %in% sets[[j]]) > 0) {
          changeOccurred = TRUE
          sets[[i]] = unique(c(sets[[i]], sets[[j]]))
          sets[[j]] = NULL
          break
        }
      }
      if (changeOccurred == TRUE) break
    }
    if (changeOccurred == FALSE) break
  } 
  return(sets)
}

# finds the shortest links between all sets
findShortestLink = function(subgraphs, distanceMatrix) {
  diag(distanceMatrix) = max(distanceMatrix)+1
  connections = data.frame(a = numeric(), b = numeric())
  connectedSubgraphs = data.frame(a = numeric(), b = numeric())
  shortestI = 0
  shortestJ = 0
  shortestK = 0
  shortestL = 0
  shortestDistance = max(distanceMatrix)
  for (count in 1:(length(subgraphs)-1)) {
    for (i in 1:length(subgraphs)) {
      for (j in (i+1):length(subgraphs)) {
        if (j > length(subgraphs)) break
        # check if subgraphs are already connected
        if (isConnected(connectedSubgraphs, i, j) == TRUE) break
        
        for (k in 1:length(subgraphs[[i]])) {
          for (l in 1:length(subgraphs[[j]])) {
            if (distanceMatrix[subgraphs[[i]][k],subgraphs[[j]][l]] < shortestDistance) {
              shortestDistance = distanceMatrix[subgraphs[[i]][k],subgraphs[[j]][l]]
              shortestI = i
              shortestJ = j
              shortestK = k
              shortestL = l
            } 
          }
        }
      }
    }
    connections = rbind(connections, c(subgraphs[[shortestI]][shortestK], subgraphs[[shortestJ]][shortestL]))
    connectedSubgraphs = rbind(connectedSubgraphs, shortestI, shortestJ)
  }
  colnames(connections) = c("from", "to")
  return(connections)
}

# helper function
isConnected = function(connectedSubgraphs, subgraph1, subgraph2) {
  if (nrow(connectedSubgraphs) == 0) return(FALSE)
  for (i in 1:nrow(connectedSubgraphs)) {
    if (subgraph1 == connectedSubgraphs[i,1] & subgraph2 == connectedSubgraphs[i,2]) return(TRUE)
    else if (subgraph1 == connectedSubgraphs[i,1]) return(isConnected(connectedSubgraphs, connectedSubgraphs[i,2], subgraph2))
  }
  return(FALSE)
}
