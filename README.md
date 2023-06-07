# Bioinformatics institute spring project.

In this repository we are reproducing an article, which can be found by this [link](https://elifesciences.org/articles/65041 "The reproduced article").      
Vazquez, J. M., & Lynch, V. J. (2021). Pervasive duplication of tumor suppressors in Afrotherians during the evolution of large bodies and reduced cancer risk. Elife, 10, e65041.

## Students 

1. Igamberdiev Lev, [MIPT](https://mipt.ru/ "Moscow institute of physics and technologies").
2. Valeria Lobanova.
3. Anastasiia Bukreeva

## Curators

1. Yuriy Malovichko, LOEWE Centre for Translational Biodiversity Genomics, Germany.

# Introduction

# Aim and tasks
## Aim
Asses the impact of gene duplication pattern and body size on cancer development risk in Afrotheria.
## Tasks
1. Reconstruct the mammalian phylogeny (Lev)
2. Infer the body size evolution rates (Lev & Anastasiia)
3. Establish the orthology between all genes in the selected species via RBHB (Anastasiia & Valeria)
4. Assess potential duplications within the Afrotheria clade (not done)
5. Infer the ancestral copy numbers for the potential duplicates (not done)
6. Prove the potential duplicates' expression with the transcriptomic data (Anastasiia)
7. Correlate the duplication rates with the genome quality statistics ([BUSCO](https://busco.ezlab.org/)) (Lev)
8. Explore the functional enrichment of the potential duplicates (Anastasiia)

# Working pipeline

## Reconstruct the mammalian phylogeny (done)
To reconstruct the mammalian phylogeny we used trees from other articles. One tree contained extant and extinct species of _Afrotherians_, the other contained placental mammalians phylogeny. We have replaced afrotherian clade in mammalian phylogeny and got a supertree. Scrpit can be found in scripts folder as `replace_afrotheria.R`. All dependencies for script are mentioned in the beginning of it. The resulting supertree is shown below with highlighted _Afrotherian_ clade.

![_Afrotherian_ clade in mammalian tree](https://github.com/bi-LVYproject-2023/vazquez_2021/blob/main/figures/mammaliantree.jpg)

## Infer the body size evolution rates (not done)
We were trying to reconstruct ancestral states by `stabletraits`, but we have faced several problems with starting it from command line. After this we had tried to use R packages to solve out problem, but it had not help us. As the result, we got body size table for extant species, but we were not able to infer the body size evolution rates.

## Establish the orthology between all genes in the selected species via RBHB
 
### Download genomes

List of genomes, resources for downloading and commentaries:    
https://docs.google.com/spreadsheets/d/126XjvKZmN4m7YIQQ7hjx4LKbH4Wdca3y9o761Nd-VMI/edit#gid=0  

**15** full genomes of Afrotheria were needed.    
**10** genomes were available for downloading at DNAZoo or NCBI.    
**5** genomes of extinct proboscideans were introduced only as BAM files.     

This genomes should be downloaded manually (in FASTA format):    
https://www.ncbi.nlm.nih.gov/data-hub/genome/GCF_000296735.1/     
https://www.ncbi.nlm.nih.gov/data-hub/genome/GCF_000208655.3/     
https://www.ncbi.nlm.nih.gov/data-hub/genome/GCA_000313985.1/     
https://www.ncbi.nlm.nih.gov/data-hub/genome/GCF_000299155.1/ 

For downloading other FASTA genomes run:

	scripts/download_genomes_fasta.sh

For getting FASTA for ancient genomes see instructions in **data/raw/genomes**.

For deriving summary stats table about reconstructed genomes see **~/notebooks/genome_stats.ipynb**


|   | Genome  | Chromosome_count | Genome_length | GC_content | N_content  | N_content_percent |
|---|---------|------------------|---------------|------------|------------|-------------------|
| 0 | mamPriV | 2217             | 3268239107    | 31.807922  | 710426181  | 21.737277         |
| 1 | loxCycF | 2260             | 3270066510    | 37.370529  | 260415930  | 7.963628          |
| 2 | mamColU | 2136             | 3266252356    | 21.840385  | 1584501481 | 48.511300         |
| 3 | mamAmeI | 2153             | 3266707888    | 31.401881  | 755946427  | 23.140925         |
| 4 | palAntN | 2274             | 3269440243    | 32.847895  | 596278337  | 18.237933         |

We annotated one of the reconstructed ancient genomes (*Mammuthus columbi*), the genome of Mammuthus columbi, with Augustus:

	scripts/annotation.sh

Some stats were obtaining using next commands:

Chromosome count: 171
	
Proteins sequences count: 11552

CDS count: 69431

### Prove the potential duplicates' expression with the transcriptomic data

List of animals for transcriptome analysis: *Dasypus novemcinctus*, *Loxodonta africana*, *Trichechus manatus*.
For alignment to match sequencing reads we used the HISAT2 programme. We assembled the RNA-seq alignments to potential transcripts using StringTie.

Installing HISAT2 and StringTie software to working environment:

	conda install -c bioconda hisat2
	conda install -c bioconda stringtie

All steps were done with the following scripts:
	
	scripts/transcriptome/D.novemcinctus.sh
	scripts/transcriptome/L.africana.sh
	scripts/transcriptome/T.latirostris.sh


### Filtering human proteins for RBH BLAT

We downloaded human proteins hg38 assembly version from all available components (chromosomes) except unplaced from UniProt:    
https://www.uniprot.org/proteomes/UP000005640

Then we filtered out proteins as suggested in the original article:   
https://colab.research.google.com/drive/1vkKK-bDu3C5pw5PmG8G5N_xI4JGd6PAL?usp=sharing 

Details about filtered categories, regular expressions and so on could be found at Google Sheets:    
https://docs.google.com/spreadsheets/d/126XjvKZmN4m7YIQQ7hjx4LKbH4Wdca3y9o761Nd-VMI/edit#gid=791643136 

### Reciprocal best hit BLAT

For *Mammuthus columbi*, we performed the Reciprocal Best Hit BLAT procedure versus filtered human proteins from hg38 assembly version.

Installing BLAT software to working environment:

	conda install -c bioconda blat

First, we did two BLAT analysis: (1) mammoth’s protein sequences versus human protein sequences and (2) human protein sequences versus the mammoth’s protein sequences. Second, we sorted and filtered BLAT results. These steps were done with the following script:

	scripts/rbhb.sh

Third, we tried to found reciprocal best hits with python notebook **notebooks/RBH_mammoth.ipynb**.


## Correlate the duplication rates with the genome quality statistics (done)

We used the BUSCO software to calculate quality statistics. Quality was assessed for all the available genomes. As we lacked computational power, we decided to calculate quality metrics with functional proteins as input, they can be found in data folder of this repo. This procedure did not significantly changed the statistics, but accelerated the process of calculation and decreased amount of RAM in use from 15.9 GB to 4.9 GB approximately per genome. We used command below to get stats. As it can be seen, we also used Mammalia lineage file stored locally, which is indicated by `-l` and `--offline` flags. We used local lineage because it was impossible to connect to the BUSCO's directly at the moment.
```
busco -i protein.faa -l busco_downloads/lineages/mammalia_odb10/ -o speciesres/ -m protein --offline -c
```
Busco results can be found in the table below. Total number of BUSCO orthologs is 9226
| | Name | Complete, % | S, % | D, % | F, % | M, % |
|---|---------|------------------|---------------|------------|------------|-------------------|
|1|_Choloepus hoffmanni_ | 78.8 | 76.6 | 2.2 | 9.1 | 12.1 |
|2|_Chrysochloris asiatica_ | 98 | 83.3 | 14.7 | 1.1 | 0.9 |
|3|_Dasypus novemcinctus_ | 91 | 58.7 | 32.3 | 4.5 | 4.5 |
|4|_Echinops telfairi_ | 92.7 | 81.3 | 11.4| 3.6 | 3.7 |
|5|_Elephantulus edwardii_ | 96.3 | 82.1 | 14.2 | 1.2 | 2.5 |
|6|_Elephas maximus_ | 76.3 | 75.8 | 0.5 | 10.7 | 13.0 |
|7|_Loxodonta africana_ |94.9 |59.3 | 35.6 | 2.6 | 2.5 |
|8|_Orycteropus afer_ | 74.2 | 73.8 | 0.4 | 10.7 | 15.1 |
|9|_Procavia capensis_ | 69.4 | 69.0 | 0.4 | 10.2 | 20.4 |
|10|_Trichechus manatus latirostris_ | 77.2 | 76.8 | 0.4 | 9.8 | 13.0 |




This figure shows box plots with single copy orthologs by BUSCO for each genome and duplicated orthologs by BUSCO for each genome. As it can be seen, only two genomes have more than 1500 duplicated orthologs. 
![Complete orthologs by BUSCO for each genome](https://github.com/bi-LVYproject-2023/vazquez_2021/blob/main/figures/busco.jpg)

This figure illustrates that there is no relationship between the number of duplicated orthologs and degree of genome fragmentation.
![Relationship between fragmentation of genome and number of duplicated orthologs](https://github.com/bi-LVYproject-2023/vazquez_2021/blob/main/figures/scatter_plot.jpg)
### Explore the functional enrichment of the potential duplicate
Unfortunately, there was no completion of this step in time.
