##### TPM values for scallops, mussels, oysters and pearl oyster

# Load Libraries
library(ggplot2)
library(readxl)

## SCALLOP dataset
scallop_data <- read_excel("Samples_TPM.xlsx", sheet = "scallops")
scallop_data$logExp=log10(scallop_data$TPM + 1)
data <- as.data.frame(scallop_data)
# Add thresholds for both species
cutoff.Pmax <- log10(0.1713839 + 1) # based on selected threshold
cutoff.Cfar <- log10(0.235579 + 1) # based on selected threshold
# Excluding adult mantle from the data frame for connecting lines
drop.adult <- as.data.frame(data[c(1:54,73:126),])
# Prepare the plot across developmental stages and samples
scallop.plot <- 
  ggplot(data, aes(x = Sample, y = logExp, group = Species, shape = Species, fill = Species)) +
  geom_line(data = drop.adult, linetype = 2, aes(colour = Species)) +
  geom_hline(aes(yintercept = cutoff.Pmax, colour = Species[1])) +
  geom_hline(aes(yintercept = cutoff.Cfar, colour = Species[144])) +
  geom_point(aes(colour = Species), size = 2) +
  scale_shape_manual(values = c(22, 24)) +
  facet_wrap(~ Opsin) +
  xlab("Developmental stages and samples") +
  ylab("Expression: log10(TPM+1)") +
  scale_x_discrete(limits = c("Trochophore", "Veliger", "Pediveliger", "Adult mantle")) +
  theme(axis.text.x.bottom = element_text(size = 8, angle = 65),
        axis.text.x = element_text(hjust = c(1,1)),
        legend.title = element_text(size = 10), legend.position = c(0.8,0),
        strip.text = element_text(size = 10, colour = 'white'),
        axis.title = element_text(size = 12),
        panel.grid.major.x = element_blank(),
        strip.background = element_rect(fill="darkgray"))
scallop.pdf <- scallop.plot + scale_fill_manual(values=c("gray20", "sienna"))+
        scale_color_manual(values=c("gray20", "sienna"))
pdf("scallop_expression_plot.pdf", width = 8, height = 7)
scallop.pdf
dev.off()

## EYE plot (including all larval data for reference)
eye_data <- read_excel("Samples_TPM.xlsx", sheet = "eyes_only")
eye_data$logExp=log10(eye_data$TPM + 1)
eye.plot <- 
  ggplot(eye_data, aes(x = Opsin, y = logExp, shape = `Chlamys farreri`, group = `Chlamys farreri`, fill = `Chlamys farreri`)) +
  geom_hline(aes(yintercept = cutoff.Cfar), linetype = 2, size = 1) +
  geom_point(size = 4) +
  scale_shape_manual(values = c(22,24)) +
  xlab("Opsin type") +
  ylab("Expression: log10(TPM+1)") +
  theme(axis.text.x.bottom = element_text(size = 12, angle = 45),
        axis.text.x = element_text(hjust = c(1,1)),
        legend.title =  element_text(size = 10), legend.position = "right",
        legend.text = element_text(size = 10),
        axis.title = element_text(size = 12))
eye.pdf <- print(eye.plot + scale_fill_manual(values=c("darkblue", "lightblue")))
pdf("eye_expression_plot.pdf", width = 8, height = 7)
eye.pdf
dev.off()


## OYSTER dataset
oyster_data <- read_excel("Samples_TPM.xlsx", sheet = "oysters")
oyster_data$logExp=log10(oyster_data$TPM + 1)
oyster <- as.data.frame(oyster_data)
# Add thresholds for both species
cutoff.Cang <- log10(0.100678 + 1) # based on selected threshold
cutoff.Cgig <- log10(0.294612 + 1) # based on selected threshold
# Excluding adult mantle from the data frame for connecting lines
drop.adult.oyster <- as.data.frame(oyster[c(1:36,49:84),])
# Prepare the plot across developmental stages and samples
oyster.plot <- 
  ggplot(oyster, aes(x = Sample, y = logExp, group = Species, shape = Species, fill = Species)) +
  geom_line(data = drop.adult.oyster, linetype = 2, aes(colour = Species)) +
  geom_hline(aes(yintercept = cutoff.Cang, colour = Species[1])) +
  geom_hline(aes(yintercept = cutoff.Cgig, colour = Species[50])) +
  geom_point(aes(colour = Species), size = 2) +
  scale_shape_manual(values = c(22, 24)) +
  facet_wrap(~ Opsin) +
  xlab("Developmental stages and samples") +
  ylab("Expression: log10(TPM+1)") +
  scale_x_discrete(limits = c("Trochophore", "Veliger", "Pediveliger", "Adult mantle")) +
  theme(axis.text.x.bottom = element_text(size = 8, angle = 45),
        axis.text.x = element_text(hjust = c(1,1)),
        legend.title = element_text(size = 10), legend.position = "right",
        strip.text = element_text(size = 10, colour = 'white'),
        strip.background = element_rect(fill="darkgray"),
        panel.grid.major.x = element_blank(),
        axis.title = element_text(size = 12))
oyster.pdf <- oyster.plot + scale_fill_manual(values=c("gray20", "sienna"))+
      scale_color_manual(values=c("gray20", "sienna"))
pdf("oyster_expression_plot.pdf", width = 8, height = 7)
oyster.pdf
dev.off()

## MUSSEL dataset
mussel_data <- read_excel("Samples_TPM.xlsx", sheet = "mussels")
mussel_data$logExp=log10(mussel_data$TPM + 1)
mussel <- as.data.frame(mussel_data)
# Add thresholds for both species
cutoff.Medu <- log10(0.1139026 + 1) # based on selected threshold
cutoff.Mcor <- log10(0.158149 + 1) # based on selected threshold
# Excluding adult mantle from the data frame for connecting lines
drop.adult.mussel <- as.data.frame(mussel[c(1:78,105:164),])
# Prepare the plot across developmental stages and samples
mussel.plot <- 
  ggplot(mussel, aes(x = Sample, y = logExp, group = Species, shape = Species, fill = Species)) +
  geom_line(data = drop.adult.mussel, linetype = 2, aes(colour = Species)) +
  geom_hline(aes(yintercept = cutoff.Medu, colour = Species[1])) +
  geom_hline(aes(yintercept = cutoff.Mcor, colour = Species[150])) +
  geom_point(aes(colour = Species), size = 2) +
  scale_shape_manual(values = c(22, 24)) +
  facet_wrap(~ Opsin, nrow = 7) +
  xlab("Developmental stages and samples") +
  ylab("Expression: log10(TPM+1)") +
  scale_x_discrete(limits = c("Trochophore", "Veliger", "Pediveliger", "Adult mantle")) +
  theme(axis.text.x.bottom = element_text(size = 8, angle = 65),
        axis.text.x = element_text(hjust = c(1,1)),
        legend.title = element_text(size = 10), legend.position = c(0.7,0),
        strip.text = element_text(size = 10, colour = 'white'),
        strip.background = element_rect(fill="darkgray"),
        panel.grid.major.x = element_blank(),
        axis.title = element_text(size = 12))
mussel.pdf <- mussel.plot + scale_fill_manual(values=c("gray20", "sienna"))+
        scale_color_manual(values=c("gray20", "sienna"))
pdf("mussel_expression_plot.pdf", width = 8, height = 9)
mussel.pdf
dev.off()

## PEARL OYSTER dataset
Pfuc_data <- read_excel("Samples_TPM.xlsx", sheet = "pearloyster")
Pfuc_data$logExp=log10(Pfuc_data$TPM + 1)
Pfuc <- as.data.frame(Pfuc_data)
# Add thresholds for both species
cutoff.Pfuc <- log10(0.2479746 + 1) # based on selected threshold
# Excluding adult mantle from the data frame for connecting lines
drop.adult.Pfuc <- as.data.frame(Pfuc[c(1:39),])
# Prepare the plot across developmental stages and samples
Pfuc.plot <- 
  ggplot(Pfuc, aes(x = Sample, y = logExp, group = Species, shape = Species, fill = Species)) +
  geom_line(data = drop.adult.Pfuc, linetype = 2, aes(colour = Species)) +
  geom_hline(aes(yintercept = cutoff.Pfuc, colour = Species[1])) +
  geom_point(aes(colour = Species), size = 3) +
  scale_shape_manual(values = c(22)) +
  facet_wrap(~ Opsin, nrow = 3) +
  xlab("Developmental stages and samples") +
  ylab("Expression: log10(TPM+1)") +
  scale_x_discrete(limits = c("Trochophore", "Veliger", "Pediveliger", "Adult mantle")) +
  theme(axis.text.x.bottom = element_text(size = 8, angle = 65),
        axis.text.x = element_text(hjust = c(1,1)),
        legend.title = element_text(size = 10), legend.position = c(0.8,0),
        strip.text = element_text(size = 10, colour = 'white'),
        strip.background = element_rect(fill="darkgray"),
        panel.grid.major.x = element_blank(),
        axis.title = element_text(size = 12))
Pfuc.pdf <- Pfuc.plot + scale_fill_manual(values = c("gray20")) +
  scale_color_manual(values = c("gray20"))
pdf("pearloyster_expression_plot.pdf", width = 8, height = 7)
Pfuc.pdf
dev.off()


