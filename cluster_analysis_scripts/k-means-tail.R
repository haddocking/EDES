), nrow=CENTERS, ncol=4) 


index <- c()
 model <- kmeans(CV[,1:4],start,iter.max=10000)
 
 #calculate indices of closest instance to centroid
 for (i in 1:k){
   rowsum <- rowSums(abs(CV[which(model$cluster==i),1:4] - model$centers[i,]))
     index[i] <- as.numeric(names(which.min(rowsum)))
     }
 index
a <- model$centers
b <- model$cluster
write.table(index, file ="./matrix_k-means-init-centers.dat",row.names=FALSE)
write.table(b, file ="./matrix_k-means-init-clusters.dat",row.names=FALSE)
