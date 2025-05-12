#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=samtools_reheader
#SBATCH --partition=shared
#SBATCH --cpus-per-task=24
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#Load modules
module load bioinfo-tools samtools/1.20

DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BAM_DS"
NAME=$1
INFILE="Mammuthus-${NAME}-D8.bam"
OUTFILE="Mammuthus-${NAME}-D8.RG.bam"

cd $DIR

# Extract header
samtools view -H ${INFILE} > ${NAME}.header.txt

# Fix SM: fields in @RG lines only
sed -i "/^@RG/s/SM:[^ \t]*/SM:${NAME}/" ${NAME}.header.txt

# Apply new header
samtools reheader ${NAME}.header.txt $INFILE > $OUTFILE
samtools index $OUTFILE

