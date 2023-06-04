#!/usr/bin

blat -t=prot -q=prot -out=blast8 ../data/genomes/annotations/mamColU_proteins.fasta 
../data/filtered_human_proteins_hg38.fasta ../data/blat/mammoth/blat_mamcol_hg38.psl
blat -t=prot -q=prot -out=blast8 ../data/filtered_human_proteins_hg38.fasta 
../data/genomes/annotations/mamColU_proteins.fasta 
../data/blat/mammoth/blat_hg38_mamcol.psl

sort -k2,2 -k3,3nr ../data/blat/mammoth/blat_mamcol_hg38.psl > 
../data/blat/mammoth/blat_mamcol_hg38_sorted.psl
sort -k2,2 -k3,3nr ../data/blat/mammoth/blat_hg38_mamcol.psl > 
../data/blat/mammoth/blat_hg38_mamcol_sorted.psl
	
awk 'BEGIN { OFS="\t"; prev2="" } {         
    if ($2 != prev2) {
        print $0; prev2=$2
    } else if ($3 > prev3 && $(NF-1) < prev11) {
        print $0; prev3=$3; prev11=$(NF-1)
    }
}' ../data/blat/mammoth/blat_mamcol_hg38_sorted.psl > 
../data/blat/mammoth/blat_mamcol_hg38_filtered.psl
	
awk 'BEGIN { OFS="\t"; prev2="" } {         
    if ($2 != prev2) {
        print $0; prev2=$2
    } else if ($3 > prev3 && $(NF-1) < prev11) {
        print $0; prev3=$3; prev11=$(NF-1)
    }
}' ../data/blat/mammoth/blat_hg38_mamcol_sorted.psl > 
../data/blat/mammoth/blat_hg38_mamcol_filtered.psl


