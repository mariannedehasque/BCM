setwd("/Users/marianne/OneDrive/NRM/Rscripts/BCM/admixtools/data")

library(ggplot2)
library(scales)

#Disable scientific notation
options(scipen=999)

data <- read.table("BCM.ALL.autosomes_combined_BBAA.txt", header=TRUE)

#NORTH AMERICAN MAMMOTHS
FOCAL <- c("Mcolumbi-U.ERR2260506","Mammuthus-bcm004", "Mammuthus-bcm019",  "Mammuthus-V.ERR2260507")
data$P2[!(data$P2 %in% FOCAL)] <- "Mammuthus-Siberia"

#KRESTOVKA as P3
dKrestovka<-data[data$P3=="Mammuthus-Krestovka",]
#REMOVE NORTH AMERICAN MAMMOTHS FROM P1
dKrestovka <- dKrestovka[!(dKrestovka$P1 %in% c("Mammuthus-bcm019","Mammuthus-bcm004", "Mammuthus-V.ERR2260507")),]
#ORDER DATA BECAUSE PRETTY
dKrestovka <- dKrestovka[order(dKrestovka$P1), ]

#MCOLUMBI AS P3
dCol<-data[data$P3=="Mcolumbi-U.ERR2260506",]
dCol<- dCol[!(dCol$P1 %in% c("Mammuthus-bcm019","Mammuthus-bcm004", "Mammuthus-V.ERR2260507")),]
#ORDER DATA BECAUSE PRETTY
dCol <- dCol[order(as.factor(dCol$P1)), ]

#FACTOR TO CONTROL FOR ORDER
dKrestovka$P2 <- factor(dKrestovka$P2, levels = c("Mcolumbi-U.ERR2260506",
                                                  "Mammuthus-bcm004",
                                                  "Mammuthus-bcm019", 
                                                  "Mammuthus-V.ERR2260507",
                                                  "Mammuthus-Siberia"))
dCol$P2 <- factor(dCol$P2, levels = c("Mammuthus-bcm004",
                                      "Mammuthus-bcm019", 
                                      "Mammuthus-V.ERR2260507",
                                      "Mammuthus-Siberia"))

#READ IN DATA
dataX <- read.table("BCM.X_BBAA.txt", header=TRUE)

#NORTH AMERICAN MAMMOTHS
FOCAL <- c("Mcolumbi-U.ERR2260506","Mammuthus-bcm004", "Mammuthus-bcm019",  "Mammuthus-V.ERR2260507")
dataX$P2[!(dataX$P2 %in% FOCAL)] <- "Mammuthus-Siberia"

#MCOLUMBI AS P3
dColX<-dataX[dataX$P3=="Mcolumbi-U.ERR2260506",]
dColX<- dColX[!(dColX$P1 %in% c("Mammuthus-bcm019","Mammuthus-bcm004", "Mammuthus-V.ERR2260507")),]

#ORDER DATA BECAUSE PRETTY
dColX <- dColX[order(as.factor(dColX$P1)), ]

#FACTOR TO CONTROL FOR ORDER
dColX$P2 <- factor(dColX$P2, levels = c("Mammuthus-bcm004",
                                      "Mammuthus-bcm019", 
                                      "Mammuthus-V.ERR2260507",
                                      "Mammuthus-Siberia"))

#SIGNIFICANT VS NON-SIGNIFICANT RESULTS
significantkres <- dKrestovka[dKrestovka$Z.score>=3,]
nonsignificantkres <- dKrestovka[dKrestovka$Z.score<3,]
significantcol <- dCol[dCol$Z.score>=3,]
nonsignificantcol <- dCol[dCol$Z.score<3,]
significantcolX <- dColX[dColX$Z.score>=3,]
nonsignificantcolX <- dColX[dColX$Z.score<3,]


# Compute informative sites
dKrestovka$sites <- (dKrestovka$ABBA + dKrestovka$BABA)/1000
dCol$sites <- (dCol$ABBA + dCol$BABA)/1000
dColX$sites <- (dColX$ABBA + dColX$BABA)/1000

# Compute mean and standard error per P2 category
dKrestovka_avgsites <- tapply(dKrestovka$sites, dKrestovka$P2, mean)
dKrestovka_sd <- tapply(dKrestovka$sites, dKrestovka$P2, sd)

dCol_avgsites <- tapply(dCol$sites, dCol$P2, mean)
dCol_sd <- tapply(dCol$sites, dCol$P2, sd)

dColX_avgsites <- tapply(dColX$sites, dColX$P2, mean)
dColX_sd <- tapply(dColX$sites, dColX$P2, sd)

# Combine data
all_avgsites <- rbind(dCol_avgsites, dColX_avgsites)

##########################################
#################  FIGURE ################
##########################################

png("Dsuite_MDE_noCpG_rotated.png", width = 7, height = 6, units = "in", res = 300)

layout(matrix(c(1, 2, 
                3, 4), ncol = 2), heights = c(1, 2))

#PLOT 1: Informative Sites Krestovka
par(mar = c(1, 5, 4, 2))
bp <- barplot(dKrestovka_avgsites, las=2, border="black", col="grey30", xaxt='n',
              ylab="Mean K sites", main="Mammmuthus Krestovka as outgroup", cex.main=0.8,
              yaxs="i", xaxs="i", space=0.25,
              ylim=c(0, max(dKrestovka_avgsites * 1.1)))
box()

# Compute upper limits of error bars
upper_dKrestovka <- dKrestovka_avgsites + dKrestovka_sd

# Add error bars
arrows(bp, dKrestovka_avgsites, bp, upper_dKrestovka, angle=90, code=3, length=0.05)


#PLOT 2: D-statistics Krestovka
par(mar = c(5, 5, 2, 2))
plot(as.numeric(dKrestovka$P2), dKrestovka$Dstatistic, pch = 16, col = "white", 
     xlim = c(0.5, 5.5), ylim=c(-0.05,0.45),
     ylab = "D-statistic", xlab = "",
     main = "",
     xaxt = 'n',
     yaxs="i", xaxs="i")

axis(1, at = 1:5, labels = c("Mcolumbi", "BCM004", "BCM019", "Wyoming", "Siberia"), las = 2)

abline(v=c(1.5,2.5,3.5,4.5), col="gray40",lty = 2)

points(jitter(as.numeric(significantkres$P2), 0.5), significantkres$Dstatistic, 
       bg = "grey30", pch = 21, cex=1.2)
points(jitter(as.numeric(nonsignificantkres$P2), 0.5), nonsignificantkres$Dstatistic, 
       bg = alpha("grey90", 0.5), pch = 21, cex=1.2)

#PLOT 3: Informative Sites Columbi
par(mar = c(1, 5, 4, 2))

bar_colors <- c("grey30", "#528AAE")

bp <- barplot(all_avgsites, beside=TRUE, las=2, border="black", col=bar_colors, log='y',
              xaxt='n', yaxt='n', ylab="Mean K sites", main="Mammmuthus Columbi as outgroup", 
              cex.main=0.8, yaxs="i", xaxs="i",
              ylim=c(0.01, max(all_avgsites * 2)))
box()
axis(2, at=c(1, 10, 100), labels=c("1", "10", "100"), las=1)

# Compute upper limits of error bars
upper_dCol <- dCol_avgsites + dCol_sd
upper_dColX <- dColX_avgsites + dColX_sd

# tibble to vector
bp_flat <- as.vector(bp)
values <- as.vector(all_avgsites)
errors <- as.vector(rbind(dCol_sd, dColX_sd))

# Add error bars 
arrows(bp_flat, values, bp_flat, values + errors, angle=90, code=3, length=0.05)

#PLOT 4: D-statistics Columbi
par(mar = c(5, 5, 2, 2))
plot(as.numeric(dCol$P2), dCol$Dstatistic, pch = 16, col = "white", 
     xlim = c(0.5, 4.5), ylim=c(-0.05,0.45),
     ylab = "D-statistic", xlab = "",
     main = "",
     xaxt = 'n',
     yaxs="i", xaxs="i")

axis(1, at = 1:4, labels = c("BCM004", "BCM019", "Wyoming", "Siberia"), las = 2)

abline(v=c(1.5,2.5,3.5), col="gray40",lty = 2)
legend("topright", 
       legend = c("Autosome", "X"),
       col = c("black","#528AAE" ), 
       pch = c(16,18), cex = 1.1, bg="white")

points(jitter(as.numeric(significantcol$P2), 0.5)-0.15, significantcol$Dstatistic, 
       bg = "grey30", pch = 21, cex=1.2)
points(jitter(as.numeric(nonsignificantcol$P2), 0.5)-0.15, nonsignificantcol$Dstatistic, 
       bg = alpha("grey90", 0.5), pch = 21, cex=1.2)

points(jitter(as.numeric(significantcolX$P2), 0.5)+0.15, significantcolX$Dstatistic, 
       bg = "#528AAE", pch = 23, cex=1.2)
points(jitter(as.numeric(nonsignificantcolX$P2), 0.5)+0.15, nonsignificantcolX$Dstatistic, 
       bg = alpha("#73A5C6", 0.2), pch = 23, cex=1.2)



dev.off()