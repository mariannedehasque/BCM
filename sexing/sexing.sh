#!/bin/bash -l
#SBATCH -A uppmax2025-2-133
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 2:00:00
#SBATCH -J sexing

module load bioinfo-tools
module load samtools/1.20

INDIR="/proj/sllstore2017093/mammoth/marianne/snakemake_v2.3.1_BCM/results/historical/mapping"
OUTDIR="/proj/sllstore2017093/mammoth/marianne/GIT/data_BCM"

#samtools view -bhq 30 $INDIR/${1}.merged.rmdup.merged.realn.bam chrX > $TMPDIR/${1}.merged.rmdup.merged.realn.chrX.Q30.bam
#samtools index $TMPDIR/${1}.merged.rmdup.merged.realn.chrX.Q30.bam
#samtools idxstats $TMPDIR/${1}.merged.rmdup.merged.realn.chrX.Q30.bam > $OUTDIR/${1}.merged.rmdup.merged.realn.chrX.Q30.idxstats

samtools view -bhq 30 $INDIR/${1}.merged.rmdup.merged.realn.bam chr8 > $TMPDIR/${1}.merged.rmdup.merged.realn.chr8.Q30.bam
samtools index $TMPDIR/${1}.merged.rmdup.merged.realn.chr8.Q30.bam
samtools idxstats $TMPDIR/${1}.merged.rmdup.merged.realn.chr8.Q30.bam > $OUTDIR/${1}.merged.rmdup.merged.realn.chr8.Q30.idxstats

samtools view -bhq 30 $INDIR/${1}.merged.rmdup.merged.realn.bam > $TMPDIR/${1}.merged.rmdup.merged.realn.Q30.bam
samtools index $TMPDIR/${1}.merged.rmdup.merged.realn.Q30.bam
samtools idxstats $TMPDIR/${1}.merged.rmdup.merged.realn.Q30.bam > $OUTDIR/${1}.merged.rmdup.merged.realn.Q30.idxstats