#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=muscle_add
#SBATCH --partition=shared
#SBATCH --cpus-per-task=24
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

ml bioinfo-tools muscle/3.8.31 SeqKit/2.4.0

DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes

#fasta1=${DIR}/Diez-Pecnerova-Valk-etal-2021-mitogenomes.renamed
fasta1=${DIR}/vdV2021_datedsamples_aligned
fasta1_name=$(basename $fasta1)
inputfasta2=${DIR}/bcm004.maln.F.mia_consensus.10x_0.9_filtered
inputfasta3=${DIR}/bcm019.maln.F.mia_consensus.10x_0.9_filtered

# Remove L. africana, L.cyclotis and P.antiquus from alignment (=distant outgroups, keep E. maximus)
seqkit grep -vrp "L.africana|L.cyclotis|P.antiquus" ${fasta1}.fasta > ${DIR}/${fasta1_name}_OutgroupFiltered.fasta

#Align 2 BCM mammoths
cat ${inputfasta2}.fasta ${inputfasta3}.fasta >> ${DIR}/BCM.unaligned.fasta
muscle -in ${DIR}/BCM.unaligned.fasta -out ${DIR}/BCM.aligned.fasta

#Add BCM mammoths to vdv alignment
muscle -profile -in1 ${fasta1}.fasta -in2 $DIR/BCM.aligned.fasta -out $DIR/BCM.vdv2021dated.aligned.add.fasta

