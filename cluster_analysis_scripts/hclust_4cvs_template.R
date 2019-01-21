#############################################
#CV Clustering Analysis Script: Hierarchical Clustering 
29-30/01/2017
##############################################
#### install.packages("randomForest", repos="http://cran.cnr.berkeley.edu")
###

# Install R packages

#install.packages("fpc")

#install.packages("cluster")

#install.packages("rgl")

# Recall packages
setwd("./")

library(fpc)
library(cluster)
library(flashClust)
#library(rgl)

# Read the data and put it as a string
CV <- read.csv("FILENAME")
str(CV)
# Scale the data to allow the clustering | compulsory for hclust()
data <- scale(CV)

#### Choose the number of clusters 
k=NCLUSTER
####
# Perform the clustering and cut the tree into k clusters
d <- dist(data[,1:4],method = "euclidean")

hclust.fit1 <- flashClust(d, method="ward")

groups1 <- cutree(hclust.fit1, k) # cut tree into k clusters

###### Extract the cluster representative for each cluster

index_min <- c()
#index <- matrix(nrow=nrow(cluster1), ncol=3)
matrice_dei_rappresentativi <- matrix(nrow=k, ncol=5)  # N° CVs +1 (row number) +2: window number + index
indice_finale <- c()

for(i in 1:k) {                                            # For each of the k clusters
cluster1 <- CV[groups1 ==i,]                               # Select this cluster
distanceMatrix <- matrix(nrow=nrow(cluster1), ncol=1)      # Build a matrix with a single column and the number of rows equal to the number of items in the cluster

for(j in 1:nrow(cluster1)){                                # For each row (item) j of a cluster write in the line j of the distance matrix the distance between this point and the center of the cluster. The n-th coordinate of the center is calculated as the mean among all the n-th coordinates of the entries

distanceMatrix[j] = sqrt((cluster1[j,1]-mean(cluster1[[1]]))^2+(cluster1[j,2]-mean(cluster1[[2]]))^2 + (cluster1[j,3]-mean(cluster1[[3]]))^2 + (cluster1[j,4]-mean(cluster1[[4]]))^2) 

}
index_min[i] <- which.min(distanceMatrix)  

matrice_dei_rappresentativi[i,1] <- row.names(cluster1[index_min[i],])
matrice_dei_rappresentativi[i,2] <- cluster1[index_min[i],1]
matrice_dei_rappresentativi[i,3] <- cluster1[index_min[i],2]
matrice_dei_rappresentativi[i,4] <- cluster1[index_min[i],3]
matrice_dei_rappresentativi[i,5] <- cluster1[index_min[i],4]

indice_finale[i] <- row.names(cluster1[index_min[i],])  
}
write.table(indice_finale, file ="./OUTPUTNAME",row.names=FALSE)
write.table(matrice_dei_rappresentativi, file ="./OUTPUTNAMEmatrix",row.names=FALSE)



##########################################################


