#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=Dtrios
#SBATCH --partition=shared
#SBATCH --cpus-per-task=12
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

chrom=$1

Dsuite="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/Dsuite/Build/Dsuite"
VCF=BCM.SampleID.snps.NewChr.autos.Dsuite.${chrom}.vcf.gz
POP=popfile.txt
DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/Dsuite

cd $DIR

$Dsuite Dtrios $VCF $POP -o BCM.${chrom}