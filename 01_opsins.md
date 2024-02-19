# Collecting opsin sequences from pteriomorphian genomes

## Genome assembly information

From table S2

| **    Species   **                   | **    Family   **   | **    Code   ** | **    NCBI Accession # or   reference   **         | **    Scaffolds   ** | **    Length(Mb)   ** | **    L/N50(Mb)   ** |
|--------------------------------------|---------------------|-----------------|----------------------------------------------------|----------------------|-----------------------|----------------------|
| _    Scapharca broughtonii   _       |     Arcidae         |     Sbro        |     GigaDB doi http://dx.doi.org/10.5524/100607    |     1026             |     884.57            |     9/44.99          |
| _    Scapharca   kagoshimensis   _   |     Arcidae         |     Skag        |     GCA_021292105.1_ASM2129210v1                   |     36               |     1115.24           |     9/60.63          |
| _    Tegillarca granosa   _          |     Arcidae         |     Tgra        |     GCA_013375625.1   (ASM1337562v1)               |     269              |     797.65            |     9/42.62          |
| _    Pinctada fucata   _             |     Margaritidae    |     Pfuc        |     GCA_028253585.1   (Pfu_4.1B)                   |     29306            |     817.71            |     1343/16.73       |
| _    Mytilus californicus   _        |     Mytilidae       |     Mcal        |     GCA_021869535.1   (xbMytCali1.0.p)             |     176              |     1651.97           |     7/117.87         |
| _    Mytilus coruscus   _            |     Mytilidae       |     Mcor        |     GCA_017311375.1   (Mcoruscus_HiC)              |     4434             |     1566.53           |     7/99.54          |
| _    Mytilus edulis   _              |     Mytilidae       |     Medu        |     GCA_905397895.1   (MEDL1)                      |     3339             |     1827.08           |     465/1.10         |
| _    Mytilus   galloprovincialis   _ |     Mytilidae       |     Mgal        |     GCA_900618805.1   (MGAL_10)                    |     10577            |     1282.21           |     1904/207.64      |
| _    Perna viridis   _               |     Mytilidae       |     Pvir        |     GCA_018327765.1   (Pvar_1.0)                   |     15933            |     731.87            |     49/4.11          |
| _    Crassostrea angulata   _        |     Ostreidae       |     Cang        |     GCA_025612915.2   (ASM2561291v2)               |     412              |     624.35            |     5/60.48          |
| _    Crassostrea ariakensis   _      |     Ostreidae       |     Cari        |     GCA_020458035.1   (ASM2045803v1)               |     60               |     663.15            |     5/66.34          |
| _    Crassostrea gigas   _           |     Ostreidae       |     Cgig        |     GCA_902806645.1 (cgigas_uk_roslin_v1)          |     236              |     647.89            |     5/58.46          |
| _    Crassostrea virginica   _       |     Ostreidae       |     Cvir        |     GCA_002022765.4   (C_virginica-3.0)            |     10               |     684.72            |     4/75.94          |
| _    Ostrea edulis   _               |     Ostreidae       |     Oedu        |     GCA_947568905.1   (xbOstEdul1.1)               |     1364             |     935.15            |     5/95.56          |
| _    Amusium pleuronectes   _        |     Pectinidae      |     Aple        |     https://doi.org/10.1038/s41559-022-01898-6     |     310              |     669.66            |     9/35.37          |
| _    Argopecten irradians   _        |     Pectinidae      |     Airr        |     https://doi.org/10.1038/s41559-022-01898-6     |     815              |     882.75            |     87/3.14          |
| _    Argopecten purpuratus   _       |     Pectinidae      |     Apur        |     https://doi.org/10.1038/s41559-022-01898-6     |     315              |     781.61            |     41/5.53          |
| _    Chlamys farreri   _             |     Pectinidae      |     Cfar        |     https://doi.org/10.1038/s41559-022-01898-6     |     102              |     966.73            |     9/50.08          |
| _    Mimachlamys varia   _           |     Pectinidae      |     Mvar        |     GCA_947623455.1   (xbMimVari1.1)               |     83               |     975.38            |     9/50.75          |
| _    Mizuhopecten   yessoensis   _   |     Pectinidae      |     Pyes        |     https://doi.org/10.1038/s41559-022-01898-6     |     828              |     1171.90           |     9/60.01          |
| _    Pecten maximus   _              |     Pectinidae      |     Pmax        |     GCA_902652985.1   (xPecMax1.1)                 |     3983             |     918.31            |     10/44.82         |
| _    Placopecten   magellanicus   _  |     Pectinidae      |     Pmag        |     https://doi.org/10.1038/s41559-022-01898-6     |     4054             |     1458.27           |     10/66.32         |
| _    Ylistrum japonicum   _          |     Pectinidae      |     Ajap        |     https://doi.org/10.1038/s41559-022-01898-6     |     31               |     695.21            |     8/39.05          |

## BITACORA for de novo opsin discovery

Generate the opsin database for BITACORA to use. This is the same database from [McElroy et al. 2023 Molecular Biology and Evolution](https://doi.org/10.1093/molbev/msad263)

```sh
cd 01_db
mafft --auto opn_db.fasta > opn_db.aln
hmmbuild opn_db.hmm opn_db.aln
```

Scripts to generate directories and submissions scripts for each species code (e.g., Cgig for *Crassostrea gigas*)
```sh
while read line; do mkdir "BITACORA_opn_$line"; done < species
while read line; do cp bitacora_genome_input.sbatch "BITACORA_opn_$line" && cp runBITACORA_genome_mode.sh "BITACORA_opn_$line"; done < species
while read line; do sed -i "s/REPLACE_ENAME/$line/g" BITACORA_opn_$line/*; done < species
while read line; do cd "BITACORA_opn_$line" && sbatch bitacora_genome_input.sbatch; cd ..; done < species
```

The batch submission script ```bitacora_genome_input.sbatch```  will call ```runBITACORA_genome_mode.sh``` to run the BITACORA pipeline.

```sh
#!/bin/sh
#$ -m ea
#$ -M address@uiowa.edu
#$ -pe 80cpn 80
#$ -cwd
#$ -N bitacora_opn_REPLACE_NAME

# load java modules
ml stack/legacy
ml jdk/8u172

# run BITACORA (v. 1.3) in genome mode using GeMoMa (v. 1.7.1), using Evalue=1e-3.
# database is opsins from all major subfamilies (opnGq, opnGq-nc, opnGx, opn5, opnGo, RTC, peropsin) collected from representative bivalve (4), gastropod (4), and chephalopod genomes (1)
# Species: REPLACE_NAME

bash runBITACORA_genome_mode.sh
```

```runBITACORA_genome_mode.sh``` for running BITACORA to mine opsin sequences. In the script ```REPLACE_NAME``` is used to make this file custom for each genome assembly.

```bash
#!/bin/bash

##########################################################
##                                                      ##
##                       BITACORA                       ##
##                                                      ##
##          Bioinformatics tool to assist the           ##
##      comprehensive annotation of gene families       ##
##                                                      ##
##                                                      ##
## Developed by Joel Vizueta                            ##
## Contact: via github or jvizueta@ub.edu               ##
##                                                      ##
##########################################################

VERSION=1.3

##########################################################
##              EXPORT EXECUTABLES TO PATH              ##
##########################################################

# Perl needs to be installed in the system.
# HMMER and BLAST executables need to be included in $PATH

#export PATH=$PATH:/path/to/blast/bin
export PATH=$PATH:/Users/kemcelroy/downloads/hmmer/src

# PATH to BITACORA Scripts folder.
SCRIPTDIR=/Users/kemcelroy/downloads/bitacora/Scripts

# In case of using GeMoMa (set as default), specify the PATH to jar file. Otherwise, set GEMOMA=F in editable parameters section to use the close-proximity method, which does not require any external software
GEMOMAP=/Users/kemcelroy/downloads/bitacora/GeMoMa-1.7.1/GeMoMa-1.7.1.jar

##########################################################
##                   PREPARE THE DATA                   ##
##########################################################

# Include here the name of your species. i.e. NAME=Dmel
NAME=REPLACE_NAME

# Write all files with its full or relative PATH

# Include the fasta file containing the genome sequences
GENOME=/nfsscratch/Users/kemcelroy/bitacora/00_genomes/REPLACE_NAME_assembly.fasta

# Include the folder containing the FPDB databases (Including a fasta and HMM file named as YOURFPDB_db.fasta and YOURFPDB_db.hmm); Multiple FPDB can be included in the folder to be searched
QUERYDIR=/nfsscratch/Users/kemcelroy/bitacora/01_db


##########################################################
##                 EDITABLE PARAMETERS                  ##
##########################################################

# Set CLEAN=T if you want to clean the output folder. Intermediate files will not be erased but saved in the Intermediate_files folder. Otherwise, set CLEAN=F to keep all files in the same output folder
CLEAN=T

# You can modify the E-value used to filter BLAST and HMMER. Default is 1e-5
EVALUE=1e-3

# Number of threads to be used in blast searches
THREADS=80

# (Default) GEMOMA=T (with upper case) will use GeMoMa software to predict novel genes from TBLASTN alignments (PATH to jar file need to be specified in GEMOMAP variable)
# Otherwise, set GEMOMA=F to predict new genes by exon proximity (close-proximity method)
GEMOMA=T

# (Used when GEMOMA=F; close-proximity method) Maximum length of an intron used to join putative exons of a gene. Default value is conservative and can also join exons from different genes (labeled in output files with _Ndom)
# The provided script in Scripts/Tools/get_intron_size_fromgff.pl can estimate intron length statistics for a specific GFF. See the manual for more details
MAXINTRON=10000

# Set GENOMICBLASTP=T in order to conduct both BLASTP and HMMER to curate novel annotated genes (Note that this option is the most sensitive but greatly depends on the database quality and could result in false positives)
# Otherwise, BITACORA will only use the protein domain (HMMER) to validate new annotated genes (In this case, the probability of detecting all copies is lower, but it will avoid to identify unrelated genes)
GENOMICBLASTP=F

# An additional validation and filtering of the resulting annotations can be conducted using the option ADDFILTER.
# If ADDFILTER=T, BITACORA will cluster highly similar sequences (with 98% identity; being isoforms or resulting from putative assembly artifacts), and will discard all annotations with a length lower than the specified in FILTERLENGTH parameter.
ADDFILTER=T
FILTERLENGTH=30

##########################################################
##                      HOW TO RUN                      ##
##########################################################

# Once you have included all of the above variables, you can run BITACORA as in:
#$ bash runBITACORA_genome_mode.sh


##########################################################
##                   PIPELINE - CODE                    ##
##########################################################

echo -e "\n#######################  Running BITACORA Genome mode  #######################";
echo "BITACORA genome-mode version $VERSION";
date

# Checking if provided data is ok

if [[ ! -f $SCRIPTDIR/check_data_genome_mode.pl ]] ; then
        echo -e "BITACORA can't find Scripts folder in $SCRIPTDIR. Be sure to add also Scripts at the end of the path as /path/Scripts";
        echo -e "BITACORA died with error\n";
        exit 1;
fi

if [ $GEMOMA == "T" ] ; then
        perl $SCRIPTDIR/check_data_genome_mode.pl $GENOME $QUERYDIR $GEMOMA $GEMOMAP 2>BITACORAstd.err
fi

if [ $GEMOMA != "T" ] ; then
        perl $SCRIPTDIR/check_data_genome_mode.pl $GENOME $QUERYDIR $GEMOMA 2>BITACORAstd.err
fi

ERRORCHECK="$(grep -c 'ERROR' BITACORAstd.err)"

if [ $ERRORCHECK != 0 ]; then
        cat BITACORAstd.err;
        echo -e "BITACORA died with error\n";
        exit 1;
fi


# Run step 2

if [ $GEMOMA == "T" ] ; then
        if [ $GENOMICBLASTP == "T" ] ; then
                perl $SCRIPTDIR/runanalysis_2ndround_v2_genomic_nogff_gemoma.pl $NAME $QUERYDIR $GENOME $EVALUE $MAXINTRON $THREADS $GEMOMAP 2>>BITACORAstd.err 2>BITACORAstd.err
        fi

        if [ $GENOMICBLASTP != "T" ] ; then
                perl $SCRIPTDIR/runanalysis_2ndround_genomic_nogff_gemoma.pl $NAME $QUERYDIR $GENOME $EVALUE $MAXINTRON $THREADS $GEMOMAP 2>>BITACORAstd.err 2>BITACORAstd.err
        fi
fi

if [ $GEMOMA != "T" ] ; then
        if [ $GENOMICBLASTP == "T" ] ; then
                perl $SCRIPTDIR/runanalysis_2ndround_v2_genomic_nogff.pl $NAME $QUERYDIR $GENOME $EVALUE $MAXINTRON $THREADS 2>>BITACORAstd.err 2>BITACORAstd.err
        fi

        if [ $GENOMICBLASTP != "T" ] ; then
                perl $SCRIPTDIR/runanalysis_2ndround_genomic_nogff.pl $NAME $QUERYDIR $GENOME $EVALUE $MAXINTRON $THREADS 2>>BITACORAstd.err 2>BITACORAstd.err
        fi
fi

ERRORCHECK="$(grep -c 'ERROR' BITACORAstd.err)"

if [ $ERRORCHECK != 0 ]; then
        cat BITACORAstd.err;
        echo -e "BITACORA died with error\n";
        exit 1;
fi

ERRORCHECK="$(grep -c 'Segmentation' BITACORAstd.err)"

if [ $ERRORCHECK != 0 ]; then
        cat BITACORAstd.err;
        echo -e "BITACORA died with error\n";
        exit 1;
fi


# Run additional filtering and clustering

if [ $ADDFILTER == "T" ] ; then
        perl $SCRIPTDIR/runfiltering_genome_mode.pl $NAME $QUERYDIR $FILTERLENGTH 2>>BITACORAstd.err 2>BITACORAstd.err
fi

ERRORCHECK="$(grep -c 'ERROR' BITACORAstd.err)"

if [ $ERRORCHECK != 0 ]; then
        cat BITACORAstd.err;
        echo -e "BITACORA died with error\n";
        exit 1;
fi


# Cleaning

if [ $CLEAN = "T" ]; then
        perl $SCRIPTDIR/runcleaning_genome_mode.pl $NAME $QUERYDIR
        echo -e "Cleaning output folders\n";
fi


rm BITACORAstd.err

echo -e "BITACORA completed without errors :)";
date
```

### Phylogenetically Informed Annotation tool to classify opsins


I downloaded this modified version of the PIA pipeline https://github.com/MartinGuehmann/PIA2.git. The original publication for the pipeline is described in [Speiser et al. 2014](https://doi.org/10.1186/s12859-014-0350-x).

Notes related to installation
```sh
# - Install SeqKit (https://bioinf.shenwei.me/seqkit/)

cd /work/LAS/serb-lab/kmcelroy/downloads
wget https://github.com/shenwei356/seqkit/releases/download/v2.3.1/seqkit_linux_amd64.tar.gz
tar zxvf seqkit_linux_amd64.tar.gz
cd ~/bin/
ln -s /work/LAS/serb-lab/kmcelroy/downloads/seqkit seqkit

# - Clone this repository to /some/directory/
cd /work/LAS/serb-lab/kmcelroy/downloads
git clone https://github.com/MartinGuehmann/PIA2.git

# - Clone https://github.com/peterjc/pico_galaxy.git to /some/directory/
	- pico_galaxy is a dependency

cd /work/LAS/serb-lab/kmcelroy/downloads	
git clone https://github.com/peterjc/pico_galaxy.git

# - Clone and build https://github.com/lczech/gappa.git, copy gappa to /usr/bin/

git clone --recursive https://github.com/lczech/gappa.git
cd gappa
ml gcc/10.2.0-zuvaafu
make
cd ~/bin/
ln -s /work/LAS/serb-lab/kmcelroy/downloads/gappa/bin/gappa gappa

# - Clone and build https://github.com/Pbdas/epa-ng.git, copy epa-ng to /usr/bin/

git clone --recursive https://github.com/Pbdas/epa-ng.git
cd epa-ng
make
ln -s /work/LAS/serb-lab/kmcelroy/downloads/epa-ng/bin/epa-ng /home/kmcelroy/bin/epa-ng

# - Clone, build, and install https://github.com/tjunier/newick_utils.git
#	./configure --disable-shared (add --prefix=/home/user for an installation in /home/user/bin/ and /home/user/lib/ in your home directory)
#	make
#	sudo make install (drop sudo if you install it locally, e.g. your home directory)

wget https://web.archive.org/web/20210409163921/http://cegg.unige.ch/pub/newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz
tar zxvf newick-utils-1.6-Linux-x86_64-disabled-extra.tar.gz
cd newick-utils-1.6/
cd tests/
./test_binaries.sh
cd ../src/
for f in nw_*; do ln -s "/work/LAS/serb-lab/kmcelroy/downloads/newick-utils-1.6/src/${f}" "/home/kmcelroy/bin/${f}"; done


# - You may edit numThreads in run_pia.pl if you want to use less CTP cores than you have available on your system
# - You may edit the -m option in the system call raxmlHPC in pia.pl if you need to customize the model of evolution for EPA-ng. 

# Further things to install (list probably incomplete)
# - Install ncbi blast+ (sudo apt-get install ncbi-blast+)

already installed

# - Install statsmodels (https://www.statsmodels.org/stable/install.html)

module load py-pip/20.2-py3-gibulwf
pip install statsmodels


# - Install R
#	- Install packets ape
#	- Install phytools requires (Ubuntu, Debian)
#		- sudo apt install libmagick++-dev
#		- sudo apt install libcurl4-openssl-dev
		
module load r/4.1.3
> install.packeges("phytools") # lots of trouble to get everything installed
> 73


# - Install usearch (https://www.drive5.com/usearch/download.html)

wget https://www.drive5.com/downloads/usearch11.0.667_i86linux32.gz
gunzip usearch11.0.667_i86linux32.gz
chmod +x usearch11.0.667_i86linux32
ln -s /work/LAS/serb-lab/kmcelroy/downloads/usearch11.0.667_i86linux32 ~/bin/usearch

# - Install CD-Hit (https://github.com/weizhongli/cdhit)

module load cdhit/4.6.8-4gdfjl5
```

An edit I made to ```run_pia.sh```, which makes the ```gene``` variable to be read from the command line.
```bash
#!/bin/bash

INPUTGENE=$1

# Get the directory where this script is
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
CURDIR="$(pwd)"
SUBDIR="pia"
RESULTS_PREFIX="results_"
ALL_DEST="All"
RESULTS_FILE_ALL="${RESULTS_PREFIX}${ALL_DEST}"

rebuildDatabases="0"    # Whether the BLAST database should be rebuild
rebuildTrees="0"        # Whether to rebuild trees
aalength="30"           # Minimum aminoacid sequence length
search_type="single"    # Single or set
gene="${INPUTGENE}"          # Gene(set) name
evalue="0.00000000000000000001" #E-value threshold for BLAST search
blasthits="100"         # Number of BLAST hits to retain for the analysis
numThreads=$(nproc)     # Get the number of the currently available processing units to this process, which maybe less than the number of online processors
```

I edited ```pia.pl``` to use local perl modules by adding in the ```use lib``` line, commented out ```use Bio:Perl``` which caused some problems, still included all of the specific bioperl modules.
```perl
#!/usr/bin/perl -w
use strict;
use lib qw(/home/kmcelroy/perl5/lib/perl5);
#use Bio::Perl;
```

PIA uses nucleotide sequecnes, basically it assumes a transcriptome input. Collect the corresponding coding sequences from the BITACORA output.

```sh
# use species list file that has codes for species, e.g., "Cgig"
# use gffread v0.12.7 to extract coding sequences from the genome assembly based on the gff annotation
while read line; do cd "BITACORA_opn_${line}/opn" && gffread -g "../../00_genomes/${line}_assembly.fa" opn_genomic_genes_trimmed.gff3 -x "BITACORA_opn_${line}.cds.fa"; cd ../..; done < species

```

PIA batch job submission script

```bash
#!/bin/bash
#SBATCH -J PIA_run_single
#SBATCH --partition=freecompute
#SBATCH --nodes=1 # one core
#SBATCH --ntasks-per-node=36 # use 36 cores
#SBATCH -t 12:00:00 # Running time of 12 hours
#SBATCH -o PIA_run_single-%A_%a.out
#SBATCH -e PIA_run_single-%A_%a.err
#SBATCH --mail-user=kmcelroy@iastate.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

# Load modules and set up environment by adding the BUSCO config file and augustus config directory to the BUSCO path
ml py-biopython
ml mafft
ml cdhit
ml gcc/10.2.0-zuvaafu
ml tk/8.6.10-ggli4g3
ml r/4.1.3


# Enter the working directory
cd /work/LAS/serb-lab/kmcelroy/downloads/PIA2/pia

bash run_pia.sh $1
# $1 is the gene to search for from the LIT_1.1 database, e.g. "r_opsin"
```


## Additional methods for mining opsins

Miniprot was helpful for collecting opsin sequences given a close relative, so scallp --> scallop or oyster --> oyster

```bash
#!/bin/bash
#SBATCH -J mafft
#SBATCH --nodes=1 # one core
#SBATCH --ntasks-per-node=36 # on one node
#SBATCH -t 12:00:00 # Running time of 12 hours
#SBATCH -o miniprot-%A_%a.out
#SBATCH -e miniprot-%A_%a.err

# Enter the working directory
cd /work/LAS/serb-lab/kmcelroy/pterio_genome/04_opn/00_opn_search

# using miniprot 0.7-r215-dirty
miniprot $1 $2 -t 36 --gtf > $3

# $1 = genome assembly
# $2 = query protein file
# $3 = output name
```



## Build phylogenetic tree of opsins


### Collect outgroup sequences

The "pseudopsin" and melatonin receptor sequences were collected from supplemental data of De Vivo et al. 2023 Molecular Biology and Evolution

Blastp of psedudopsin sequences from supplemental file against NCBI nr database
```
>XP_021367304.1 histamine H2 receptor-like [Mizuhopecten yessoensis]
MTVPGHYSNGEANYSFWDDIYNASTSFREPYSPGWSTQGRGIVHGIFLLVFTVIGSAFNVFMIVAIVPNR
RLRTVRNILLVHLGAVGLASSMLTTLYAGVVSLCGYWLGGQSMCHAYGFIQSAFTLTSVWTIAALSWDKY
QTIASPLHHSLTATARKMTSLFAVFWLSAFILALPPLFGGNSYVFSPVTGTCFINHLDVLSRWYVGLLVS
VMFYLPLIVMIYCYTHIFRIARTQSSRIAATMVRMACVVQAPIALNTQATAPLSTSIKGTKAMLTILQLV
GAFTLTYIPFSIVILVETATGTRQVDPMLVSIVTTLFQAAPMTNSAIYGIRNKILRNSFIRYTRRKVQLF
CYKDKRKGSVKRSSSFRMSLMQRKGNQNGSAQSGHLRRTQSLQVRHLSVPKSAIVKYESSENIRKTQSFT
LQNGHAFTNEDDECCLAPPPSLNFDDVKSDILIMKKVSDTEKEKMMDNNDNEEDAIDDEEGDDEDNEDDE
DDDDDVNMDNGPM
>XP_033749045.1 G-protein coupled receptor 161-like [Pecten maximus]
MTVPGHHSSGEVNYSFWGNIYNASASFRETHPPGWSTQGRGITHGIFLLVFTVIGSTFNVFMIVAIVPNR
RLRTVRNILLVHLGAVGLASSILTTLYAGVVSLCGYWLGGQSMCHAYGFLQSSFTLTSVWTIAALSWDKY
QTIASPLHHSLTATARKMTSLFSVFWVSAFIMALPPLFGGSSYIFSPVTGTCFINHLDVLSRWYVGILVS
AMFYIPLSVMIYCYTHIFRIARTQSSRIAATMVRMACVVQAPIALNTQATAPLSTSIKGTKAMLTILQLV
GAFTLTYIPFSIVILVEAAAGRRQVDPMLVSIVTTLFQAAPMINSAIYGIRNKILRNSFIRYTRRKVQLF
CYKDKRKGSVKRSSSFRMSLMQRKSIHQNGNAQSGHLRRTQSLQVRHLSVPRSDIVKYESSENIRKTRSF
TLQNGHAFANEDEECCLAPPPSLNDFDDVKSEILIMKKVSDTEKEKMMDNNDNEEDVIDDEEGDVEEEEE
DDVTLDNGSM
>XP_011413849.2 histamine H2 receptor [Crassostrea gigas]
MIVHASNFTDRVNYSFWDETFNNTVYKPSGRLSVPRWERGGPDIVSGVFLLIFTVVGSALNVFIIIAIVP
NRRLRSVRNILLVHLAVIGILSSVITTMFSSVVVLTGRWIGGEISCQIYGFLQSSFTLVTAWTIAGLSWD
KYNTIASPLHHSLTATIKKMSCIFSIYWLFAILIALPPLFGGNEYVFHRIQGICFINHLHLPGHWYLGIA
VVVMFYLPLSVMVYCYTHIFKIARTQSSRIAATMVRMACVVQVPIAPNSQATQLNSSSIKGTKAMMTIFQ
LIGAFALTYIPYSIVIVIEACIGREYIHTMVFSVVTTLYQAAPMTNGAVYGIRNKILRNSFYNYTRRKFQ
HLRYKDKRKGSIRRTSSFRMSLLQRKTNQNGDVGSGLRRTQSLQPRHVPRIQKDILQPPSDSNIRKAYSF
TLGNGHISLEHPVIEIDEPIGFSEVSNKSVDFVANPPLTESDGQLVQII
>XP_022337418.1 histamine H2 receptor-like [Crassostrea virginica]
MIRHVGAQFEMIVHAANFSDRVNYSFWDESYNNTIFRPSGRLSLPRWERGGPDFVSGVFLLIFTVVGSAF
NVFIIIAIVPNRRLRNVRNILLVHLAVVGILSSVITTMFSSIVVLTGRWVGGDLTCQIYGFLQSSFTLVT
VWTIAGLSWDKYNTIASPLHHSLTATIKKMSCLFGIYWFFAILIALPPLFGGNEYVFHRIQGICFINHLQ
ISGHWYLGLAVILMFYLPLSVMLYCYTHIFKIARTQSSRIAATMVRMACVVQVPIAPSSQATQLNTSSIK
GTKAMMTIFQLIGAFALTYIPYSIVIITEAFIGKEYIHTMVLSVVTTLYQAAPMTNGAVYGIRNKILRNS
FYIYTRRKFQRLRYKDKRKGSIRRSSSFRMSLLQRKNNQNGDVGGGLRRTQSLQPRHVSRQPKDFPRPPC
DLNIRKAHSFTLGNGHANVELPVMEVEEPNGLSEASNKSVDFVAIPDESDGNMVQIV
>VDI44522.1 Hypothetical predicted protein [Mytilus galloprovincialis]
MFFNQTYLNVFNSTTYFGEDVIRNISTTKSTSEFLSWPPQNRNIVHGIILLTISVVGCTFNSFMIISIAP
NQRLRSVRNILLLHLAGVGLLMSMFPTLFIGVISLYGYWIGGEVTCKMLGVFITTFTSVSIWTIAALSWD
KYQTIASPLHHSLSATIRKMTFLFSLFWIFAILLSVPPVFFNNRHINHHSIDSCYGDYFKSIGSWYVTTV
FCGIYFLPFLVLLYSYTHIFIIARTQSSRIAATMIRMTCVVQAPIAFAGPSNNGISPSIKGTKAMMTILQ
LVGTFTFTYFPYAIVIVIRSYCTYTCINSVLSLVVITLNQAAPVTNGAVYGLRNKILRNSFSRYIRREFR
HMCYKDKRRGSIRSRTSSFRMSFRKTIQNGSHESFRRTQSLKVTQLSPSRPSMLNLVQKQSLRKTQSFSF
ANGHTLSCHEENMLNVPEENCEESDAIDHIISIPETKEPNRHADTILDKEGEANKFG
```
Miniprot, followed by ```gffread``` was used to get psedudopsin sequences from additional Pectinidae, Mytillidae, Ostreidae, and the *Pinctada fucata* genome assemblies.
```sh
# example
miniprot Cang_assembly.fasta Cgig_psedopsin.aa.fa --gtf > Cgig_pseudopsin_Cang_assembly.gtf
# gffread v0.12.7.
gffread -g Cang_assembly.fasta Cgig_pseudopsin_Cang_assembly.gtf -y Cang_pseudopsin.aa.fa
# -y    write a protein fasta file with the translation of CDS for each record
```

Starting with the molluscan melatonin receptor sequewnce from [De Vivo et al. 2023 Molecular Biology & Evolution](https://doi.org/10.1093/molbev/msad066)

```
>XP_014774537.1 melatonin receptor type 1A [Octopus bimaculoides]
MDLRYWTNTNNTWITPDDIFAHSAKVIPVIVITVISIFLGTFGNIFTILAIIFTKKLRTTENIFLVNLAL
ADLFVSSFVNIFSLVGAVAGEVYFKDKRVLCVFIGFFCLVCCLVSLFNITAVAFNRFIFICHHNYYRGMF
TPTKSLIIAISLWVFAAILECVNFMPWGNHAYDKKTLTCVWDRTASLGNTIFITILGISLPVMITTMSYV
MIFYHFYQAKERLNKNRNQSDKKNTLQESKKLMTTLFSLFVVFAICWLPYAFIALTDVYDTFDPLVHIYS
VTFAHMNSCLNPVVYVTNNEHFRKAFKKIVLFQCRYEQRKVANCSIQETQLYSITKNG
```

Run blastp on NCBI nr to search "bivalves".

```
>XP_052708048.1 melatonin receptor type 1B-A-like [Crassostrea angulata]
MNLSNDTTSAIPSFSDPGLFDRYQFLTESPGVAISVIVILLLAGLVGTCGNILILLALCVMKNMKSLESI
FIANLAISDMYVTLVADGMSIVAKLEGENFFSLYPGLCQFIAYGCTMSCVNSLGTIALMSFNRYIFICHH
QYYDKIFKKPTCILMCISLYSVGLLLVLLNLAGIGDHSFDRKSLECIWDRMATYYYTVVFSVTLVWIPVL
VTGFSYLNIYIMVTKSTKRMKKHQVRDQPSKSSISLARTLFIIYAVFATCWIPYALIIVVDRNDTFPHEA
HLYVTVFAHLHPSINWLVYYFTNTKFRRAFDKIAGLHRVFGLCRRQPPESIDSTGVLSTSDSHPKNKNTS
LATMSSGDDFPSKDTPTKDSVDSYM
>XP_011417075.2 melatonin receptor type 1A-like isoform X1 [Crassostrea gigas]
MNLSNDTTSAIPGFSDPGLFDRYQFLTESPGVAISVIVILLLAGLVGTCGNILILLALCVMKNMKSLESI
FIANLAISDMYVTLVADGMSIVAKLEGENFFSLYPGLCQFIAYGCTMSCVNSLGTIALMSFNRYIFICHH
QYYDKIFKKPTCILMCLSLYSVGLLLVLLNLAGIGDHSFDRKSLECIWDRMATYYYTVVFSVTLVWIPVL
VTGFSYLNIYIMVTKSTKRMKKHQVRDQPSKSSISLARTLFIIYAVFATCWIPYALIIVVDRNDTFPHEA
HLYVTVFAHLHPSINWLVYYFTNTKFRRAFDKIAGLHRVFGLCRRQPPESIDSTGVLSTSDSHPKNKNTS
LATMSSGDDFPSKDIPTKDSVDSYM
>CAC5360618.1 unnamed protein product [Mytilus coruscus]
MNLTDSSPAELIFGRYEFVDESPAVAIPILIILVLASFIGTFGNSLIFITIITTKNLQRLECVFMANLAF
SDMYITLLADPLSVVAKLEGEEFFDKIPGFCRTVASGCTIACMNSLGSITLLSFNRYVYICHHKYYFQIF
QKKTCIIMCCCLYGIGFTLVLLNFAGIGDHSFDRKSLECIWDRLDTYPYTVIFSVTLVWIPVIIVGFSYL
SIFLSVHKSRQNIKHSSSTRKTSYSSGLARTLFIIYAVFTTCWIPYALLIVSDRYNTFPHEVHIYITVWA
HLHPSFNWLVYYFTNTKFQAAFNRIAHLDKIFGRCRERQSNEELSTSGGLQKSETNKHHESTELSDITK
>CAG2226654.1 unnamed protein product [Mytilus edulis]
MNLTDSSPPELIFGRYEFVDESPAVAIPILMILVFASFIGTFGNILIHITIIATKNLQRLECIFMANLAF
SDMYVTLIADPLSIVAKLEGEEFFDKLPGFCRTVASGCTIACINSLGSITLLSFNRYVFICHHKYYFQIF
QKKTCIIMCCCLYGIGLTLVLLNFAGIGYHSFDRKSLECIWDRLDTYPYTVIFSVALVWIPVIIVGFSYL
GIFLSVQKSRQNIKHSSSMRKTSYSSGLARTLFIIYAVFTTCWIPYALIIVLDRYNTFPHEVHIYITVWA
HLHPSFNWLVYYFTNTKFQAAFDRIAHLDKIFGRCRRGQCNEELSTSGGLQKADTSKQHHESSELSDITK
>XP_033744551.1 melatonin receptor type 1B-B-like [Pecten maximus]
MDNYTTTMEAPTAIHSDQIWGRHQFLQESPGLAIPCIIVLTFASIVGTFGNVLVIVAVSTQKSLKNRESI
FIVNLAISDLYITTVADPMGIVAKLEGEQFFDRVPGLCRTIASICTVSCIVSLGSIACLSFNRYIHICHN
RHYNRIFTGRNCIIICGALYMVGITLVLLNLAGIGDHSFDRKSLECIWDRMATFPYTVVFSVTLVWVPVI
VTGISYISLYIYVLKSQKRIQQHSQLSATMISASDITDAEKNERRQKPNHQDHLSIPSLLQRKAVRKSLH
LARTIFVVYAVFSTCWIPFAILMVVDTHNTFSHAIHLYITVFAHLHPSLNWLVYYITNKKFAVAFDKLVF
MKRWVPRLRPAELSQHSTMAHQRET
>XP_021366632.1 melatonin receptor type 1B-B-like [Mizuhopecten yessoensis]
MDNFTTTTEAPIAIHTDQIWGRHQFLHESPGLAIPCIVVLAFASFVGTLGNVLVIVAVATQKSLQNKEST
FIVNLAISDLYITTVADPMGIVAKLEGEQFFDSIPGLCQTIASICTVSCIVSLGSIACLSFNRYIHICHN
RHYNRIFTGRNCVIICGALYVVGITMVLLNLTGIGDHGFDRKSLECIWDRMATFPYTVVFSVTLVWVPVL
VTGISYINLYIYVLNSQKRVQQYSTMTPTSENKDHDKNESEKTNHPDNHSNQPFIHRISVRKSLHLARTI
FVVYAVFSICWIPFAILMVVDTHNTFAHAVHLYITVFAHLHPSLNWLVYYATNKKFAVAFDKLLFMNKWV
PRLRPAVPSLHITASHTRECHSQQ
>KAJ8301991.1 hypothetical protein KUTeg_020978 [Tegillarca granosa]
MLSGMVENITTVPLTRVDYVYFHRHRFIVESPEIAIPCLIILFIASVLGTFGNVLILVAVKRTKQLHNVE
SILIVNLAISDMYVTAVADPMSIVAKLEGEVFFASIPGLCRIIGSLCTISCCMSFNRYIHICHNTAYVKL
FTKEGSVAMCLSFYSVGATLVMLNLAGIGDHSYDRKSMECIWDRMATYPYTIIFSICLVWIPILITGFSY
SRLYRYVQKSRKRVQEHNLNPMPVKRPNLRKSFALAKTLFIIYAVFSLCWIPYALLLVLDKEDTYSHVVH
LYITTFAHLHPSINWLVYYLTNKKFSNAFNKMLPFKKCFGSYSPQGGSTSTQMQNCQGSQPLRSAVPLPL
TQPSPSVQKLTLQQTSPPSRIMLLTHK
```

These sequences were used as input for ```miniprot``` to extract protein sequences from additional genomes.

Also include in phylogenetic analsys the "Placopsins" that have been used in several opsin phylogentic studies, first reported in [Feuda et al. 2012 PNAS](https://doi.org/10.1073%2Fpnas.1204609109)

```
>Placopsin_XP_002113363.1
VYLILQATILSIITLFMIVGNFIVIVVVNRSEQLQNATGIFMANLAVTDLTLGVILMPITIASSILGRWIFSDIMCKFCGFLNVMLCSTSALTVMLLSIDRFIAISRPMQYIKIMSKKRALVLSTYMWIHSAIVSTFPLLGWAKYEYVEAEAVCFAIESVSYFNFLCASTVFLAIFLIIITHIYILKVIKQSQQIVTLTPGFEDVTRETMRQMNRKTAKTVLIIVGVYLACWIPYISLTYVQIYANYVPPPIAITITSGLIFVNSASNPIIYGTFHRRFRNAF
>Placopsin_XP_002112437.1
MADTYINNFTNKSLELCNGSLVVSDCLWRIILSCFMTLFMLMSCIGNGAVLLVLRYHHDDIKSASNYFITNLALTDFLLGVLCMPCILISCLNGQWVFGQTLCSLTGFANSFFCINSMITLAAVSVEKYCAIASPLTYHHYMSKSKVTCVISIIWIHSAINASLPFLGWGEYVYLPFETICTVAWWSFPNYVGFIVGINFGLPTVIMSCTYFLILKIARKHSRRIGVSTRRIHYKTHIKATLMLLIVIGSFIVCWLPHLISMIYLTIYEISPLPCSFHQITTWLAMANSAFNPIIYGAMDTSIRKGLKTLLGSWVKYCKLY
```


### Phylogenetic analysis

Script to align and generate a phylogenetic tree

```bash
#!/bin/bash
#SBATCH -J OpsinPhylo
#SBATCH --nodes=1 # use 1 core
#SBATCH --ntasks-per-node=36 # use 36 nodes
#SBATCH -t 24:00:00 # Running time of 24 hours
#SBATCH -o OpsinPhylo-%A_%a.out
#SBATCH -e OpsinPhylo-%A_%a.err
#SBATCH --mem=300G
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=REQUEUE
#SBATCH --mail-user=address@iastate.edu

# Load mafft module
module load mafft

# 1) Align the sequences with MAFFT
# 2) Generate maximum-likelihood tree with IQTree2

# Program versions:
# MAFFT v7.481 (2021/May/26)
# IQ-TREE multicore version 2.1.3 COVID-edition for Linux 64-bit

# Run mafft einsi strategy
mafft --thread 36 --maxiterate 1000 --genafpair Pteriomorphia_opn_out.aa.fasta > Pterio_opn_out.aa.mafft-einsi.fa
#       --thread # :     Number of threads (if unsure, --thread -1)
#       --maxiterate # : Maximum number of iterative refinement, default: 0


# Run iqtree2
iqtree2 -nt AUTO -s Pterio_opn_out.aa.mafft-einsi.fa -B 1000 -m JTT+F+R9
# -T NUM|AUTO          No. cores/threads or AUTO-detect (default: 1)
# -s FILE[,...,FILE]   PHYLIP/FASTA/NEXUS/CLUSTAL/MSF alignment file(s)
# -B, --ufboot NUM     Replicates for ultrafast bootstrap (>=1000)
# --alrt NUM           Replicates for SH approximate likelihood ratio test
# --abayes             approximate Bayes test (Anisimova et al. 2011)

```

Prune tree in ```R``` with package ```ape``` to keep only the sequences from spcies used for expression analysis along with Placopsins in the outgroup.

```R
####
# Pruned-tree_old-new_withPlacopsin
library(ape)

# Read the text file containing tip names
tip_file <- "Opsin_List_Pterimorphia_old-new_RemoveSpecies.txt"  # Set the tip files need to be removed
tips <- readLines(tip_file)

main_Tree <- read.tree("Tree_Pteriomorphia_opn_Renamed_Old-New_All.iqtree.newick")

# Prune the tips from the tree
mystudy_pruned_tree_old_NewNamed_withPlacopsin <- drop.tip(main_Tree, tips)

#View(mystudy_pruned_tree_old_NewNamed_withPlacopsin)

# Plot the pruned tree
#plot(mystudy_pruned_tree_old_NewNamed_withPlacopsin)

# Export the pruned tree as newick
write.tree(mystudy_pruned_tree_old_NewNamed_withPlacopsin, file = "mystudy_pruned_tree_old_NewNamed_withPlacopsin.newick")
```
