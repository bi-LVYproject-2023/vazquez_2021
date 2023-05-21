#!/bin/bash

mkdir -p 01_bam_bai
cd 01_bam_bai
wget -i ../genomes_bam_links.txt
mv F-SL0001__aka_Lcy-SL0001__R1_dedup_2_ReadGroups.bam loxCycF.bam
mv F-SL0001__aka_Lcy-SL0001__R1_dedup_2_ReadGroups.bam.bai loxCycF.bam.bai
mv I-IK_99_237_merged_ReadGroups.bam mamAmeI.bam
mv I-IK_99_237_merged_ReadGroups.bam.bai mamAmeI.bam.bai
mv U-Rawlins_ReadGroups.bam mamColU.bam
mv U-Rawlins_ReadGroups.bam.bai mamColU.bam.bai
mv V-UW20579_ReadGroups.bam mamPriV.bam                                        
mv V-UW20579_ReadGroups.bam.bai mamPriV.bam.bai
mv N-NEPECV_merged.rmdupse.RG.bam palAntN.bam
mv N-NEPECV_merged.rmdupse.RG.bam.bai palAntN.bam.bai

cd ..
