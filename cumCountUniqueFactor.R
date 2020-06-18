library(data.table)
set.seed(1)
toy_data = data.table(
  region = sample(LETTERS[1:3], 10, replace = T),
  wave = c(rep(1,5),rep(2,5))
)
toy_data[,count:=cummax(match(region, unique(region))), wave]
# > toy_data
#     region wave count
#  1:      A    1     1
#  2:      C    1     2
#  3:      A    1     2
#  4:      B    1     3
#  5:      A    1     3
#  6:      C    2     1
#  7:      C    2     1
#  8:      B    2     2
#  9:      B    2     2
# 10:      C    2     2