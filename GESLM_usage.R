library("pcalg")
library("plyr")
source("GESLM_function.R")
path = "./data/"
for (maf in c(0.05, 0.1, 0.2, 0.5)) {
  for (rsq in c(0.7, 0.9)){
    out1 = out2 = NULL
    for (i in 1:10) {
      filename<-paste0(path, "rsq", rsq, "_MAF", maf, "_", i, ".csv")
      try <- read.csv(filename)
      out = GESLM(try, alpha = 0.001, outcome_loc = c(1, 2))
      if(!is.null(out$disease1)) {
        out$disease1 <- as.matrix(out$disease1[!duplicated(out$disease1)])
        out1 <- rbind.fill(data.frame(out1),data.frame(t(out$disease1)))
      }
      else{
        out1 <- rbind.fill(data.frame(out1),data.frame("NULL"))
      }
      if(!is.null(out$disease2)) {
        out$disease2 <- as.matrix(out$disease2[!duplicated(out$disease2)])
        out2 <- rbind.fill(data.frame(out2),data.frame(t(out$disease2)))
      }
      else{
        out2 <- rbind.fill(data.frame(out2),data.frame("NULL"))
      }
    }
    write.csv(out1, paste0("./result/rsq", rsq, "_MAF", maf, "_D1.csv"), row.names = F, na = "NA")
    write.csv(out2, paste0("./result/rsq", rsq, "_MAF", maf, "_D2.csv"), row.names = F, na = "NA")
  }
}
