#!/bin/bash -le

#SBATCH -A naiss2024-5-54
#SBATCH --job-name=GenerateSites
#SBATCH --partition=shared
#SBATCH --cpus-per-task=1
#SBATCH --time=4-00:00:00
#SBATCH --output=slurm-%A_%a.out
#SBATCH --error=slurm-%A_%a.out

module load bioinfo-tools
module load ANGSD/0.940-stable

DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/references"
FILENAME="GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.ElephantPart.repma"

#Split BED file per chromosome and convert BED to ANGSD format
for chr in NC_064819.1 NC_064820.1 NC_064821.1 NC_064822.1 NC_064823.1 NC_064824.1 NC_064825.1 NC_064826.1 NC_064827.1 NC_064828.1 NC_064829.1 NC_064830.1 NC_064831.1 NC_064832.1 NC_064833.1 NC_064834.1 NC_064835.1 NC_064836.1 NC_064837.1 NC_064838.1 NC_064839.1 NC_064840.1 NC_064841.1 NC_064842.1 NC_064843.1 NC_064844.1 NC_064845.1 NC_064846.1
do
    grep "^$chr" $DIR/$FILENAME.bed > $DIR/$chr.repma.bed
    awk '{print $1"\t"$2+1"\t"$3}' $DIR/$chr.repma.bed > $DIR/$chr.repma.angsd.txt
    angsd sites index $DIR/$chr.repma.angsd.txt
done

