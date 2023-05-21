#!/bin/bash

declare -A mbf=([loxCycF]=30 [mamAmeI]=37 [mamColU]=37 [mamPriV]=37 [palAntN]=37)
declare -A mito=([loxCycF]=loxAfr4loxCycChrM [mamAmeI]=loxAfr4chrM [mamColU]=loxAfr4chrM [mamPriV]=loxAfr4chrM [palAntN]=loxAfr4chrM)

mkdir 02_fq

for f in 01_bam_bai/*.bam 
do
    F_BASE=$(basename $f .bam)
    QI=${mbf[$F_BASE]}
    REFMITO=${mito[$F_BASE]}
    echo "Started $F_BASE with $QI on reference $REFMITO"

    samtools mpileup -q $QI -Q 30 -uf reference/$REFMITO.fasta $f | bcftools call -c | vcfutils.pl 
vcf2fq -d 3 -Q 30 -l 5 > 02_fq/$F_BASE.fq

    echo "I'm done with it"
done
