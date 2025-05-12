setwd("~/OneDrive/NRM/Manuscripts/BCM/Rscripts/Morphology")

data<-read.table("morphology.txt", sep = '\t', header = TRUE)

unique(as.factor(data$group)) #5groups

#FACTOR TO CONTROL FOR ORDER
data$group <- factor(data$group, levels = c("MT", "EP_MC", "MP_MC","LP_MC","LP_MP"))

colours <- c("darkgreen","#dabec4","#a96674","#623740","#d59d4a")[factor(data$group)]
symbols <- c(22,23,24,21,21)[factor(data$group)]

# Set up the PNG device with the desired dimensions and resolution
#png("Morphology.png", width = 5.85, height = 5.85, units = "in", res = 300)
pdf("morphology.pdf", width = 5, height = 5.5)

# Set the font family to Arial and the font size to 11
par(family = "Helvetica", ps = 11)

# Create the plot
plot(data$number, data$length_index,
     bg = colours,
     pch = symbols,
     cex = 1.25,
     xlim = c(16, 30), ylim = c(8, 18),
     ylab = "Lamella length index (mm)",
     xlab = "Lamella number")

# Add points and text for specific data points
points(data$number[data$id == "RCBM 1689"], data$length_index[data$id == "RCBM 1689"],
       cex = 1.6, pch = 21, bg = "#dc143c")
text(data$number[data$id == "RCBM 1689"], data$length_index[data$id == "RCBM 1689"] + 0.1,
     "BC34.7K", pos = 4)

points(data$number[data$id == "UW6368"], data$length_index[data$id == "UW6368"],
       cex = 1.6, pch = 24, bg = "#dc143c")
text(data$number[data$id == "UW6368"], data$length_index[data$id == "UW6368"] + 0.1,
     expression(paste(italic("M. columbi"), " Wyoming")), pos = 3)

# Add arrows
arrows(16, 14, 16, 17, code = 3, angle = 25, lwd = 2)

# Turn off the PNG device
dev.off()

pdf("legend_morphology.pdf", width = 6, height = 10)
plot(NULL, xaxt = 'n', yaxt = 'n', bty = 'n', ylab = '', xlab = '', xlim = 0:1, ylim = 0:1)
# Add legend
legend("topright",
       legend = c(expression(paste("Late Pleistocene ", italic("M. primigenius"))),
                  expression(paste("Late Pleistocene ", italic("M. columbi"))),
                  expression(paste("Middle Pleistocene ", italic("M. columbi"))),
                  expression(paste("Early Pleistocene ", italic("M. columbi"))),
                  expression(paste("Early/Middle Pleistocene ", italic("M. trogontherii")))),
       col = c("#d59d4a", "#623740", "#a96674", "#dabec4", "darkgreen"),
       pch = c(19, 19, 17, 18, 15),
       pt.cex = 2, cex = 1, bty = 'n')
dev.off()

