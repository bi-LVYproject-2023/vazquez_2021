# Bioinformatics Institue spring project.

In this repository we are reproducing an article, which can be found by this [link](https://elifesciences.org/articles/65041 "The reproduced article").
Vazquez, J. M., & Lynch, V. J. (2021). Pervasive duplication of tumor suppressors in Afrotherians during the evolution of large bodies and reduced cancer risk. Elife, 10, e65041.

## Students 

1. Igamberdiev Lev, 2nd year of Bachelor degree, [MIPT](https://mipt.ru/ "Moscow institute of physics and technologies").

2. Valeria Lobanova.
3. Anastasiia Bukreeva

## Curators

1. Yuriy Malovichko, LOEWE Centre for Translational Biodiversity Genomics, Germany.


# WORKING PIPELINE

## DOWNLOAD GENOMES

List of genomes, resources for downloading and commentaries:
https://docs.google.com/spreadsheets/d/126XjvKZmN4m7YIQQ7hjx4LKbH4Wdca3y9o761Nd-VMI/edit#gid=0  

**15** full genomes of Afrotheria were needed.
**10** genomes were allowed for downloading.
**5** genomes were introduced only as bam files.

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

We annotated one of the reconstructed ancient genomes, the genome of Mammuthus columbi, with Augustus:

	augustus --strand=both --singlestrand=true --alternatives-from-evidence=true --gff3=on --uniqueGeneId=True --genemodel=complete --species=human data/genomes/mamColU.fasta > data/genomes/annotations/mamColU.gff

Some stats were obtaining using next commands:

Chromosome count: 171

	cat data/genomes/annotations/mamColU.gff | awk '$1 ~ /^chr/ {print $1}' | uniq | wc -l

Proteins sequences count: 11552

	cat data/genomes/annotations/mamColU.gff | grep "protein sequence" | wc -l

CDS count: 69431

	cat data/genomes/annotations/mamColU.gff | grep "CDS" | wc -l


## FILTERING HUMAN PROTEINS FOR RBH BLAT

We downloaded human proteins hg38 assembly version from all available components (chromosomes) except unplaced from UniProt:
https://www.uniprot.org/proteomes/UP000005640

Then we filtered out proteins as it was noted in the original article:
https://colab.research.google.com/drive/1vkKK-bDu3C5pw5PmG8G5N_xI4JGd6PAL?usp=sharing 

Details about filtered categories, regular expressions and so on could be found at Google Sheets:
https://docs.google.com/spreadsheets/d/126XjvKZmN4m7YIQQ7hjx4LKbH4Wdca3y9o761Nd-VMI/edit#gid=791643136 

## RECIPROCAL BEST HIT BLAT

For Mammuthus columbi genome we did Reciprocal Best Hit BLAT versus filtered human proteins from hg38 assembly version.