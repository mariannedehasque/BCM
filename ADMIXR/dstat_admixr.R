setwd("/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ADMIXR")

library(admixr)
library(dplyr)

prefix <- "BCM.SampleID.snps.NewChr.X.Dsuite.SUBSET"
snps <- eigenstrat(prefix)

Mprim <- c("Mammuthus-bcm004.bam", "Mammuthus-bcm019.bam", 
           "Mammuthus-L163.bam", "Mammuthus-L164.bam", "Mammuthus-M6.bam", 
           "Mammuthus-MD090.bam", "Mammuthus-oimyakon.ERR852028.bam", "Mammuthus-P004.bam", 
           "Mammuthus-P005.bam", "Mammuthus-V.ERR2260507.bam", "Mammuthus-Yuka.bam", 
           "Mammuthus-H.ERR2260502.bam","Mcolumbi-U.ERR2260506.bam")

dresults <- tibble()

for (Y in c("Mcolumbi-U.ERR2260506.bam", "35bp.Mammuthus-Krestovka.bam")) {
  
  for (W in Mprim) {
    
    for (X in Mprim) {
      # Skip if W and X are the same sample or if X comes before W in Mprim
      if (W == X || which(W == Mprim) > which(X == Mprim)) next
      
      # Run the D-statistic for this combination
      dresult <- d(Y = Y, Z = "Lafricana", W = W, X = X, data = snps)

      # Append result to tibble
      dresults <- bind_rows(dresults, dresult)
    }
  }
}

write.csv(dresults, "Dstats_results_X_noPrune.csv", row.names = FALSE)