#!/usr/bin

augustus --strand=both --singlestrand=true --alternatives-from-evidence=true --gff3=on 
--uniqueGeneId=True --genemodel=complete --species=human ../data/genomes/mamColU.fasta > 
../data/genomes/annotations/mamColU.gff

echo "Chromosome count:"
cat ../data/genomes/annotations/mamColU.gff | awk '$1 ~ /^chr/ {print $1}' | uniq | wc 
-l

echo "Proteins sequences count:"
cat ../data/genomes/annotations/mamColU.gff | grep "protein sequence" | wc -l

echo "CDS count:"
cat ../data/genomes/annotations/mamColU.gff | grep "CDS" | wc -l
