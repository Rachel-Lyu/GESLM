library("pcalg")
library("plyr")
source("GESLM_function.R")
path = "/home/ug2018/ug518111910005/RqLyu/GESLM/bal/"

## tuning by computing the standard deviation and the mean value of the count of the results
## just use part of the sample (500 here)

cal_count = NULL
for (maf in c(0.2)) {
  for (rsq in c(0.7)){
    for (alpha in c(10^(-seq(1, 4, by = 0.5)))){
      count = c()
      ### run 10 loops to collect counting values
      for (i in 1:10) {
        filename<-paste0(path, "rsq", rsq, "_MAF", maf, "_", i, ".csv")
        try <- read.csv(filename)
        ### training sample size = 500 here
        out = GESLM(try[1:500,], alpha = alpha, outcome_loc = c(1, 2))
        if(is.null(out$disease1)){
          count1 = 0
        }else{
          out$disease1 <- as.matrix(out$disease1[!duplicated(out$disease1)])
          count1 = length(out$disease1)
        }
        if(is.null(out$disease2)){
          count2 = 0
        }else{
          out$disease2 <- as.matrix(out$disease2[!duplicated(out$disease2)])
          count2 = length(out$disease2)
        }
        count = c(count, mean(c(count1, count2)))
      }
      cal_count <- rbind.fill(data.frame(cal_count),data.frame(t(count)))
    }
  }
}
print(cal_count)
print(rowMeans(cal_count))
sd_cnt = c()
for(i in 1:nrow(cal_count)){
  sd_cnt = c(sd_cnt, sd(as.matrix(cal_count[i, ])))
}
print(sd_cnt)

## results for example
# mean: 3.55 2.90 2.45 2.20 2.10 1.80 1.70
# sd: 0.8959787 0.7378648 0.4972145 0.2581989 0.2108185 0.4216370 0.4830459
# So alpha = 0.001 is what we choose in application