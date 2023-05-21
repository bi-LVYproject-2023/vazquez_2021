#!/bin/bash
source /etc/profile.d/conda.sh
mamba activate sra_tools
fastq-dump --gzip --split-spot SRR6307198 -v
fastq-dump --gzip --split-spot SRR1041765 -v
fastq-dump --gzip --split-spot SRR6307199 -v
fastq-dump --gzip --split-spot SRR6307201 -v
fastq-dump --gzip --split-spot SRR6307196 -v
fastq-dump --gzip --split-spot SRR6307202 -v
fastq-dump --gzip --split-spot SRR6307200 -v
fastq-dump --gzip --split-spot SRR6307195 -v
fastq-dump --gzip --split-spot SRR975188 -v
fastq-dump --gzip --split-spot SRR6307194 -v
fastq-dump --gzip --split-spot SRR6307204 -v
fastq-dump --gzip --split-spot SRR3222430 -v
fastq-dump --gzip --split-spot SRR6307205 -v
fastq-dump --gzip --split-spot SRR975189 -v
fastq-dump --gzip --split-spot SRR6307197 -v
fastq-dump --gzip --split-spot SRR6307203 -v
mamba activate ngs_base
mkdir fastqc_reports
fastqc -t 5 -o fastqc_reports *.fastq.gz
cd pipline
list=$(ls SRR*)
for l in $list
do
hisat2 -p 12 -x ../L_africana_index -U $l | samtools sort > $l.out.bam
done
samtools index -M ../L.africana/pipeline/*.out.bam
samtools merge -X merge.out.bam *.out.bam *.out.bam.bai
stringtie -o output_merge_gtf_L.africana.gtf merge.out.bam
awk -F'\t' '{ if ($3 == "transcript"){split($9, gtfdata,"; "); split(gtfdata[5], tpm, " "); gsub("\"|;", "", tpm[2]); if (tpm[2]>=2){print $0} } }' output_merge_gtf_L.africana.gtf > output_merge_gtf_L.africana_filtered.gtf
awk -F'\t' 'BEGIN{OFS="\t"}{print $1,$4,$5,$9,$6,$7}' output_merge_gtf_L.africana_filtered.gtf > output_merge_bed_L.africana.bed
bedtools intersect -F 0.7 -f 0.7 -wa -a GCF_000001905.1_Loxafr3.0_genomic_filter.bed  -b output_merge_bed_L.africana.bed | sort -u > result_L.africana.bed
