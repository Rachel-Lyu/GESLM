library("pcalg")
library("plyr")

GESLM <- function(data, alpha = 0.001, outcome_loc = c(1, 2)){
  suffStat <-list(C = cor(data), n = nrow(data))
  score <- new("GaussL0penObsScore", suffStat$C)
  ges.fit <- ges(score)
  selected <- c(outcome_loc)
  for (idx in outcome_loc) {
    selected = c(selected, ges.fit[["essgraph"]][[".->.in.edges"]][[idx]])
  }
  for (item in c(1:ncol(data))[-outcome_loc]) {
    flag = F
    for (idx in outcome_loc) {
      if(idx %in% ges.fit[["essgraph"]][[".->.in.edges"]][[item]]){
        flag = T
        break
      }
    }
    if(flag){
      selected <- c(selected, item)
    }
  }
  selected <- selected[!duplicated(selected)]
  firstOutput <- names(ges.fit$essgraph$`.->.in.edges`[selected])
  smalldata <-list(C = cor(data[selected]), n = nrow(data))
  fciPlus.gmL <- fciPlus(smalldata, indepTest=gaussCItest,
                         alpha = alpha, labels =names(data[selected]))
  record = list()
  for (idx in outcome_loc) {
    rec = names(c(fciPlus.gmL@amat[colnames(fciPlus.gmL@amat)[idx],which(fciPlus.gmL@amat[colnames(fciPlus.gmL@amat)[idx],]>0)], fciPlus.gmL@amat[which(fciPlus.gmL@amat[,colnames(fciPlus.gmL@amat)[idx]]>0),colnames(fciPlus.gmL@amat)[idx]]))
    if(!is.null(rec)) {
      rec <- as.matrix(rec[!duplicated(rec)])
      record[[colnames(fciPlus.gmL@amat)[idx]]] = rec
    }
  }
  return(record = record)
}