#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 02:00:00
#SBATCH -J bcftools_missing

#Load modules
module load bioinfo-tools bcftools/1.14

DIR="/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data" #output directory
files_to_merge="/proj/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/bcftools_merge_files.txt" #File containing absolute path of all files to merge. One file per line.
MERGED_BCF="BCM_high_coverage" #Name of the final merged BCF file

#Remove sites with missing sites
bcftools view -i 'F_MISSING=0' $DIR/${MERGED_BCF}.bcf -Ob -o $DIR/${MERGED_BCF}.Fmiss0.bcf
bcftools index $DIR/${MERGED_BCF}.Fmiss0.bcf
