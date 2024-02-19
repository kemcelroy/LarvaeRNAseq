# Use publicly available RNA-seq datasets to measure opsin expression

### For each of the following datasets, follow this outline
```
1. Download RNA-seq from SRA using fastq-dump (version 3.0.0)
2. Perform quality control of RNA-seq reads with fastp (version 0.23.2)
3. Download CDS from genome annotation (NCBI or other hosting location)
4. Match opsins in transcriptomes/add them in where absent (tblastn BLAST 2.13.0+)
5. Use salmon (version v1.9.0) for pseudoalignment-based quantification of expression
    a. Index the transcriptome
    b. Run salmon quant
6. Collect tpm values from output

```
### SRA accessions

Have a file ```metadata.txt``` like this

| Species                | Stage                 | SRA accession | BioProject   |
|------------------------|-----------------------|---------------|--------------|
| *Mytilus edulis*       | trochophore           | SRR6873087    | PRJNA439300  |
|                        | veliger               | SRR6873088    |              |
|                        | pediveliger           | SRR6873089    |              |
|                        | adult mantle 1        | SRR8668942    | PRJNA525607  |
|                        | adult mantle 2        | SRR8668943    |              |
| *Mytilus coruscus*     | trochophore 1         | SRR13364386   | PRJNA689255  |
|                        | trochophore 2         | SRR13364385   |              |
|                        | trochophore 3         | SRR13364374   |              |
|                        | trochophore 4         | SRR13364373   |              |
|                        | veliger 1             | SRR13364372   |              |
|                        | veliger 2             | SRR13364371   |              |
|                        | veliger 3             | SRR13364370   |              |
|                        | veliger 4             | SRR13364369   |              |
|                        | pediveliger 1         | SRR13364382   |              |
|                        | pediveliger 2         | SRR13364381   |              |
|                        | pediveliger 3         | SRR13364380   |              |
|                        | pediveliger 4         | SRR13364379   |              |
|                        | adult mantle          | SRR9090063    | PRJNA543748  |
| *Crassostrea gigas*    | trochophore 1         | SRR2601701    | PRJNA298285  |
|                        | trochophore 2         | SRR2601703    |              |
|                        | veliger 1             | SRR2601698    |              |
|                        | veliger 2             | SRR2601707    |              |
|                        | pediveliger 1         | SRR2601666    |              |
|                        | pediveliger_2         | SRR2601716    |              |
|                        | adult mantle 1        | SRR22387571   | PRJNA904561  |
|                        | adult mantle 2        | SRR22387572   |              |
| *Crassostrea angulata* | trochophore 1 (1dpf)  | SRR14269655   | PRJNA668688  |
|                        | trochophore 2 (1dpf)  | SRR14269654   |              |
|                        | trochophore 3 (1dpf)  | SRR14269647   |              |
|                        | veliger 1 (4dpf)      | SRR14269646   |              |
|                        | veliger 2 (4dpf)      | SRR14269645   |              |
|                        | veliger 3 (4dpf)      | SRR14269644   |              |
|                        | veliger 1 (7dpf)      | SRR14269643   |              |
|                        | veliger 2 (7dpf)      | SRR14269642   |              |
|                        | veliger 3 (7dpf)      | SRR14269641   |              |
|                        | pediveliger 1 (17dpf) | SRR14269640   |              |
|                        | pediveliger 2 (17dpf) | SRR14269653   |              |
|                        | pediveliger 3 (17dpf) | SRR14269652   |              |
|                        | pediveliger 1 (21dpf) | SRR14269651   |              |
|                        | pediveliger 2 (21dpf) | SRR14269650   |              |
|                        | pediveliger 3 (21dpf) | SRR14269649   |              |
| *Pinctada fucuta*      | trochophore           | DRR350405     | PRJDB13068   |
|                        | veliger               | DRR350406     |              |
|                        | pediveliger           | DRR350407     |              |
|                        | adult mantle          | SRR17133681   | PRJNA786017  |
| *Chlamys ferreri*      | trochophore           | SRR5194521    | PRJNA185465  |
|                        | d-stage veliger       | SRR5194520    |              |
|                        | pediveliger           | SRR5194516    |              |
|                        | adult mantle 1        | SRR5130862    |              |
|                        | adult mantle 2        | SRR5130868    |              |
|                        | adult mantle 3        | SRR5130890    |              |
|                        | adult eye 1           | SRR5130871    |              |
|                        | adult eye 2           | SRR5130884    |              |
|                        | adult eye 3           | SRR5130889    |              |
| *Pecten maximus*       | trochophore 1         | SRR2601059    | PRJNA298284  |
|                        | trochophore 2         | SRR2601062    |              |
|                        | veliger 1             | SRR2601057    |              |
|                        | veliger 2             | SRR2601067    |              |
|                        | pediveliger 1         | SRR2601049    |              |
|                        | pediveliger 2         | SRR2601077    |              |
|                        | adult mantle 1        | SRR14339748   | PRJNA719586  |
|                        | adult mantle 2        | SRR14339747   |              |
|                        | adult mantle 3        | SRR14339746   |              |


## 1. Collecting RNA-seq reads

Make a text file containing the SRA accession numbers
```sh
awk {print $3} metadata.txt > SRA_larvae
```

```bash
#!/bin/bash
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # 36 processor core(s) per node
#SBATCH --job-name="SRA_bivalve_larvae"
#SBATCH --mail-user=address@iastate.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -o SRA_bivalve_larvae_%A_%a.out
#SBATCH -e SRA_bivalve_larvae_larvae_%A_%a.err

# load parallel
module load parallel

# load sratoolkit
module load sratoolkit

# enter working directory
cd /work/LAS/serb-lab/shazid/Opsin_expression/

# use parallel to download SRA files based on entries in text file "SRA_larvae"
parallel --jobs 36 "fastq-dump --split-files --origfmt --gzip {}" :::: SRA_larvae

mv *.gz 00_SRA_files 

```

## 2. Quality control of RNA-seq data

Use the same SRA_larvae text file as input for 

```bash
#!/bin/bash

#SBATCH --time=6:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # 1 processor core(s) per node
#SBATCH --job-name="fastp_bivalve_larvae"
#SBATCH --mail-user=address@iastate.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --array=0-63 # run 64 jobs in an array
#SBATCH -o fastp_bivalve_larvae_%A_%a.out
#SBATCH -e fastp_bivalve_larvae_%A_%a.err

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

# enter working directory
cd /work/LAS/serb-lab/shazid/Opsin_expression/

# Call SRA files
names=($(cat SRA_larvae))
echo ${names[${SLURM_ARRAY_TASK_ID}]}

# Run fastp version 0.23.2 on pairs of RNA-seq data downloaded from SRA files
fastp \
        --detect_adapter_for_pe \
        -i "00_SRA_files/${names[${SLURM_ARRAY_TASK_ID}]}_1.fastq.gz" \
        -I "00_SRA_files/${names[${SLURM_ARRAY_TASK_ID}]}_2.fastq.gz" \
        -o "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}_1.trim.fastq.gz" \
        -O "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}_2.trim.fastq.gz" \
        -h "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}.html" \
        -j "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}.json"
```

## 3. Download CDS files

Most of these were downloaded from NCBI but a couple were other public databases

```sh
# Cang
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/025/612/915/GCF_025612915.1_ASM2561291v2/GCF_025612915.1_ASM2561291v2_cds_from_genomic.fna.gz 
gzip -dv GCF_025612915.1_ASM2561291v2_cds_from_genomic.fna.gz

# Cgig
wget https://ftp.ncbi.nlm.nih.gov/genomes/refseq/invertebrate/Crassostrea_gigas/latest_assembly_versions/GCF_902806645.1_cgigas_uk_roslin_v1/GCF_902806645.1_cgigas_uk_roslin_v1_cds_from_genomic.fna.gz
gzip -dv GCF_902806645.1_cgigas_uk_roslin_v1_cds_from_genomic.fna.gz

# Pfuc
wget https://marinegenomics.oist.jp/pearl_4_1A/download/pfuV4.1HapA_ref_genemodels_nt.fasta.gz
gzip -dv pfuV4.1HapA_ref_genemodels_nt.fasta.gz

# Medu
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/905/397/895/GCA_905397895.1_MEDL1/GCA_905397895.1_MEDL1_cds_from_genomic.fna.gz
gzup -dv GCA_905397895.1_MEDL1_cds_from_genomic.fna.gz

# Myco
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/011/752/425/GCA_011752425.2_MCOR1.1/GCA_011752425.2_MCOR1.1_cds_from_genomic.fna.gz
gzip -dv GCA_011752425.2_MCOR1.1_cds_from_genomic.fna.gz

# Cfar
# download from http://mgbase.qnlm.ac/page/download/download
# no ftp or copyable link address, so click to download locally and move to computing space
# Chlamys_farreri_hic_hwt_20211125.cds.fa

# Pmax
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/902/652/985/GCF_902652985.1_xPecMax1.1/GCF_902652985.1_xPecMax1.1_cds_from_genomic.fna.gz
gzip -dv GCF_902652985.1_xPecMax1.1_cds_from_genomic.fna.gz

```
Generate symbolic links with consistent naming.

Uses this table, ```link_names```
```
GCF_025612915.1_ASM2561291v2_cds_from_genomic.fna	Cang
GCF_902806645.1_cgigas_uk_roslin_v1_cds_from_genomic.fna	Cgig
pfuV4.1HapA_ref_genemodels_nt.fasta	Pfuc
GCA_905397895.1_MEDL1_cds_from_genomic.fna	Medu
GCA_011752425.2_MCOR1.1_cds_from_genomic.fna	Myco
Chlamys_farreri_hic_hwt_20211125.cds.fa	Cfar
GCF_902652985.1_xPecMax1.1_cds_from_genomic.fna	Pmax
```

```sh
cd 04_dbs
while IFS=$'\t' read -r col1 col2; do ln -s "/work/LAS/serb-lab/shazid/Opsin_expression/03_transcriptomes/${col1}" "${col2}_cds.fa"; done < link_names
```

Make blast databases for all of these transcriptomes
```sh
#pwd = 04_dbs
module load blast-plus
for f in *_cds.fa; do makeblastdb -in $f -out "${f%.*}" -dbtype nucl; done
```

## 4. Match opsins in transcriptomes/add them in where absent

Use ```tblastn``` to identify/replace or add in opsins to the transcriptomes. Have amino acid fasta files for each species, e.g., ```Cgig_opn.aa.fa```.

> cat Cgig_opn.aa.fa
```
>Cgig-opn5
MTQVHTTYKSEFLIKTSVHLDNFTEFRKLDIFDSKLTVWEDYLVGIQLLLTAFSAFVLNIFVIIVCVRKRSSLVPADYFIVNLAVSDLILSVVGLPFGISSSFLHRWTFGSGGCRIYGCLGFFCGVVSISTLALMSFSRYIHVCKSSKSPFFSKHTNFFIIGSYVYACAWASFPMLGWGEYGVEAYGTSCTLKWTENRGFVTLMLISCIIFPVIIMKFCYGGVYLYLRRHCKAFRTDRSKMGINVRKREGYLIKMAFMMCCAFMLTWTPYAVVSFWAAYGDPNSIPVRLTLVSVLIAKTSTIWNPLIYFVLNKKFRPHIRFCLQNLFRNETNAQDRRTRSSWFFCNSRSSMTSSL
>Cgig-RTC
MAAVTGEFSEVEHKGVAILYFIFGVSGVLANSFVLKTFMKEGVLVSPKNILHINLAFSNILVVLGFPFSGLSSWHGKWVFGIRGCQLYGVESYTGGMACPAFIFTLCLERYLANRQRHIYDTMTTGTWWLIALAVWLHAITWAILPILGWNSYSMEASGVSCGLSWLKHDFNHASFIMVMTIEYATLFLLAILFLRSAKSYVDSPTVLEVNTKNWFTEKQLVWITFAFLMIAGVGWGPYGYFGIWSQRTKITSVSMLAVTLPPLFAKASASLYIVPYLAASDHFREAIVGGATPVKKDQ
>Cgig-peropsin
MDYSNTTCLNVTETIVLHPPHQPKLSTLQGNIIAIYLTVVGIFSLIGNGITIVVICRFPKLRTAANIFIANLAAADLAITILTFPFSVVSHFYNGWQFGQDVCRWYGFNCMLFGLGSIAFLAAISCDRYLVTCRHELYCKFSKRHYFIVSVLLWTNCMIWAAAPFMGWGCYDNDVTGVLCTITWTCNGRAAFASFIYALSVVCFILPCCIITVSYRKTYQFIKAVGAGGSQENIEWTHQKQITKMCVVAVILFLVAWMPFTIYFLIISIQEASTLPALFHVVPAVFAKTSTCYNPVIYAIVNKRFRIAIQKTILCEKNVNDLDCMPMRRVR
>Cgig-opnGo
METFGNSTEMLAQEKLSAASYISIGVYMIVLTLTAILGNCLVLFVYWKRSLYKRPVNWFILNISVADLCVALFAHPLSASASFNRSWNLDGVGCQMYGFFCYIFACNNIMTYAAISYFRYQIVCENNYVARIQRGRILSVLISIWMFSLFWTVSPLVGWNGYELEPYRLTCSIRWYGHVDSDRAYICLVLLCVYVFPLTVMIFSYIQIARHARRLSCTYPSSNEGGNKAKFLYNLERGATKISLLMTLSFVFTWTPYAFMSTVAASGVTINSPVVLLPTLFAKSSCAYNPFVFFFSHSAFKSYHFGFSSCIKTPETQEHPGVYVSNVRFRNRVGPSGATHATSRAGIRSSTEAIPNGDHSKVIQISVHPVQQSNVL
>Cgig-opnGx1
MNTSNISGVVPGVPLVKYFIPQPLYYIIGTGLLFVFTFGSFMNFTGLLVFAKNKHMRSPTNTFIISLLMGDFGMSICSFISMTAHYNRFYLWGDNVCTFEGFWMYFMGLTNMYTIMGISFDRYIVIAKPLQASKITTRVAVAACLAIWFQGFAWAAFPFLGWGRYTYEAGRTSCSVQWDTDDIESASYNISIFIWSLFLPLMLIFYCYYNVFMTIRHVARNGVWDMNSRIARKNLRIEKKMFKTIVYMLVSYVGSWTPYSIVSLWAIFGEAKDIPPYLMTVPAVIAKSACIWDPLIYVGTNRQFRMAFYNTLPCDGLGKMLIKREEQKDKEADASDDEDEAGKKAEGTAVKKTTLVAPIDDEAGQTTQVENFPDPNSPQPGQSGNP
>Cgig-opnGx2
MDLLNITMNEVEVSKYPIPIPLYYVIGSGLLIVVTLGPFMNITSLAVFAQNKHLRSPTNIFVISLLLGDVGMSCVALISMVAHFNRYYFWGDRVCVFEGFWLYLMGLTNLYTHAVIAVDRYIVIAKPLSAHRVTKRVAVVAVLVVWIQGLLWASFPHFGWGKYTYEPARTSCAVEWDSKEIGSASYNVAITIWSLCIPLGLIVFSYYRVFMTIRHVARSGIWDTSSRIARKNLKMEKKMFKTIAYMLASYLWSWTPYTVVSVWAIIGESRDIPVYIITIPAVVAKSSCIWDPLIYLWTNRQFRIAFYKTMPCKSLGEKLLQRDELKHRETESSPPQEPQELRHKSNRLTPLRQTTTKQGPAVSVSEYGQKTETMGVSQINVPHVVVQGPSKTGNVC
>Cgig-opnGx3
MSSTLHLNCLSNATEVNESICEETRQQGELPGPMYVVLAVYLFFLTFFGILVNGAVIYLYFSRREIATVSNMYIVALCLCGFLIATLGIPFAAASSIRHHWLFGDGMCKLHGFLLTGLGIVMIALMTGIAIDKYIHIVWFQAHRKVTKSFALGIITLCYVYGVIWGILPLFGWNKYILEPARLTCSVEWTGDFSNHSYAITILFTGLLIPVGVIASLYSSILKKIHLQRKSSQQLVSLARKQKMIKREKKVAITLFLMVGSFIVAWLPYSIYGFICILGYSKDIPLVWHTIPSVFAKASILWNPLIYASRSKVMKKALAETFPFLRWLIRNPDKVQTNEQKNQTSLTLLRSRTLNSSDVVVQSSSENPAISASV
>Cgig-opnGx4
MIVVMNGTNSSKFWTIAREHEKLADAMHYAIGVAFVLIMLISTLGNGGVMYVFIRTRNLRTPNYFLVSALCLGDFLMSTLGMPMFITSCFFTRWILGRVGCLVYGTLMTFLGLSQITLLASIAFTRYRYVVNNCSIDTLVAKIVVIMCYLYAFIFSLAPLFGWSRPVVEPIGTSCGPNWAGTEPRDVSYNLTIFVLCFFVPLSIITFSYFMIYLKIKRKRIHKKTDGYENHVTVTILLMIVAFLLSWSPYAALAMYVIITKNSTMHLALSSVPVVLAKTAPLWNPYIYFVRDRRFNKECEKLLPIFKKLGIFESHRTEQHEWHQMGDTSSTNVPLCEHEKQKTVADLKKARTF
>Cgig-opnGx5
MNSSNLTEKVNVMSKEIPDSVHYIFGVVYMLLNVVATTGNVVVLYVFFRSKKLHSAIYFMISALCLGDLLMSSVGLTILSIASFATYWVLGDWGCIAYGTLMTFLGLMQITLLTVIAVTRYIFVVHNNNIGPCSAKVITLLCTLYALGFSVAPLLGWSKFVLEPIGTSCGPNWVGIEWSDVSFNMTLFFLCFLAPLSFILFSYIMIFWKVRRKRIQKKNETYEIHVSTTILFMIVAFLGSWTPYAFMALYIVITKNNQIHPLLAALPLVFAKCAPIWNPYIYFMRDTKFNHECRKMLPILSRLGLWRVNPGSSQADHVMHLNDTLSRKTSTYV
>Cgig-opnGq
MDSTATYLPPTTVTDISMNETTTHIFDTYTFFVHPHWYNFPLVSDNWHYAIGVFISIVGIIGIFGNATVIYIFSTTKNLKTPSNMFIVNLALSDMIFSLVMGFPLLTISAFNKKWIWGNTACELYGLVGGIFGLMSITTLSAISVDRYYAIAHPLRAARNMTRKKAFIMICIVWVWSLCASLPPLFGWGRYVAEGFQTSCTFDYLTTTPNNRTYIFFLYLFGFAAPLLVIALSYILIIRALKKHERKMQQMAAKMKVDDIKANQEKTKAEVKVAKVAIIIVFFYMLSWSPYATVALIGQFGPAEWVTPFLSELPVMLAKASAMHNPIVYALSHPKFREALYKRAPWIFCCCEPPSKATPRTSKATNVSRTMSGLSDTVGGAASELSSCVSNLSDTRENTLEMRRTGKNSNDQETGNSSQLIQGLVQALVGVTNQQNRQVVYLPQNQSAQQAQGADQNNVFVVDNGGQKIDIKAYLQEIIAAEKIADAVKDTETNSVEMRNEPSTSQDEKEASKVESHHV
>Cgig-opnGq-nc1
MTENLSFLHPYWHRFGQISPTYHVTIGVIMVFTTVGAIAGNGLVIWCFISFRSLRTSSNVFIINLSIANLLMSLIDFPLLIIASFYHDWPFGQTVCEAYATLTGLSGLVTINSLTVIAVDRYCAIVIRVKSVSPAPKWKTYKATIVIWTYALFWSLSPVLGWSKYQLEGVRTTCSFDYLTRDATTISFIVAIATCEFAIPVTVIILAYCKIVTAMIVRRRNLSICKKSENSSLNFRLQRYRVRAEIRTAFIIIGLVCLFVVSWLPYTVTAMVGLFGDRTLITPYLSSVAGLIAKTSTVFNPIVYAIIHPKFKSKIKCMLYRRNSLNSGPLSKMNSRMSSNKFSSSGFEKQQIEFDIKSNRNSDLS
>Cgig-opnGq-nc2
MMENIIHTDVNFTSCELHKLIARHWLNYEGVSHVFHLILGVVVVIVGIISFTSNGFILWMFYRYRSLRISSNLLVLNLAITDTFLALGNLPWLAISSFRGVWIFGYIGCQVYGFVGAMSGFISINTLAMIAIERFFVIVIREPYRHIRTSNKTVLISIMFIWIYSFVWAICPLIGWGSIILEGSMTSCTFDFFSRDVNTKSYVASILVFCFTVQLFLIICSYVRIYLKVLQHEKEIVNCYSDGNNTLQIQNRKVRKFRSVHVKTAKISLVIISIFCLSWTPYAVVAIIGNFGDASVITPLASTIPGVFAKLSTVLNPMIYALLHPKFRNKLPFRKKKVLKAKSNFQALMKLDNESPPQTSSSLSIQFNANTPKEFHKETVV
````

Use this shell script to perform tblastn
```sh
#!/bin/sh
# name: blast_script.sh
# written assuming the query fasta is in current working directory
# enter the type of blast (e.g., tblastn) for $1, query fasta file for $2, path to the blast database for $3, and an evalue (e.g., 1e-50) for $4
# example: sh blast_script.sh tblastn query.fasta /path/to/db 1e-50
$1 -query $2 -db $3 -outfmt '6 qseqid qlen sseqid slen qframe qstart qend sframe sstart send evalue bitscore pident nident length' -evalue $4 -out "${2%.*}_${3##*/}.${1}.hits"
```

```sh
for f in *_opn.aa.fa; do sh blast_script.sh tblastn $f "04_dbs/${f%_opn.aa.fa}_cds" 1e-50
```

Manually edit transcriptomes as needed.


## 5. Use salmon for gene expression quantification

### a. Index the transcriptome

```bash
#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename

#SBATCH --time=12:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # 1 processor core(s) per node
#SBATCH --job-name="salmon_index"
#SBATCH --mail-user=address@iastate.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -o salmon_index_%A_%a.out
#SBATCH -e salmon_index_%A_%a.err

# enter working direcroty
cd /work/LAS/serb-lab/shazid/Opsin_expression/04_dbs

# generate salmon (v. v1.9.0) indexes of the transcriptomes

for f in *_cds.fa; do salmon -t $f -i "${f%.fa}_index"; done

```

### b. Run salmon quant

To run ```salmon quant``` on all of the data, run array jobs for each species.

Example: *Crassostrea gigas* with a ```Cgig_jobs``` text file listing the SRA file names

```bash
#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    sbatch thefilename

#SBATCH --time=12:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # 36 processor core(s) per node
#SBATCH --job-name="salmon_quant_Cgig"
#SBATCH --mail-user=address@iastate.edu   # email address
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH -o salmon_quant_Cgig_%A_%a.out
#SBATCH -e salmon_quant_Cgig_%A_%a.err
#SBATCH --array=0-7 # run 8 jobs in an array

# enter working direcroty
cd /work/LAS/serb-lab/shazid/Opsin_expression/
# collect input for job array
names=($(cat Cgig_jobs))
echo ${names[${SLURM_ARRAY_TASK_ID}]}

# run salmon v1.9.0
salmon quant -i /work/LAS/serb-lab/shazid/Opsin_expression/04_dbs/Cgig_cds_index -l A \
        -1 "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}_1.trim.fastq.gz" \
        -2 "01_fastp/${names[${SLURM_ARRAY_TASK_ID}]}_2.trim.fastq.gz" \
        -p 36 -o "05_Salmon_quant/${names[${SLURM_ARRAY_TASK_ID}]}_quant"
```

Use the same ```_jobs``` text files as input to collect ```tpm``` values fromt the Salmon output

Example with *Crassostrea gigas*

```sh
# make file with headers for columns
echo -e 'sample\ttranscript\tcounts\ttpm' > tpm_comp_Cgig.tab

# collect data from quant.sf files
while read line; do awk -v OFS='\t' 'FNR>1 {print var,$1,$5,$4}' var=$line "05_Salmon_quant/${line}_quant/quant.sf" >> tpm_comp_Cgig.tab; done < Cgig_jobs
```

