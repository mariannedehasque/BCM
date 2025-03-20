#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=ANGSD_dohaplo
#SBATCH --partition=shared
#SBATCH --cpus-per-task=24
#SBATCH --time=5-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load ANGSD/0.940-stable

#parameters
CHROM=$1
OUTDIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/BCM/DATA/haplo"
REF_DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/references"
REF_SEQ=$REF_DIR/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.fasta
SITESFILE=$REF_DIR/$CHROM.repma.noCpg_ref.angsd.txt
INPUTBAM="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/BCM/SCRIPTS/bamfiles.txt"
FILENAME="BCM"


#add #-rmTrans 1 \ if not CpG masked

angsd -bam ${INPUTBAM} \
-doHaploCall 1 \
-doCounts 1 \
-minMinor 1 \
-remove_bads 1 \
-r ${CHROM} \
-uniqueOnly 1 \
-minMapQ 25 -minQ 30 \
-nThreads 24 \
-ref $REF_SEQ \
-sites $SITESFILE \
-doGeno -4 \
-doPost 2 \
-GL 1 \
-doMajorMinor 4 \
-out ${OUTDIR}/${FILENAME}.${CHROM}

#for chrom in NC_064819.1 NC_064820.1 NC_064821.1 NC_064822.1 NC_064823.1 NC_064824.1 NC_064825.1 NC_064826.1 NC_064827.1 NC_064828.1 NC_064829.1 NC_064830.1 NC_064831.1 NC_064832.1 NC_064833.1 NC_064834.1 NC_064835.1 NC_064836.1 NC_064837.1 NC_064838.1 NC_064839.1 NC_064840.1 NC_064841.1 NC_064842.1 NC_064843.1 NC_064844.1 NC_064845.1 NC_064846.1;do sbatch 2_ANGSD_haplo.sh $chrom;done
#sbatch ANGSD_haplo.sh NC_064846.1