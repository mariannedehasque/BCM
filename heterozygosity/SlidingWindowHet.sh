#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=SlidingWindowHet
#SBATCH --partition=shared
#SBATCH --cpus-per-task=2
#SBATCH --time=02:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load pysam/0.17.0-python3.9.5

#To run the script:
#for chrom in chr1 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr2 chr20 chr21 chr22 chr23 chr24 chr25 chr26 chr27 chr3 chr4 chr5 chr6 chr7 chr8 chr9 ;do sbatch SlidingWindowHet.sh $chrom;done
#for chrom in NC_064819.1 NC_064820.1 NC_064821.1 NC_064822.1 NC_064823.1 NC_064824.1 NC_064825.1 NC_064826.1 NC_064827.1 NC_064828.1 NC_064829.1 NC_064830.1 NC_064831.1 NC_064832.1 NC_064833.1 NC_064834.1 NC_064835.1 NC_064836.1 NC_064837.1 NC_064838.1 NC_064839.1 NC_064840.1 NC_064841.1 NC_064842.1 NC_064843.1 NC_064844.1 NC_064845.1; do sbatch SlidingWindowHet.sh $chrom;done

SCRIPT="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/heterozygosity/SlidingWindowHet.py"
INPUTFILE="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BCF/BCM_high_coverage_EleMax.Fmiss0.vcf.gz"
OUTDIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/heterozygosity/slidingWindow"
OUTNAME="BCM_high_coverage_EleMax.Fmiss0"

CHROM=$1

cd $OUTDIR

python $SCRIPT $INPUTFILE 1000000 1000000 $CHROM $OUTNAME
