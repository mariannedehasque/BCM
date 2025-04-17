#!/bin/bash -le

#SBATCH -A naiss2024-5-54
#SBATCH --job-name=prune_VCF
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load plink/1.90b4.9
module load bcftools/1.20

DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo

cd $DIR

#Dstat dataset
FILE=BCM.SampleID.snps.NewChr.X.Dsuite
plink --vcf ${DIR}/${FILE}.vcf.gz --make-bed --allow-extra-chr --chr X --set-missing-var-ids @:# --out ${FILE}
plink --bfile ${DIR}/${FILE} --missing-genotype 0 --allow-extra-chr --chr X --indep-pairwise 50 5 0.5 --out ${DIR}/${FILE}
plink --bfile ${DIR}/${FILE} --extract ${DIR}/${FILE}.prune.in --make-bed --allow-extra-chr --chr X --out ${DIR}/${FILE}.LDprune
plink --bfile ${DIR}/${FILE}.LDprune --recode vcf --allow-extra-chr --keep-allele-order --chr X --missing-genotype 0 --out $DIR/$FILE

FILE=BCM.SampleID.snps.NewChr.autos.Dsuite
plink --vcf ${DIR}/${FILE}.vcf.gz --make-bed --allow-extra-chr --chr-set 27 --set-missing-var-ids @:# --out ${FILE}
plink --bfile ${DIR}/${FILE} --missing-genotype 0 --allow-extra-chr --chr-set 27 --indep-pairwise 50 5 0.5 --out ${DIR}/${FILE}
plink --bfile ${DIR}/${FILE} --extract ${DIR}/${FILE}.prune.in --make-bed --chr-set 27 --allow-extra-chr --out ${DIR}/${FILE}.LDprune
plink --bfile ${DIR}/${FILE}.LDprune --recode vcf --allow-extra-chr --chr-set 27 -keep-allele-order --missing-genotype 0 --out $DIR/$FILE

FILE=BCM.SampleID.snps.NewChr.autos.Orient
plink --vcf ${DIR}/${FILE}.vcf.gz --make-bed --allow-extra-chr --chr-set 27 --set-missing-var-ids @:# --out ${FILE}
plink --bfile ${DIR}/${FILE} --missing-genotype 0 --allow-extra-chr --chr-set 27 --indep-pairwise 50 5 0.5 --out ${DIR}/${FILE}
plink --bfile ${DIR}/${FILE} --extract ${DIR}/${FILE}.prune.in --make-bed --chr-set 27 --allow-extra-chr --out ${DIR}/${FILE}.LDprune
plink --bfile ${DIR}/${FILE}.LDprune --recode vcf --allow-extra-chr --chr-set 27 -keep-allele-order --missing-genotype 0 --out $DIR/$FILE
