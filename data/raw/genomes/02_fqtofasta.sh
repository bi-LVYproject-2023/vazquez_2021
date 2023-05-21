#!/bin/bash

mkdir -p ../../genomes/

for f in 02_fq/*.fq
do
    F_BASE=$(basename $f .bam)
    seqkit fq2fa $f -o ../../genomes/$F_BASE.fasta
done



