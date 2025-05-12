library(dplyr)
library(scales)

setwd("/Users/marianne/OneDrive/NRM/Rscripts/BCM/admixr")
data<-read.csv("Dstats_results_autos_Siberia_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)

FOCAL <- c("Mcolumbi-U.ERR2260506", "Mammuthus-bcm004", "Mammuthus-bcm019",  
           "Mammuthus-V.ERR2260507", "Mammuthus-H.ERR2260502")

data <- data %>%
  # Remove .bam only from character columns
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  
  # Remove rows where both W and X are in FOCAL
  filter(!(W %in% FOCAL & X %in% FOCAL)) %>%
  
  # Create W2, X2, and Zscore2 based on conditions
  mutate(
    W2 = case_when(
      W %in% FOCAL ~ W,
      X %in% FOCAL ~ X,
      TRUE ~ W  # If neither W nor X are in FOCAL, copy W
    ),
    X2 = case_when(
      W %in% FOCAL ~ X,
      X %in% FOCAL ~ W,
      TRUE ~ X  # If neither W nor X are in FOCAL, copy X
    ),
    D2 = case_when(
      W %in% FOCAL ~ D,
      X %in% FOCAL ~ -D,
      TRUE ~ D  # If neither W nor X are in FOCAL, keep original Zscore
    )
  ) %>%
  
  # Convert necessary numeric columns back to numeric
  mutate(across(c(stderr, D, Zscore, D2, ABBA, BABA, nsnps), as.numeric))


#RENAME SIBERIAN MAMMOTHS
data$W2[!(data$W2 %in% FOCAL)] <- "Mammuthus-Siberia"

#KRESTOVKA as Y
dKrestovka<-data[data$Y=="35bp.Mammuthus-Krestovka",]

#MCOLUMBI AS Y
dCol<-data[data$Y=="Mcolumbi-U.ERR2260506",]

#FACTOR TO CONTROL FOR ORDER
dKrestovka$W2 <- factor(dKrestovka$W2, levels = c("Mcolumbi-U.ERR2260506",
                                                  "Mammuthus-bcm004",
                                                  "Mammuthus-bcm019", 
                                                  "Mammuthus-V.ERR2260507",
                                                  "Mammuthus-H.ERR2260502",
                                                  "Mammuthus-Siberia"))

dKrestovka <- dKrestovka[order(dKrestovka$W2), ]

dCol$W2 <- factor(dCol$W2, levels = c("Mammuthus-bcm004",
                                      "Mammuthus-bcm019", 
                                      "Mammuthus-V.ERR2260507",
                                      "Mammuthus-H.ERR2260502",
                                      "Mammuthus-Siberia"))
dCol <- dCol[order(dCol$W2), ]
#READ IN DATA
dataX <- read.csv("Dstats_results_X_Siberia_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)

dataX <- dataX %>%
  # Remove .bam only from character columns
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  
  # Remove rows where both W and X are in FOCAL
  filter(!(W %in% FOCAL & X %in% FOCAL)) %>%
  
  # Create W2, X2, and Zscore2 based on conditions
  mutate(
    W2 = case_when(
      W %in% FOCAL ~ W,
      X %in% FOCAL ~ X,
      TRUE ~ W  # If neither W nor X are in FOCAL, copy W
    ),
    X2 = case_when(
      W %in% FOCAL ~ X,
      X %in% FOCAL ~ W,
      TRUE ~ X  # If neither W nor X are in FOCAL, copy X
    ),
    D2 = case_when(
      W %in% FOCAL ~ D,
      X %in% FOCAL ~ -D,
      TRUE ~ D  # If neither W nor X are in FOCAL, keep original Zscore
    )
  ) %>%
  
  # Convert necessary numeric columns back to numeric
  mutate(across(c(stderr, D, Zscore, D2, ABBA, BABA, nsnps), as.numeric))

dataX$W2[!(dataX$W2 %in% FOCAL)] <- "Mammuthus-Siberia"

#MCOLUMBI AS Y
dColX<-dataX[dataX$Y=="Mcolumbi-U.ERR2260506",]

#ORDER DATA BECAUSE PRETTY
dColX <- dColX[order(as.factor(dColX$X2)), ]

#FACTOR TO CONTROL FOR ORDER
dColX$W2 <- factor(dColX$W2, levels = c("Mammuthus-bcm004",
                                        "Mammuthus-bcm019", 
                                        "Mammuthus-V.ERR2260507",
                                        "Mammuthus-H.ERR2260502",
                                        "Mammuthus-Siberia"))

#SIGNIFICANT VS NON-SIGNIFICANT RESULTS
significantkres <- dKrestovka[abs(dKrestovka$Zscore)>=3,]
nonsignificantkres <- dKrestovka[abs(dKrestovka$Zscore)<3,]
significantcol <- dCol[abs(dCol$Zscore)>=3,]
nonsignificantcol <- dCol[abs(dCol$Zscore)<3,]
significantcolX <- dColX[abs(dColX$Zscore)>=3,]
nonsignificantcolX <- dColX[abs(dColX$Zscore)<3,]


# Compute informative sites
dKrestovka$sites <- (dKrestovka$ABBA + dKrestovka$BABA)/1000
dCol$sites <- (dCol$ABBA + dCol$BABA)/1000
dColX$sites <- (dColX$ABBA + dColX$BABA)/1000

all_sites <- rbind(dCol$sites,dColX$sites)

f4ratio_auto<-read.csv("f4ratio_autos_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)
f4ratio_auto <- f4ratio_auto %>%
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  filter(C == "Mcolumbi-U.ERR2260506")

f4ratio_X<-read.csv("f4ratio_X_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)
f4ratio_X <- f4ratio_X %>%
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  filter(C == "Mcolumbi-U.ERR2260506")

#FACTOR TO CONTROL FOR ORDER
f4ratio_auto$X <- factor(f4ratio_auto$X, levels = c("Mammuthus-bcm004",
                                                    "Mammuthus-bcm019", 
                                                    "Mammuthus-V.ERR2260507",
                                                    "Mammuthus-H.ERR2260502"))
f4ratio_X$X <- factor(f4ratio_X$X, levels = c("Mammuthus-bcm004",
                                              "Mammuthus-bcm019", 
                                              "Mammuthus-V.ERR2260507",
                                              "Mammuthus-H.ERR2260502"))

#############################################################
#################  FIGURE ################
#############################################################

pdf("admixr_autosomes_X_ratios_Siberia_noPrune_version2.pdf", width = 6, height = 8)

par(family = "Helvetica", ps = 12)
layout(matrix(c(1, 2,  
                3, 4,  
                5, 5), ncol = 2, byrow = TRUE), 
       heights = c(0.75, 1.5, 1))  # Adjust heights as needed

#layout(matrix(c(1, 2, 3, 4), ncol = 2), heights = c(1, 2))

# --- PLOT 1: Informative Sites for Krestovka (Vertical Bar Plot) ---
par(mar = c(1, 5, 4, 1))
bp <- barplot(dKrestovka$sites, las=2, border="black", col="grey30", xaxt='n',
              ylab="Number of sites x 1000", main="Krestovka mammoth as P3", cex.main=1.3,
              yaxs="i", xaxs="i", space=0.25,
              ylim=c(0, max(dKrestovka$sites * 1.1)))
box()

# --- PLOT 3: Informative Sites for Columbi (Vertical Bar Plot) ---
par(mar = c(1, 5, 4, 1))

# Define bar colors
bar_colors <- c("grey30", "#2E8B57")

bp <- barplot(all_sites, beside=TRUE, las=2, border="black", col=bar_colors, log='y',
              xaxt='n', yaxt='n', ylab="", main="Columbian mammoth as P3", cex.main=1.3,
              yaxs="i", xaxs="i",
              ylim=c(0.01, max(all_sites * 2)))
box()
axis(2, at=c(1, 10, 100,300), labels=c("1", "10", "100", "300"), las=1)

# --- PLOT 2: D-statistics for Krestovka ---
par(mar = c(7, 5, 0, 1))
plot(as.numeric(dKrestovka$W2), dKrestovka$D2, pch = 16, col = "white", 
     xlim = c(0.5, 5.5), ylim=c(-0.05,0.65),
     ylab = "D-statistic", xlab = "",
     main = "",
     xaxt = 'n',
     yaxs="i", xaxs="i")

axis(1, at = 1:5, labels = c("M.col U", "BC25.3K", "BC35.9K", "M.prim. V\nWyoming", "M.prim. H\nAlaska"), las = 2)

abline(v=c(1.5,2.5,3.5,4.5), col="gray40",lty = 2)

arrows(as.numeric(significantkres$W2),significantkres$D2 - significantkres$stderr, 
       as.numeric(significantkres$W2),significantkres$D2 + significantkres$stderr, 
       angle = 90, code = 3, length = 0.05, col = "black")
points(significantkres$W2, significantkres$D2, 
       bg = "grey30", pch = 21, cex=1.6)
arrows(as.numeric(nonsignificantkres$W2),nonsignificantkres$D2 - nonsignificantkres$stderr, 
       as.numeric(nonsignificantkres$W2),nonsignificantkres$D2 + nonsignificantkres$stderr, 
       angle = 90, code = 3, length = 0.05, col = "black")
points(nonsignificantkres$W2, nonsignificantkres$D2, 
       bg = "white", pch = 21, cex=1.6)


# --- PLOT 4: D-statistics for Columbi ---
par(mar = c(7, 5, 0, 1))
plot(as.numeric(dCol$W2), dCol$D2, pch = 16, col = "white", 
     xlim = c(0.5, 4.5), ylim=c(-0.05,0.65),
     ylab = "", xlab = "",
     main = "",
     xaxt = 'n',
     yaxs="i", xaxs="i")

axis(1, at = 1:4, labels = c("BC25.3K", "BC35.9K", "M.prim. V\nWyoming", "M.prim. H\nAlaska"), las = 2)

abline(v=c(1.5,2.5,3.5), col="gray40",lty = 2)
legend("topright", 
       legend = c("Autosome", "X"),
       col = c("black","#2E8B57" ), 
       pch = c(16,18), cex = 1.3, bg="white")

arrows(as.numeric(significantcol$W2)-0.15,significantcol$D2 - significantcol$stderr, 
       as.numeric(significantcol$W2)-0.15,significantcol$D2 + significantcol$stderr, 
       angle = 90, code = 3, length = 0.05, col = "black")
points(as.numeric(significantcol$W2)-0.15, significantcol$D2, 
       bg = "grey30", pch = 21, cex=1.6)
points(as.numeric(nonsignificantcol$W2)-0.15, nonsignificantcol$D2, 
       bg = alpha("grey90", 0.2), pch = 21, cex=1.6)
arrows(as.numeric(significantcolX$W2)+0.15,significantcolX$D2 - significantcolX$stderr, 
       as.numeric(significantcolX$W2)+0.15,significantcolX$D2 + significantcolX$stderr, 
       angle = 90, code = 3, length = 0.05, col = "black")
points(as.numeric(significantcolX$W2)+0.15, significantcolX$D2, 
       bg = "#2E8B57", pch = 23, cex=1.6)
arrows(as.numeric(nonsignificantcolX$W2)+0.15,nonsignificantcolX$D2 - nonsignificantcolX$stderr, 
       as.numeric(nonsignificantcolX$W2)+0.15,nonsignificantcolX$D2 + nonsignificantcolX$stderr, 
       angle = 90, code = 3, length = 0.05, col = "black")
points(as.numeric(nonsignificantcolX$W2)+0.15, nonsignificantcolX$D2, 
       bg = "white", pch = 23, cex=1.6)


# --- Plot 5: Admixture proportion

par(mar = c(4, 7, 1, 2))
plot(1-f4ratio_auto$alpha, f4ratio_auto$X, pch = 16, col = "white", 
     xlim = c(0.0, 1.1), ylim=c(0.5,4.5),
     xlab = expression(paste("Admixture proportion (", alpha, "-1) Columbian mammoth", sep = "")), ylab = "",
     main = "",
     yaxt = 'n',
     yaxs="i", xaxs="i")
abline(h=c(1.5,2.5,3.5), col="gray40",lty = 2)

axis(2, at = 1:4, labels = c("BC25.3K", "BC35.9K", "M.prim. V\nWyoming", "M.prim. H\nAlaska"), las = 2)

arrows(1-f4ratio_auto$alpha-f4ratio_auto$stderr,as.numeric(f4ratio_auto$X)+0.15,
       1-f4ratio_auto$alpha+f4ratio_auto$stderr,as.numeric(f4ratio_auto$X)+0.15,
       angle = 90, code = 3, length = 0.05, col = "black")
points(1-f4ratio_auto$alpha, as.numeric(f4ratio_auto$X)+0.15,
       bg = "grey30", pch = 21, cex=1.6)
arrows(1-f4ratio_X$alpha-f4ratio_X$stderr,as.numeric(f4ratio_X$X)-0.15,
       1-f4ratio_X$alpha+f4ratio_X$stderr,as.numeric(f4ratio_X$X)-0.15,
       angle = 90, code = 3, length = 0.05, col = "black")
points(1-f4ratio_X$alpha, as.numeric(f4ratio_X$X)-0.15,
       bg = "#2E8B57", pch = 23, cex=1.6)


dev.off()



