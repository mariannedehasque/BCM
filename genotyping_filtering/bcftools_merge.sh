#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=merge
#SBATCH --partition=shared
#SBATCH --cpus-per-task=24
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#Load modules
module load bioinfo-tools bcftools/1.20

DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BCF" #output directory
files_to_merge="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/bcftools_merge_files.txt" #File containing absolute path of all files to merge. One file per line.
MERGED_BCF="BCM_high_coverage_EleMax" #Name of the final merged BCF file

#Merge bcf files into one bcf file, allowing multiallelic SNP records
cat $files_to_merge | xargs bcftools merge -m snps --threads 24 -Ob -o $DIR/${MERGED_BCF}.bcf
bcftools index $DIR/${MERGED_BCF}.bcf
