#!/bin/bash
source /etc/profile.d/conda.sh
fastq-dump --gzip SRR494779 -v
fastq-dump --gzip SRR494767 -v
fastq-dump --gzip SRR494780 -v
fastq-dump --gzip SRR494770 -v
fastq-dump --gzip SRR309130 -v
fastq-dump --gzip SRR4043756 -v
fastq-dump --gzip SRR494776 -v
fastq-dump --gzip SRR494778 -v
fastq-dump --gzip SRR4043762 -v
fastq-dump --gzip SRR4043755 -v
fastq-dump --gzip SRR6206923 -v
fastq-dump --gzip SRR4043761 -v
fastq-dump --gzip SRR4043760 -v
fastq-dump --gzip SRR6206913 -v
fastq-dump --gzip SRR4043763 -v
fastq-dump --gzip SRR494774 -v
fastq-dump --gzip SRR4043754 -v
fastq-dump --gzip SRR4043758 -v
mkdir fastqc_reports
fastqc -t 5 -o fastqc_reports *.fastq.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/208/655/GCF_000208655.3_Dasnov3.2/GCF_000208655.3_Dasnov3.2_genomic.fna.gz
gunzip GCF_000208655.3_Dasnov3.2_genomic.fna.gz
hisat2-build -p 12 GCF_000208655.3_Dasnov3.2_genomic.fna D_novemcinctus_index
list=$(ls SRR*)
for l in $list
do
hisat2 -p 12 -x ../D_novemcinctus_index -U $l | samtools sort > $l.out.bam
samtools index -M ../D.novemcinctus/pipeline/*.out.bam
samtools merge -X merge_bam.out.bam *.out.bam *.out.bam.bai
stringtie -o output_merge_gtf_D.novemcinctus.gtf merge_bam.out.bam
awk -F'\t' '{ if ($3 == "transcript"){split($9, gtfdata,"; "); split(gtfdata[5], tpm, " "); gsub("\"|;", "", tpm[2]); if (tpm[2]>=2){print $0} } }' output_merge_gtf_D.novemcinctus.gtf > output_merge_gtf_D.novemcinctus_filtered.gtf
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/208/655/GCF_000208655.3_Dasnov3.2/GCF_000208655.3_Dasnov3.2_genomic.gff.gz
gunzip GCF_000208655.3_Dasnov3.2_genomic.gff.gz
awk '$3 == "mRNA"' GCF_000208655.3_Dasnov3.2_genomic.gff > GCF_000208655.3_Dasnov3.2_genomic_filter.gff
bedtools intersect -F 0.7 -f 0.7 -wa GCF_000208655.3_Dasnov3.2_genomic_filter.gff -b output_merge_gtf_D.novemcinctus_filtered.gtf > result_D.novemcinctus.gtf
awk -F'\t' 'BEGIN{OFS="\t"}{split($9, a, ";"); gsub("ID=", "", a[1]); print $1,$4,$5,a[1],$6,$7}'  GCF_000208655.3_Dasnov3.2_genomic_filter.gff > GCF_000208655.3_Dasnov3.2_genomic_filter.bed
awk -F'\t' 'BEGIN{OFS="\t"}{print $1,$4,$5,$9,$6,$7}' output_merge_gtf_D.novemcinctus_filtered.gtf > output_merge_D.novemcinctus_filtered.bed
bedtools intersect -F 0.7 -f 0.7 -wa -a GCF_000208655.3_Dasnov3.2_genomic_filter.bed -b output_merge_D.novemcinctus_filtered.bed | sort -u > result_D.novemcinctus.bed
