setwd("~/OneDrive/NRM/Rscripts/BCM/Heterozygosity/elemax")

library(plyr)
library(dplyr)

dkcol="#32527B"
ltcol="#98a4bb"



hetdatafiles=list.files(pattern=".1.txt")
allhet=ldply(hetdatafiles, read.table, header=TRUE, sep="\t")

# Calculate heterozygosity for each sample
samples <- c("bcm004", "L163", "L164","M6","MD090","oimyakon", "P004", "P005", "Yuka")
names<-c("BC25.3K","Chu17.0K","Chu31.9K","Wra24.0K","Yak52.3K", "Oim44.2K","NSI12.2K", "NSI12.8K", "Yuka")


# Get unique chromosome names
unique_chroms <- sort(unique(allhet$chrom))
# Create new names - chr1 until chr28
new_names <- paste0("chr", seq_along(unique_chroms))
# Create a named vector for mapping
chrom_map <- setNames(new_names, unique_chroms)
# Replace old names with new ones
allhet$chrom <- chrom_map[allhet$chrom]

#Order chromosomes from chr1, chr2..chr28
goodChrOrder <- paste("chr",c(1:27),sep="")
allhet$chrom <- factor(allhet$chrom,levels=goodChrOrder)

totalhet_summary <- data.frame(sample = character(0), totalhet = numeric(0))

png("heterozygosity.png", width = 2500, height = 6000, res = 300)

plot.new()
layout(matrix(c(1,2,3,4,5,6,7,8,9), ncol=1))
par(mar=c(2,4,3,1))

for (i in 1:length(samples)) {

  hets_col <- paste0("hets_", samples[i]) #select correct sample
  
  allhet <- allhet %>% filter(sites_total != 0) #remove rows with zero sites
  heterozygosity <- allhet[[hets_col]]/allhet$sites_total
  allhet <- allhet %>%
    mutate(heterozygosity = ifelse(is.na(!!sym(hets_col)) | sites_total == 0, 0, !!sym(hets_col) / sites_total)) #add heterozygosity column. If division is zero, add zero
  total_heterozygosity <- sum(heterozygosity)/length(heterozygosity) * 1000
  totalhet <- format(round(total_heterozygosity, 4), nsmall = 2) #Formatting
  
  totalhet_summary <- rbind(totalhet_summary, data.frame(sample = samples[i], totalhet = totalhet))
  
  allhet$color <- ifelse(as.numeric(sub("chr", "", allhet$chrom)) %% 2 == 1, dkcol, ltcol)
  mylabels=goodChrOrder
  hide_labels <- which(mylabels %in% c("chr11", "chr13", "chr15", "chr17", "chr19", "chr21", "chr23", "chr24","chr25", "chr27"))
  mylabels[hide_labels] <- ""
  
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
  
  chrom_midpoints <- tapply(barpos, allhet$chrom,mean)
  
  # Add chromosome label
  text(chrom_midpoints, -0.15, labels = mylabels, xpd = TRUE, cex = 0.8)

}

dev.off()


barplot(as.numeric(totalhet_summary$totalhet),
        ylim=c(0,1.5))

setwd("/Users/marianne/OneDrive/NRM/Rscripts/BCM/Heterozygosity")

# Values calculated above
sample <- c('bcm004', 'L163', 'L164', 'M6', 'MD090', 'oimyakon', 'P004', 'P005', 'Yuka')
totalhet <- c(1.1668, 1.0195, 1.0163, 1.0912, 0.9597, 0.9281, 1.052, 0.9841, 0.9546)

# Separate bcm004 and the others
bcm004_het <- totalhet[sample == "bcm004"]
siberian_het <- totalhet[sample != "bcm004"]

pdf("Heterozygosity_boxplot.pdf", width = 4, height = 3)

par(family = "Helvetica", ps = 11)
par(mar = c(3, 4, 1, 2))
# Set up the plot area with x-axis from 1 to 2
plot(1, bcm004_het, xlim = c(0.5, 2.5), 
     xaxt = "n", xlab = "", ylab = "Genome-wide heterozygosity", ylim=c(0.9,1.2),
     bg = "#7393B3", pch = 21, cex = 1.5, main = "")

# Add boxplot for Siberian mammoths at position 2
boxplot(siberian_het, at = 2, add = TRUE, col = "grey50", boxwex = 0.5)

# Customize x-axis
axis(1, at = c(1, 2), labels = c("BC25.3k", "Siberian mammoths"))
dev.off()