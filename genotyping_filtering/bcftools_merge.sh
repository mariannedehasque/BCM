#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 2-00:00:00
#SBATCH -J bcftools_merge

#Load modules
module load bioinfo-tools bcftools/1.14 samtools/1.14
module load BEDTools/2.29.2
module load tabix/0.2.6

DIR="/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data" #output directory
files_to_merge="/proj/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/bcftools_merge_files.txt" #File containing absolute path of all files to merge. One file per line.
MERGED_BCF="BCM_high_coverage" #Name of the final merged BCF file

#Merge bcf files into one bcf file, allowing multiallelic SNP records
cat $files_to_merge | xargs bcftools merge -m snps --threads 8 -Ob -o $DIR/${MERGED_BCF}.bcf
bcftools index $DIR/${MERGED_BCF}.bcf
