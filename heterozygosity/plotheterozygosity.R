setwd("~/OneDrive/NRM/Rscripts/BCM/Heterozygosity")

library(plyr)

dkcol="#32527B"
ltcol="#98a4bb"

hetdatafiles=list.files(pattern=".txt")
allhet=ldply(hetdatafiles, read.table, header=TRUE, sep="\t")

# Calculate heterozygosity for each sample
samples <- c("bcm004", "P004", "P005", "L164","M6", "L163","oimyakon","MD090")
names<-c("BC25.3K","NSI12.2K", "NSI12.8K","Chu17.0K","Wra24.0K","Chu31.9K", "Oim44.2K","Yak52.3K")

png("heterozygosity.png", width = 2500, height = 6000, res = 300)

plot.new()
layout(matrix(c(1,2,3,4,5,6,7,8), ncol=1))
par(mar=c(2,4,3,1))

for (i in 1:length(samples)) {

  hets_col <- paste0("hets_", samples[i])
  heterozygosity <- allhet[[hets_col]] / allhet$sites_total
  total_heterozygosity <-sum(allhet[[hets_col]])/sum(allhet$sites_total)*1000
  totalhet <- format(round(total_heterozygosity, 4), nsmall = 2)


  goodChrOrder <- paste("chr",c(1:27),sep="")
  allhet$chrom <- factor(allhet$chrom,levels=goodChrOrder)
  allhet <- allhet[order(allhet$chrom),]

  allhet$color <- ifelse(as.numeric(sub("chr", "", allhet$chrom)) %% 2 == 1, dkcol, ltcol)
  mylabels=goodChrOrder
  hide_labels <- which(mylabels %in% c("chr11", "chr13", "chr15", "chr17", "chr19", "chr21", "chr23", "chr24","chr25", "chr27"))
  mylabels[hide_labels] <- ""
  chrom_midpoints <- tapply(barpos, allhet$chrom, mean)

  #Plot
  barpos<-barplot(heterozygosity*1000,
          names.arg = allhet$window_start,
          main= paste(names[i],"\n", "mean heterozygosity:", totalhet, "per kb"),
          xlab = "",
          ylab = "Heterozygosity per kb",
          axisnames = FALSE,
          border  = allhet$color,
          col = allhet$color,
          ylim=c(0,6))

  # Add chromosome label
  text(chrom_midpoints, -0.15, labels = mylabels, xpd = TRUE, cex = 0.8)

}

dev.off()
