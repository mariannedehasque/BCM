#!/bin/bash -le

#SBATCH -A naiss2024-5-54
#SBATCH --job-name=split_VCF
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load bcftools/1.20

DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/Dsuite

for chrom in {1..27}
do
  bcftools view $DIR/BCM.SampleID.snps.NewChr.autos.Dsuite.vcf.gz -r $chrom -Ov -o $DIR/BCM.SampleID.snps.NewChr.autos.Dsuite.${chrom}.vcf.gz
done