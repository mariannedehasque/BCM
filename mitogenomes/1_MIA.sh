#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 4-00:00:00
#SBATCH -J MIA

### MIA (Mapping Iterative Assembler): for mitogenome reconstruction

source /home/marideha/miniconda3/bin/activate MIA

SAMPLE_NAME=$1
MIA_OUTDIR=/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data/mitogenomes

ANCIENT_DNA_MATRIX=/proj/sllstore2017093/mammoth/marianne/GIT/BCM/mitogenomes/ancient.submat.txt
MIA_REFERENCE_MITOGENOME=/proj/sllstore2017093/mammoth/marianne/GIT/BCM_data/mitogenomes/NC_005129.2.fasta
MIA_FASTA=/proj/sllstore2017093/mammoth/marianne/GIT/BCM/mitogenomes/create_fasta_from_mia.py
PROCESSED_READS=/proj/sllstore2017093/mammoth/marianne/snakemake_v2.3.1_BCM_MIA/results/historical/trimmed_merged_reads


# Running MIA -- Shotgun data, not too diverged from reference (if capture, remove duplicates; if diverged, use wormhole MIA)
	gzip -d $PROCESSED_READS/${SAMPLE_NAME}_trimmed_merged.fastq.gz
	#wait
	mia -r $MIA_REFERENCE_MITOGENOME -f $PROCESSED_READS/${SAMPLE_NAME}_trimmed_merged.fastq -c -C -U -s ${ANCIENT_DNA_MATRIX} -i -F -k 14 -m ${MIA_OUTDIR}/${SAMPLE_NAME}.maln
	#wait
	gzip $PROCESSED_READS/${SAMPLE_NAME}_trimmed_merged.fastq
	#wait

	ma -M ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.* -f 3 > ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_stats.txt
	#wait
	ma -M ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.* -f 2 > ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_coverage_per_site.txt
	#wait
	ma -M ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.* -f 5 > ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_consensus.fasta
	#wait
	ma -M ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.* -f 41 > ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.inputfornext.txt
	#wait

ml bioinfo-tools python3

# Generating consensus mitogenomes
	# -c = minimum depth of coverage required for a base to be called
	# -p = proportion of read agreement required for a base to be called

	python ${MIA_FASTA} -c 3 -p 0.67 -I ${MIA_OUTDIR}/${SAMPLE_NAME}_3x_0.67 -m ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.inputfornext.txt -o ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_consensus.3x_0.67_filtered.fasta
 	wait
	python ${MIA_FASTA} -c 10 -p 0.9 -I ${MIA_OUTDIR}/${SAMPLE_NAME}_10x_0.9 -m ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.inputfornext.txt -o ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_consensus.10x_0.9_filtered.fasta
	wait

#Change name of alignment to something more informative
#This is more easy to do infile
#sed -i "1s/.*/>$SAMPLE_NAME/" ${MIA_OUTDIR}/${SAMPLE_NAME}.maln.F.mia_consensus.10x_0.9_filtered.fasta