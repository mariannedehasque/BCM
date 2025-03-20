#!/bin/bash -le

#SBATCH -A naiss2024-5-54
#SBATCH --job-name=ANGSD_haploToPlink
#SBATCH --partition=shared
#SBATCH --cpus-per-task=3
#SBATCH --time=08:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#for chrom in NC_064819.1 NC_064820.1 NC_064821.1 NC_064822.1 NC_064823.1 NC_064824.1 NC_064825.1 NC_064826.1 NC_064827.1 NC_064828.1 NC_064829.1 NC_064830.1 NC_064831.1 NC_064832.1 NC_064833.1 NC_064834.1 NC_064835.1 NC_064836.1 NC_064837.1 NC_064838.1 NC_064839.1 NC_064840.1 NC_064841.1 NC_064842.1 NC_064843.1 NC_064844.1 NC_064845.1 NC_064846.1;do sbatch ANGSD_haploToPlink.sh $chrom;done

module load bioinfo-tools
module load ANGSD/0.940-stable

CHROM=$1
INDIR='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo'
OUTDIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo"

haploToPlink ${INDIR}/BCM.${CHROM}.haplo.gz ${OUTDIR}/BCM.${CHROM}