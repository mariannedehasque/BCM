#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 04:00:00
#SBATCH -J MIA

DIR="/proj/sllstore2017093/mammoth/marianne/snakemake_v2.3.1_BCM_MIA/results/historical/trimmed_merged_reads"
SAMPLE=$1

cd $DIR

cat ${SAMPLE}*.fastq.gz > ${SAMPLE}_trimmed_merged.fastq.gz
