setwd("/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ADMIXR")

library(admixr)
library(dplyr)

prefix <- "BCM.SampleID.snps.NewChr.autos.Dsuite.SUBSET"
snps <- eigenstrat(prefix)

prefixX <- "BCM.SampleID.snps.NewChr.X.Dsuite.SUBSET"
snpsX <- eigenstrat(prefixX)

pops<-c("Mammuthus-bcm004.bam","Mammuthus-bcm019.bam", "Mammuthus-V.ERR2260507.bam", "Mammuthus-H.ERR2260502.bam","Mammuthus-bcm004.bam","Mammuthus-bcm019.bam", "Mammuthus-V.ERR2260507.bam", "Mammuthus-H.ERR2260502.bam")
donor<-c("Mcolumbi-U.ERR2260506.bam", "Mcolumbi-U.ERR2260506.bam", "Mcolumbi-U.ERR2260506.bam","Mcolumbi-U.ERR2260506.bam","35bp.Mammuthus-Krestovka.bam", "35bp.Mammuthus-Krestovka.bam","35bp.Mammuthus-Krestovka.bam","35bp.Mammuthus-Krestovka.bam")

result_f4ratio_autos <- f4ratio(
    X = pops, A = "Mammuthus-M6.bam", B = "Mammuthus-oimyakon.ERR852028.bam", C = donor, O = "Lafricana",
    data = snps
)

pops<-c("Mammuthus-bcm004.bam", "Mammuthus-bcm019.bam", "Mammuthus-V.ERR2260507.bam", "Mammuthus-H.ERR2260502.bam")
result_f4ratio_X <- f4ratio(
    X = pops, A = "Mammuthus-M6.bam", B = "Mammuthus-oimyakon.ERR852028.bam", C = "Mcolumbi-U.ERR2260506.bam", O = "Lafricana",
    data = snpsX
)

write.csv(result_f4ratio_autos, file = "f4ratio_autos.csv", row.names = FALSE)

# Save X chromosome results to a CSV file
write.csv(result_f4ratio_X, file = "f4ratio_X.csv", row.names = FALSE)
