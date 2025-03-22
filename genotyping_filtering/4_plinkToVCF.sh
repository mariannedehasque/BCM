#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=plinkToVCF
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load plink/1.90b4.9

DIR='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo'
FILE="BCM"

cd $DIR

#Concatenate all chromosomes
bash -c 'for file in BCM.NC_*.tped; do cat "$file"; done > BCM.tped'
cp BCM.NC_064845.1.tfam BCM.tfam

#No Ns in data
sed 's/N N/0 0/g' BCM.tped > BCM.noN.tped
cp BCM.tfam BCM.noN.tfam

#Change variant names to something more sensible
awk '{ $2 = $1 ":" $4; print }' BCM.noN.tped > BCM.noN.updateVarID.tped
cp BCM.noN.tfam BCM.noN.updateVarID.tfam

#Plink to VCF
plink --tfile $DIR/BCM.noN.updateVarID --recode vcf --allow-extra-chr --keep-allele-order --missing-genotype 0 --out $DIR/$FILE


