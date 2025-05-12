#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=bcftools_mpileup
#SBATCH -p main
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

#Load modules
module load bioinfo-tools bcftools/1.20 samtools/1.20
module load bedtools/2.31.0
module load tabix/0.2.6

REF_GENOME='/cfs/klemming/projects/supr/sllstore2017093/mammoth/reference_elemax-human/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.genome'
REF_SEQ='/cfs/klemming/projects/supr/sllstore2017093/mammoth/reference_elemax-human/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.fasta'
INPUT_BAM=$1
DEPTH=8
NAME=$(basename $INPUT_BAM)
OUTPUT_VCF=$(echo $NAME | cut -d "." -f1)
OUTDIR='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BCF'
REPMA='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/references/GCF_024166365.1_mEleMax1.human_g1k_v37.DQ188829.2.ElephantPart.repma.noCpG_ref.bed'
minDP=5
maxDP=$(($DEPTH*3))

if (($minDP<3)); then minDP=3; fi

#Code

cd $OUTDIR

 #Call variants from the bam file
 #"""Minimum mapping quality for a read to be considered: 25"""
 #"""Minimum base quality for a base to be considered: 30"""
 #"""-B: Disabled probabilistic realignment for the computation of base alignment quality (BAQ). BAQ is the Phred-scaled probability of a read base being misaligned. Applying this option greatly helps to reduce false SNPs caused by misalignments"""

bcftools mpileup -q 25 -Q 30 -B -Ou -f $REF_SEQ $INPUT_BAM | bcftools call -m -M -Ob -o $TMPDIR/${OUTPUT_VCF}.Q25.bcf

#Sort bcf
bcftools sort -O b -T /cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/BCF/TEMP -o $OUTDIR/${OUTPUT_VCF}.Q25.sorted.bcf $TMPDIR/${OUTPUT_VCF}.Q25.bcf

#Index sorted bcf
bcftools index -o $OUTDIR/${OUTPUT_VCF}.Q25.sorted.bcf.csi $OUTDIR/${OUTPUT_VCF}.Q25.sorted.bcf

#Stats sorted bcf
bcftools stats $OUTDIR/${OUTPUT_VCF}.Q25.sorted.bcf > $OUTDIR/stats/bcf_sorted/${OUTPUT_VCF}.Q25.sorted.bcf.stats.txt

#Filter SNPs within 5bp of indels
bcftools filter -g 5 -O b -o $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.bcf $OUTDIR/${OUTPUT_VCF}.Q25.sorted.bcf

#Remove indels, genotypes of genotype quality < 25 and keep only sites within depth thresholds
bcftools filter -i "(DP4[0]+DP4[1]+DP4[2]+DP4[3])>${minDP} & (DP4[0]+DP4[1]+DP4[2]+DP4[3])<${maxDP} & QUAL>=25 & INDEL=0" $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.bcf | bcftools annotate -x ^INFO/DP,INFO/DP4,^FORMAT/GT,FORMAT/PL -O b -o ${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.bcf

#Index BCF
bcftools index ${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.bcf

#Stats after filtering
bcftools stats ${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.bcf > $OUTDIR/stats/bcf_annot/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.bcf.stats.txt

#Mask repeats and CpG sites
bcftools view ${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.bcf | bedtools intersect -a stdin -b $REPMA -g $REF_GENOME -header -sorted | bgzip -c > $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.vcf.gz

#Convert vcf to bcf
bcftools convert -O b -o $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.bcf $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.vcf.gz
bcftools index $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.bcf
bcftools stats $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.bcf > $OUTDIR/stats/bcf_repma/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.bcf.noCpg_ref.stats.txt

### AB filtering ###

bcftools view -e 'GT="0/1" & (DP4[2]+DP4[3])/(DP4[0]+DP4[1]+DP4[2]+DP4[3]) < 0.2' $TMPDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.bcf| \
bcftools view -e 'GT="0/1" & (DP4[2]+DP4[3])/(DP4[0]+DP4[1]+DP4[2]+DP4[3]) > 0.8' -Ob > $OUTDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.AB.bcf
bcftools index $OUTDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.AB.bcf
bcftools stats $OUTDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.AB.bcf > $OUTDIR/stats/bcf_AB/$OUTDIR/${OUTPUT_VCF}.Q25.sorted.G5.D3.noIndel.annot.repma.noCpg_ref.AB.stats.txt
