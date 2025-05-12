library(dplyr)

setwd("/Users/marianne/OneDrive/NRM/Rscripts/BCM/admixr")
data<-read.csv("Dstats_results_autos_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)
dataX<-read.csv("Dstats_results_X_noPrune.csv", header = TRUE,stringsAsFactors = FALSE)


FOCAL <- c("Mcolumbi-U.ERR2260506", "Mammuthus-bcm004", "Mammuthus-bcm019",  
           "Mammuthus-V.ERR2260507", "Mammuthus-H.ERR2260502")


#Autosomes
data <- data %>%
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  mutate(across(c(stderr, D, Zscore, ABBA, BABA, nsnps), as.numeric))
#chrX
dataX <- dataX %>%
  mutate(across(where(is.character), ~ gsub("\\.bam$", "", .))) %>%
  mutate(across(c(stderr, D, Zscore, ABBA, BABA, nsnps), as.numeric))

# Loop through each focal individual and create its specific df
#Autosomes
focal_dfs <- list()
for (focal in FOCAL) {
  df <- data %>%
    filter(W == focal | X == focal) %>%
    mutate(
      W2 = focal,
      X2 = if_else(W == focal, X, W),
      D2 = if_else(W == focal, D, -D)
    )
  
  focal_dfs[[focal]] <- df
}
#chrX
focal_dfsX <- list()
for (focal in FOCAL) {
  dfX <- dataX %>%
    filter(W == focal | X == focal) %>%
    mutate(
      W2 = focal,
      X2 = if_else(W == focal, X, W),
      D2 = if_else(W == focal, D, -D)
    )
  
  focal_dfsX[[focal]] <- dfX
}


name_map <- c(
  "Mammuthus-bcm004" = "BC25.3k",
  "Mammuthus-bcm019" = "BC35.9k",
  "Mammuthus-P004" = "M. prim. NSI12.2k",
  "Mammuthus-P005" = "M. prim. NSI12.8k",
  "Mammuthus-L164" = "M. prim. Chu17.0k",
  "Mammuthus-M6" = "M. prim. Wra24.0k",
  "Mammuthus-L163" = "M. prim. Chu31.9k",
  "Mammuthus-Yuka" = "M. prim. Yak32.2k",
  "Mammuthus-oimyakon.ERR852028" = "M. prim. Oim44.2k",
  "Mammuthus-MD090" = "M. prim. Yak52.3k",
  "Mammuthus-H.ERR2260502" = "M. prim. H Alaska",
  "Mammuthus-V.ERR2260507" = "M. prim. V Wyoming",
  "Mcolumbi-U.ERR2260506" = "M. col. U"
)

# Add custom label to each focal dataframe
#Autosomes
for (focal in names(focal_dfs)) {
  df <- focal_dfs[[focal]]
  df$X2_label <- name_map[df$X2]  # map using X2
  focal_dfs[[focal]] <- df
}

#chrX
for (focal in names(focal_dfsX)) {
  dfX <- focal_dfsX[[focal]]
  dfX$X2_label <- name_map[dfX$X2]  # map using X2
  focal_dfsX[[focal]] <- dfX
}


pdf("admixr_individual_Krestovka.pdf", width = 6, height = 9)
par(family = "Helvetica", ps = 11)

layout(matrix(c(1, 2, 
                3, 4,
                5,6), ncol = 2, byrow = TRUE))

par(mar = c(4, 8, 4, 2))

for (focal in names(focal_dfs)) {
  
  df <- focal_dfs[[focal]]
  
  df <- df %>%
    filter(Y == "35bp.Mammuthus-Krestovka")
  
  
  df <- df[order(df$X2_label), ]
  df$X2_label <- factor(df$X2_label, levels = unique(df$X2_label))
  
  y_vals <- as.numeric(df$X2_label)
  
  point_colors <- ifelse(abs(df$Zscore) >= 3, "gray30", "white")
  
  plot(NULL,
       main = paste("P2 = ",name_map[[focal]]),
       xlab = "D-statistic",
       ylab = "",
       yaxt = "n",
       xlim = c(-0.5, 0.5), ylim =c(1,12))
  
  arrows(df$D2 - df$stderr, y_vals, 
         df$D2 + df$stderr, y_vals, 
         angle = 90, code = 3, length = 0.05, col = "black")
  points(df$D2, y_vals, pch=21, bg=point_colors)
  
  axis(2, at = y_vals, labels = levels(df$X2_label), las = 1, cex.axis = 0.8)
  abline(v = 0, lty = 2, col = "gray50")
  abline(h=seq(from = 1.5, to = 12.5, by =1), col="gray50",lty = 2)
}

dev.off()

pdf("admixr_individual_Mcol.pdf", width = 6, height = 9)
par(family = "Helvetica", ps = 11)

layout(matrix(c(1, 2, 
                3, 4,
                5,6), ncol = 2, byrow = TRUE))

par(mar = c(4, 8, 4, 2))

for (focal in names(focal_dfs)[-1]) {
  
  # Autosomes
  df <- focal_dfs[[focal]] %>%
    filter(Y == "Mcolumbi-U.ERR2260506")
  df <- df[order(df$X2_label), ]
  df$X2_label <- factor(df$X2_label, levels = unique(df$X2_label))
  y_vals <- as.numeric(df$X2_label)
  point_colors <- ifelse(abs(df$Zscore) >= 3, "gray30", "white")
  
  
  # chrX
  dfX <- focal_dfsX[[focal]] %>%
    filter(Y == "Mcolumbi-U.ERR2260506")
  dfX <- dfX[order(dfX$X2_label), ]
  dfX$X2_label <- factor(dfX$X2_label, levels = unique(df$X2_label))  # match levels with original
  y_valsX <- as.numeric(dfX$X2_label)
  point_colorsX <- ifelse(abs(df$Zscore) >= 3, "#2E8B57","white")
  
  # Plot base
  plot(NULL,
       main = paste("P2 = ", name_map[[focal]]),
       xlab = "D-statistic",
       ylab = "",
       yaxt = "n",
       xlim = c(-0.5, 0.5), ylim = c(1,11))
  
  # Plot Autosomes
  arrows(df$D2 - df$stderr, y_vals-0.15, 
         df$D2 + df$stderr, y_vals-0.15, 
         angle = 90, code = 3, length = 0.05, col = "black")
  points(df$D2, y_vals-0.15, pch=21, bg=point_colors)
  
  # Overlay new dataset
  arrows(dfX$D2 - dfX$stderr, y_valsX+0.15, 
         dfX$D2 + dfX$stderr, y_valsX+0.15, 
         angle = 90, code = 3, length = 0.05, col = "#2E8B57")
  points(dfX$D2, y_valsX+0.15, pch=21, bg=point_colorsX)
  
  # Add axis and reference line
  axis(2, at = y_vals, labels = levels(df$X2_label), las = 1, cex.axis = 0.8)
  abline(v = 0, lty = 2, col = "gray50")
  abline(h=seq(from = 1.5, to = 11.5, by =1), col="gray50",lty = 2)
}


dev.off()

