#! /bin/bash -l
#SBATCH -A naiss2024-22-851
#SBATCH -p core
#SBATCH --cpus-per-task=8
#SBATCH -t 24:00:00
#SBATCH -J muscle_v3.8.31
#SBATCH --output=slurm_%x_%j.out

ml bioinfo-tools muscle/3.8.31 SeqKit/2.4.0

DIR=/proj/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes

fasta1=${DIR}/Diez-Pecnerova-Valk-etal-2021-mitogenomes.renamed.unaligned
fasta1_name=$(basename $fasta1)
inputfasta2=/proj/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes/bcm004.maln.F.mia_consensus.10x_0.9_filtered
inputfasta3=/proj/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes/bcm019.maln.F.mia_consensus.10x_0.9_filtered

# Remove L. africana, L.cyclotis and P.antiquus from alignment (=distant outgroups, keep E. maximus)
#seqkit grep -vrp "^L.africana|L.cyclotis|P.antiquus" ${fasta1}.fasta > ${DIR}/${fasta1_name}_OutgroupFiltered.fasta

#cat ${inputfasta2}.fasta ${inputfasta3}.fasta ${DIR}/${fasta1_name}_OutgroupFiltered.fasta >> $DIR/BCM.vdv2021.OutgroupFiltered.unaligned.fasta

muscle -in $DIR/BCM.vdv2021.OutgroupFiltered.unaligned.fasta -out $DIR/BCM.vdv2021.aligned.OutgroupFiltered.fasta