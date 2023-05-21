#!/bin/bash

mkdir -p ../data/genomes
cd ../data/genomes/
wget -i ../../scripts/genomes_fasta_links.txt
gunzip C_hoffmanni-2.0.1_HiC.fasta.gz > choHof2.fasta
gunzip Elephas_maximus_HiC.fasta.gz > eleMax.fasta
gunzip OryAfe1.0_HiC.fasta.gz > OryAfe1.fasta
gunzip Pcap_2.0_HiC.fasta.gz > proCap2.fasta
gunzip TriManLat1.0_HiC.fasta.gz > triManLat1.fasta
gunzip Chromosomes.v2.fasta.gz > loxAfr4.fasta

