# Load packages
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("ggtree")

library(treeio)
library(ggtree)
library(ape)
library(ggplot2)
library(geiger)
library(dplyr)
library(grid)
library(cowplot)
library(tidytree)

setwd("~/OneDrive/NRM/Manuscripts/BCM/Rscripts/BEAST")

##################################################################################

beast <- read.beast(file = "BCM.vcv2021dated.aligned.OutgroupFiltered.relaxed.mcc.tre")
beast <- drop.tip(beast, tip = c('EF588275_E.maximus_0', 'NC_005129_E.maximus_0'))

## Rename tip label for clarity
beast@phylo$tip.label[beast@phylo$tip.label == "KX027509_M.primigenius_NAmerica_27713"]  <- "KX027509_M.sp_NAmerica_27713"
beast@phylo$tip.label[beast@phylo$tip.label == "L286_combined_35.mammoth.mia_M.primigenius_WEurope_49111"] <- "L286_M.primigenius_WEurope_49111"
beast@phylo$tip.label[beast@phylo$tip.label == "L082_combined_35.mammoth.mia_M.primigenius_Asia_23962"] <- "L082_M.primigenius_Asia_23962"
beast@phylo$tip.label[beast@phylo$tip.label == "KX027492_M.primigenius_NAmerica_20256"] <- "KX027492_M.sp_NAmerica_20256"
beast@phylo$tip.label[beast@phylo$tip.label == "KX027542_M.sp_NAmerica_14091"] <- "KX027542_M.primigenius_NAmerica_14091"
beast@phylo$tip.label[beast@phylo$tip.label == "KX027534_M.primigenius_NAmerica_21151"] <- "KX027534_M.sp_NAmerica_21151"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027559_M.jeffersoni_NAmerica_19237"] <- "KX027559_M.sp_NAmerica_19237"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027532_M.primigenius_NAmerica_43496"] <- "KX027532_M.sp_NAmerica_43496"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027504_M.columbi_NAmerica_12825"] <- "KX027504_M.sp_NAmerica_12825"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027494_M.sp_NAmerica_22387"] <- "KX027494_M.columbi_NAmerica_22387"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027520_M.jeffersoni_NAmerica_12985"] <- "KX027520_M.sp_NAmerica_12985"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027547_M.sp_NAmerica_20590"] <- "KX027547_M.columbi_NAmerica_20590"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027548_M.sp_NAmerica_14014"] <- "KX027548_M.columbi_NAmerica_14014"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027551_M.sp_NAmerica_13420"] <- "KX027551_M.columbi_NAmerica_13420"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027496_M.columbi_NAmerica_12633"] <- "KX027496_M.sp_NAmerica_12633"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027503_M.columbi_NAmerica_16770"] <- "KX027503_M.sp_NAmerica_16770"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027511_M.columbi_NAmerica_27778"] <- "KX027511_M.sp_NAmerica_27778"
beast@phylo$tip.label[beast@phylo$tip.label =="bcm004_NAmerica_25320"] <- "bcm004_M.sp_BritishColumbia_25320"
beast@phylo$tip.label[beast@phylo$tip.label =="bcm019_NAmerica_34720"] <- "bcm019_M.primigenius_BritishColumbia_34720"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027537_M.columbi_NAmerica_13392"] <- "M.columbi_U_Wyoming_13392"
beast@phylo$tip.label[beast@phylo$tip.label =="KX027556_M.sp_NAmerica_42451"] <-"M.primigenius_V_Wyoming_42451"
beast@phylo$tip.label[beast@phylo$tip.label =="JF912200_M.sp_NAmerica_44964"] <- "M.primigenius_H_Alaska_44964"

#ggtree(beast) + geom_tiplab(offset=4, align=TRUE)+ xlim(NA, 1000000)

tree <- fortify(beast) 

tree <- tree %>%
  mutate(branch_category = case_when(
    grepl("NAmerica", label) ~ "NAmerica",
    grepl("Europe", label) ~ "Europe",
    grepl("Asia", label) ~ "Asia",
    grepl("bcm", label) ~ "NAmerica",
    grepl("Wyoming", label) ~ "NAmerica",
    grepl("Alaska", label) ~ "NAmerica",
    TRUE ~ "Other"  # Default for unclassified branches
  ))

tip_data <- tree %>% filter(isTip)
label <- tip_data$label
species <- rep(NA, length(label))

# Loop through each label and assign the species name
for (i in seq_along(label)) {
  if (grepl("M.columbi", label[i])) {
    species[i] <- "M.columbi"
  } else if (grepl("M.primigenius", label[i])) {
    species[i] <- "M.primigenius"
  } else if (grepl("M.sp", label[i])) {
    species[i] <- "M.sp"
  }
}

## Combine species name with tip labels in new dataframe
species_assignment <- data.frame(
  label = label,
  value = 1,
  species = species
)

species_colors<- c("M.columbi" = "#623740", 
                   "M.primigenius" = "#d5914a", 
                   "M.sp" = "grey80")

p1 <- ggtree(tree) + 
  geom_tree(size = 0.2, color = "black") + 
  geom_point2(aes(subset=!isTip & posterior <0.7 | label ==100),shape=21, size=2, bg="white")+
  geom_point2(aes(subset=!isTip & posterior >0.9 | label ==100),shape=21, size=2, bg="black")+
  geom_tiplab(aes(color = branch_category), size = 2, align = TRUE) + 
  scale_color_manual(values = c("NAmerica" = "#007d92",
                                "Europe" = "#e7b465",
                                "Asia" = "#F2684A",
                                "Other" = "grey10")) +
  theme(legend.position = "none") +
  geom_tippoint(aes(subset = grepl("M.columbi_U_Wyoming_13392", label)), 
                color = "#dc143c", size = 2.5, shape = 17) +
  geom_tippoint(aes(subset = grepl("bcm|M.primigenius_V_Wyoming_42451|M.primigenius_H_Alaska_44964", label)), 
                color = "#dc143c", size = 2.5, shape = 19) +
  xlim(NA, 700000)



## Add species assignment colours next to phylogenetic tree
p2 <- p1 + 
  geom_facet(
    panel = "species", 
    data = species_assignment,
    geom = geom_point, 
    mapping = aes(x = (700000), fill = species),
    shape = 22, 
    size = 2.5, 
    color = "black"
  ) + 
  scale_fill_manual(values = species_colors) 


## Remove headers from panels
p3 <- p2 + theme(strip.text = element_blank(),legend.position = "none") 
p4 <- facet_widths(p3, c(species = .1))

ggsave("beast_morphology.pdf", plot = p4, width = 5, height = 10)

###### LEGEND ######

par(family = "Helvetica")

pdf("legend_morph.pdf", width = 6, height = 8)
plot(NULL, xaxt = 'n', yaxt = 'n', bty = 'n', ylab = '', xlab = '', xlim = 0:1, ylim = 0:1)
legend("topleft",  c(expression(italic("M. columbi")), 
                     expression(italic("M. primigenius")),
                     expression("M. sp.")),
       pch = 16, pt.cex = 2, cex = 1, bty = 'n', 
       col = c('#623740', "#d5914a", 'grey80'))
mtext("Morphological identification", at = 0.2, cex = 1, font = 2)
dev.off()

pdf("legend_geo.pdf", width = 6, height = 8)
plot(NULL, xaxt = 'n', yaxt = 'n', bty = 'n', ylab = '', xlab = '', xlim = 0:1, ylim = 0:1)
legend("topleft",  c("North America", "Europe", "Asia"),
       pch = 16, pt.cex = 2, cex = 1, bty = 'n', 
       col = c("#007d92", "#e7b465", "#F2684A"))
mtext("Geographical region", at = 0.14, cex = 1, font = 2)
dev.off()

pdf("legend_posterior.pdf", width = 6, height = 8)
plot(NULL, xaxt = 'n', yaxt = 'n', bty = 'n', ylab = '', xlab = '', xlim = 0:1, ylim = 0:1)
legend("topleft",  c("Lower than 0.7", "Higher than 0.9"),
       pch = c(21,19), pt.cex = 2, cex = 1, bty = 'n', 
       bg = c("white", "black"))
mtext("Node support (posterior probability", at = 0.14, cex = 1, font = 2)
dev.off()
