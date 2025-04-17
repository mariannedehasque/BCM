#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=filter_missing
#SBATCH --partition=shared
#SBATCH --cpus-per-task=24
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#Load modules
module load bioinfo-tools bcftools/1.20
module load tabix/0.2.6

DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BCF" #output directory
files_to_merge="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/bcftools_merge_files.txt" #File containing absolute path of all files to merge. One file per line.
MERGED_BCF="BCM_high_coverage_EleMax" #Name of the final merged BCF file

#Remove sites with missing sites
bcftools view -i 'F_MISSING=0' $DIR/${MERGED_BCF}.bcf -Ob -o $DIR/${MERGED_BCF}.Fmiss0.bcf
bcftools index $DIR/${MERGED_BCF}.Fmiss0.bcf

bcftools convert -O z -o $DIR/${MERGED_BCF}.Fmiss0.vcf.gz $DIR/${MERGED_BCF}.Fmiss0.bcf
tabix $DIR/${MERGED_BCF}.Fmiss0.vcf.gz
