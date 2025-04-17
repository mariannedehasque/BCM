#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=filter_vcf
#SBATCH --partition=shared
#SBATCH --cpus-per-task=8
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load bcftools/1.20
module load tabix/0.2.6

DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo
FILE=BCM.SampleID
autos=$(seq -s, 1 27)
DSUITE="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/DSUITE_list.txt"
ORIENT="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/ORIENT_list.txt"


#Biallelic SNPS only
bcftools view -m2 -M2 -v snps $DIR/${FILE}.vcf -Oz -o $DIR/${FILE}.snps.vcf.gz
tabix $DIR/${FILE}.snps.vcf.gz

#Change name of chromosomes from NC.... to 1 2 3
bcftools view $DIR/${FILE}.snps.vcf.gz | awk '{gsub(/NC_064819.1/, "1"); gsub(/NC_064820.1/, "2"); gsub(/NC_064821.1/, "3"); gsub(/NC_064822.1/, "4"); gsub(/NC_064823.1/, "5"); gsub(/NC_064824.1/, "6"); gsub(/NC_064825.1/, "7"); gsub(/NC_064826.1/, "8"); gsub(/NC_064827.1/, "9"); gsub(/NC_064828.1/, "10"); gsub(/NC_064829.1/, "11"); gsub(/NC_064830.1/, "12"); gsub(/NC_064831.1/, "13"); gsub(/NC_064832.1/, "14"); gsub(/NC_064833.1/, "15"); gsub(/NC_064834.1/, "16"); gsub(/NC_064835.1/, "17"); gsub(/NC_064836.1/, "18"); gsub(/NC_064837.1/, "19"); gsub(/NC_064838.1/, "20"); gsub(/NC_064839.1/, "21"); gsub(/NC_064840.1/, "22"); gsub(/NC_064841.1/, "23"); gsub(/NC_064842.1/, "24"); gsub(/NC_064843.1/, "25"); gsub(/NC_064844.1/, "26");gsub(/NC_064845.1/, "27"); gsub(/NC_064846.1/, "X"); print;}' | bgzip -c > $DIR/${FILE}.snps.NewChr.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.vcf.gz

#Extract autosomes
bcftools view $DIR/${FILE}.snps.NewChr.vcf.gz -r $autos -Oz -o $DIR/${FILE}.snps.NewChr.autos.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.autos.vcf.gz

#Extract chrX
bcftools view $DIR/${FILE}.snps.NewChr.vcf.gz -r X -Oz -o $DIR/${FILE}.snps.NewChr.X.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.X.vcf.gz

#DSUITE dataset
bcftools view -S $DSUITE -Oz -o $DIR/${FILE}.snps.NewChr.autos.Dsuite.vcf.gz $DIR/${FILE}.snps.NewChr.autos.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.autos.Dsuite.vcf.gz
bcftools view -S $DSUITE -Oz -o $DIR/${FILE}.snps.NewChr.X.Dsuite.vcf.gz $DIR/${FILE}.snps.NewChr.X.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.X.Dsuite.vcf.gz

#ORIENT dataset
bcftools view -S $ORIENT -Oz -o $DIR/${FILE}.snps.NewChr.autos.Orient.vcf.gz $DIR/${FILE}.snps.NewChr.autos.vcf.gz
tabix $DIR/${FILE}.snps.NewChr.autos.Orient.vcf.gz