setwd("/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ADMIXR")

library(admixr)
library(dplyr)

prefix <- "BCM.SampleID.snps.NewChr.X.Dsuite.SUBSET.Siberia"
snps <- eigenstrat(prefix)

Mprim_AM <- c("Mammuthus-bcm004.bam", "Mammuthus-bcm019.bam", 
              "Mammuthus-V.ERR2260507.bam", "Mammuthus-H.ERR2260502.bam","Mcolumbi-U.ERR2260506.bam")

dresults <- tibble()

for (Y in c("Mcolumbi-U.ERR2260506.bam", "35bp.Mammuthus-Krestovka.bam")) {
  
  for (W in Mprim_AM) {
    
      # Run the D-statistic for this combination
      dresult <- d(Y = Y, Z = "Lafricana", W = W, X = "Siberia", data = snps)

      # Append result to tibble
      dresults <- bind_rows(dresults, dresult)

  }
}

write.csv(dresults, "Dstats_results_X_Siberia_noPrune.csv", row.names = FALSE)