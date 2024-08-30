#!/bin/bash -l
#SBATCH -A naiss2024-22-851 -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 1-00:00:00
#SBATCH -J slidngwindowhet

module load bioinfo-tools
module load pysam/0.17.0-python3.9.5

#To run the script:
#for chrom in chr1 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr2 chr20 chr21 chr22 chr23 chr24 chr25 chr26 chr27 chr3 chr4 chr5 chr6 chr7 chr8 chr9 ;do sbatch SlidingWindowHet.sh $chrom;done

SCRIPT="/proj/sllstore2017093/mammoth/marianne/GIT/BCM/heterozygosity/SlidingWindowHet.py"
INPUTFILE="/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data/BCM_high_coverage.Fmiss0.vcf.gz"
OUTDIR="/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data/heterozygosity"
OUTNAME="BCM_high_coverage.Fmiss0"

CHROM=$1

cd $OUTDIR

python $SCRIPT $INPUTFILE 1000000 1000000 $CHROM $OUTDIR $OUTNAME
