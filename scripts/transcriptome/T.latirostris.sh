#!/bin/bash
source /etc/profile.d/conda.sh
mamba activate sra_tools
fastq-dump --gzip --split-spot SRR4228542 -v
fastq-dump --gzip --split-spot SRR4228545 -v
fastq-dump --gzip --split-spot SRR4228544 -v
fastq-dump --gzip --split-spot SRR4228539 -v
fastq-dump --gzip --split-spot SRR4228541 -v
fastq-dump --gzip --split-spot SRR4228538 -v
fastq-dump --gzip --split-spot SRR4228546 -v
fastq-dump --gzip --split-spot SRR4228537 -v
fastq-dump --gzip --split-spot SRR4228540 -v
fastq-dump --gzip --split-spot SRR4228543 -v
fastq-dump --gzip --split-spot SRR4228547 -v
mkdir fastqc_reports
mamba activate ngs_base
fastqc -t 5 -o fastqc_reports *.fastq.gz
cd pipline
list=$(ls SRR*)
for l in $list
do
hisat2 -p 12 -x /home/bukreeva/IB/T.latirostris/index/genome_index_Latirostris -U $l | samtools sort > $l.out.bam
done
samtools index -M /home/bukreeva/IB/T.latirostris/pipline/*.out.bam
samtools merge -X merge.out.bam *.out.bam *.out.bam.bai
stringtie -o output_merge_gtf_T.latirostris.gtf merge.out.bam
awk -F'\t' '{ if ($3 == "transcript"){split($9, gtfdata,"; "); split(gtfdata[5], tpm, " "); gsub("\"|;", "", tpm[2]); if (tpm[2]>=2){print $0} } }' output_merge_gtf_T.latirostris.gtf > output_merge_gtf_T.latirostris_filtered.gtf
awk -F'\t' 'BEGIN{OFS="\t"}{split($9, a, ";"); gsub("ID=", "", a[1]); print $1,$4,$5,a[1],$6,$7}' /home/bukreeva/IB/T.latirostris/TriManLat1.0_HiC.fasta_v2.functional_filtered.gff3 > TriManLat1.0_HiC.fasta_v2.functional_filtered.bed
awk -F'\t' 'BEGIN{OFS="\t"}{print $1,$4,$5,$9,$6,$7}' output_merge_gtf_T.latirostris_filtered.gtf > output_merge_gtf_T.latirostris_final_filtered.bed
bedtools intersect -F 0.7 -f 0.7 -wa -a output_merge_gtf_T.latirostris_final_filtered.bed  -b TriManLat1.0_HiC.fasta_v2.functional_filtered.bed | sort -u > result_T.latirostris_f.bed
