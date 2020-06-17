library(data.table)
library(ggplot2)

# Simulate data:
set.seed(1)
n_cluster = 50
centroids = cbind.data.frame(
  x=rnorm(5, mean = 0, sd=5),
  y=rnorm(5, mean = 0, sd=5)
)
dt = rbindlist(
  lapply(
    1:nrow(centroids),
    function(i) {
      cluster_dt = data.table(
        x = rnorm(n_cluster, mean = centroids$x[i]),
        y = rnorm(n_cluster, mean = centroids$y[i]),
        cluster = i
      )
    }
  )
)
dt[,cluster:=as.factor(cluster)]

# Find convex hull of each point:
hulls = dt[,.SD[chull(x,y)],by=.(cluster)]

# Plot:
p = ggplot(data = dt, aes(x=x, y=y, colour=cluster)) +
  geom_point() +
  geom_polygon(data = hulls,aes(fill=cluster,alpha = 0.5)) +
  guides(alpha=F)

# Estimate clusters (e.g. kmeans):
dt[,km_cluster := as.factor(kmeans(.SD,5)$cluster),.SDcols=c("x","y")]

# Find convex hull of each point:
hulls = dt[,.SD[chull(x,y)],by=.(km_cluster)]

# Plot:
p = ggplot(data = dt, aes(x=x, y=y, colour=km_cluster)) +
  geom_point() +
  geom_polygon(data = hulls,aes(fill=km_cluster,alpha = 0.5)) +
  guides(alpha=F)




