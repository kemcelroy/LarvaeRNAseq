# README

Code and data relevant to Hasan et al. "Opsin expression varies across larval development and taxa in pteriomorphian bivalves".

### Abstract

Many marine organisms have a biphasic life cycle that transitions between a swimming larva with a more sedentary adult form. At the end of the first phase, larvae must identify suitable sites to settle and undergo a dramatic morphological change.  Environmental factors, including photic and chemical cues, appear to influence settlement, but the sensory receptors involved are largely unknown. We targeted the protein receptor, opsin, which belongs to large superfamily of transmembrane receptors that detects environmental stimuli, hormones, and neurotransmitters. While opsins are well-known for light-sensing, including vision, a growing number of studies have demonstrated light-independent functions. We therefore examined opsin expression in the Pteriomorphia, a large, diverse clade of marine bivalves, that includes commercially important species, such as oysters, mussels, and scallops. Genomic annotations combined with phylogenetic analysis show great variation of opsin abundance among pteriomorphian bivalves, including surprisingly high genomic abundance in many species that are eyeless as adults, such as mussels. Therefore, we investigated the diversity of opsin expression from the perspective of larval development. We collected opsin gene expression in four families of Pteriomorphia, across three distinct larval stages, i.e., trochophore, veliger, and pediveliger, and compared those to adult tissues. We found larvae express all opsin types in these bivalves, but opsin expression patterns are largely species-specific across development. Nearly all opsins are expressed at low levels in the adult mantle, but many of these are highly expressed in adult eyes. Intriguing, opsin genes such as retinochrome, xenopsins, and Go-opsins have higher levels of expression in the later larval stages when substrates for settlement are being tested, such as the pediveliger. Investigating opsin gene expression during larval development provides crucial insights into their intricate interactions with the surroundings, which may shed light on how opsin receptors of these organisms respond to various environmental cues that play a pivotal role in their settlement process.

### Files

* ```01_opsins.md``` outlines methods and scripts used in identifying opsins from pteriomorphian genome assemblies and performing phylogenetic analysis for categorization.
* ```02_RNAseq.md``` outlines the methods and scripts used to acquire publicly available RNA-seq datasets from pteriomorphian species and quantify opsin gene expression
* ```Data``` folder with opsin sequences and phylogenetic trees
    * ```Pter_opn_out.aa.fasta``` unaligned amino acid sequences of opsins and outgroups
    * ```Pter_opn_out.aa.mafft-einsi.fa``` aligned amino acid sequences of opsins and outgroups
    * ```Pterio_opn_out.aa.mafft-einsi.fa.treefile``` ML tree from IQ-TREE2
    * ```Pterio_opn_out.aa.mafft-einsi.fa.iqtree``` IQ-TREE2 run information
    * ```Pter_opn_tree.rooted.nxs``` rooted version of ```Pterio_opn_out.aa.mafft-einsi.fa.treefile```
    * ```Pter_opn_pruned_named.nxs``` final pruned tree, rooted
* ```Main_TPM_plot.R``` R script used to make expression plots in Figures 3, 4, S1, S2