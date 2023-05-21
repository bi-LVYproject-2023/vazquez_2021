# Ancient genomes assembly

Ancient genomes assembly was based on the original article and its Supplementary materials:
https://doi.org/10.1073/pnas.1720554115

Main working directory:

*data/raw/genomes/*

Download alignments:

	./download_genomes_bam.sh

Download reference:

	mkdir reference
	wget ftp://ftp.broadinstitute.org:21/pub/assemblies/mammals/elephant/loxAfr4/Chromosomes.v2.fasta.gz -P reference/
	mv reference/Chromosomes.v2.fasta.gz reference/loxAfr4.fasta.gz

Also for alignment on the reference genome we need to add a mitochondrial chromosome to our reference. For mammoths and Palaeoloxodon we used the available mitogenome of Mammuthus primigenius:
https://www.ncbi.nlm.nih.gov/nuccore/DQ188829 

For modern Loxodonta cyclotis we used its own mitochondria:
https://www.ncbi.nlm.nih.gov/nucleotide/NC_020759.1 

Download FASTA files of two mitogenomes from links above to *reference/*.

Then find the ID of mitochondrial chromosome in your bam files:

	for f in 01_bam_bai/*.bam; do samtools view $f | cut -f 3 | uniq > $f.chrid.txt; done

Replace the ID in downloaded mammoth’s and elephant’s mitochondria FASTA on ID from bam files.

Merge reference genome FASTA with mitochondria files:

	cat reference/loxAfr4.fasta reference/mamPriChrM.fasta > reference/loxAfr4chrM.fasta
	cat reference/loxAfr4.fasta reference/loxCycChrM.fasta > reference/loxAfr4loxCycChrM.fasta


Create conda environment and install necessary tools:

	conda create -n bi_project
	conda activate bi_project
	conda install -c bioconda samtools bwa bcftools seqkit

Index reference genomes:

	bwa index reference/loxAfr4chrM.fasta
	bwa index reference/loxAfr4loxCycChrM.fasta

To obtain polymorphisms and create FASTQ we used samtools mpileup, bcftools and vcfutils.pl. As noted in Palkopoulou, 2018, we set different parameters for ancient and modern genomes. To run the pipeline, execute shell script:

	./01_bamtofq.sh

Convert .fq to .fasta with seqkit:

	./02_fqtofasta.sh
