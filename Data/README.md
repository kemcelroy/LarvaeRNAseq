README
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
