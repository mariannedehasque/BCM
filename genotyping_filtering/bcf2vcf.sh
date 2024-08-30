#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 1-00:00:00
#SBATCH -J bcf2vcf

#Load modules
module load bioinfo-tools bcftools/1.14
module load tabix


DIR="/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data" #output directory
MERGED_BCF="BCM_high_coverage" #Name of the final merged BCF file

bcftools convert $DIR/${MERGED_BCF}.Fmiss0.bcf -Oz -o $DIR/${MERGED_BCF}.Fmiss0.vcf.gz --threads 4
tabix -p vcf $DIR/${MERGED_BCF}.Fmiss0.vcf.gz
