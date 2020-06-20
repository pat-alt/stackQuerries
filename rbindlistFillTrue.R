library(data.table)

dt_list = lapply(5:10, function(i) {
  data.table(rnorm(i))
})
dt=rbindlist(dt_list, fill=T) 
