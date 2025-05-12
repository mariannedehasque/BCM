#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=depth
#SBATCH --partition=shared
#SBATCH --cpus-per-task=48
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools samtools/1.20

INPUT_BAM=$1
FILE=$(basename $INPUT_BAM)
NAME=$(echo $FILE | cut -d "." -f1)

bed='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/references/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.ElephantPart.repma.noCpG_ref.bed'
outdir='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM'

samtools depth -a -Q 30 -q 25 -b $bed $INPUT_BAM > $TMPDIR/${NAME}.Q25.bam.dp
awk '{{sum+=$3}} END {{ print sum/NR }}' $TMPDIR/${NAME}.Q25.bam.dp > $outdir/${NAME}.Q25.bam.dpstats.txt
