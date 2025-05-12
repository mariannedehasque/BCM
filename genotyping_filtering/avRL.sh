#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=avRL
#SBATCH --partition=shared
#SBATCH --cpus-per-task=4
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools samtools/1.20

INPUT_BAM=$1
FILE=$(basename $INPUT_BAM)
NAME=$(echo $FILE | cut -d "." -f1)

bed='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/references/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.ElephantPart.repma.noCpG_ref.bed'
outdir='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM'


samtools view -h -q 25 $INPUT_BAM	| grep -v '@' | awk '{print length($10)}'|  awk '{ total += $1; count++ } END { print total/count }' > $outdir/$NAME.avRL.Q25.txt
