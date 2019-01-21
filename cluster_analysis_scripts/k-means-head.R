setwd("./")

library(fpc)
library(cluster)
 
 CV <- read.csv("CVS_clustering_for_kmeans.dat")
 
  k=CENTERS #number of centroids

start <-matrix(c(