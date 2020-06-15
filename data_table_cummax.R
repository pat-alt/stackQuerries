library(data.table)

df <- structure(list(
  day = structure(c(18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116, 18116), class = "Date"), 
  hour = structure(c(1565275500, 1565276400, 1565277300, 1565278200, 1565279100, 1565280000, 1565280900, 1565281800, 1565282700, 1565275500, 1565276400, 1565277300, 1565278200, 1565279100, 1565280000, 1565280900, 1565281800, 1565282700), class = c("POSIXct", "POSIXt"), tzone = ""), 
  department = c("DPT1", "DPT1", "DPT1", "DPT1", "DPT1", "DPT1", "DPT1", "DPT1", "DPT1", "DPT2", "DPT2", "DPT2", "DPT2", "DPT2", "DPT2", "DPT2", "DPT2", "DPT2"), 
  amount = c(2, 3, 3, 2, 0, 0, 1, 2, 1, 3, 3, 3, 2, 2, 3, 0, 0, 0), max_cond = c(3, 3, 3, 2, 2, 2, 2, 2, 1, 3, 3, 3, 3, 3, 3, 0, 0, 0)), row.names = c(NA, -18L), class = "data.frame")

dt = data.table(df)
setorder(dt, -hour)
dt[,max_cond_new:=cummax(amount),by=.(day,department)]
setorder(dt, department, hour)
