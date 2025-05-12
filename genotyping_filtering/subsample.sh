#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=subsample
#SBATCH --partition=shared
#SBATCH --cpus-per-task=72
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#while read line; do sbatch subsample.sh $line; done < /cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/fraq.txt

module load bioinfo-tools samtools/1.20

INPUT_BAM=$1
fraq=$2
FILE=$(basename $INPUT_BAM)
NAME=$(echo $FILE | cut -d "." -f1)

outdir='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM'

samtools view -h -b -q 25 -o ${TMPDIR}/${NAME}.Q25.bam $INPUT_BAM
samtools index ${TMPDIR}/${NAME}.Q25.bam

samtools view -h -b -s $fraq -o $outdir/${NAME}${fraq}.bam ${TMPDIR}/${NAME}.Q25.bam
samtools index $outdir/${NAME}${fraq}.bam