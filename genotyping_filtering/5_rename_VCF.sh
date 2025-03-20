#!/bin/bash -le

module load bioinfo-tools bcftools

DIR='/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/BCM/DATA/haplo'
FILE="BCM"
OUTDIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/BCM/SCRIPTS/


bcftools query -l $DIR/$FILE.vcf > $OUTDIR/oldnames.tmp.txt #Extract old sample IDs
awk '{cmd="basename " $0; cmd | getline result; print result; close(cmd)}' "$OUTDIR/bamfiles.txt" > $OUTDIR/newnames.tmp.txt #Extract new sample IDs
paste -d ' ' $OUTDIR/oldnames.tmp.txt $OUTDIR/newnames.tmp.txt > $OUTDIR/header.tmp.txt #Generate new header
bcftools reheader -s $OUTDIR/header.tmp.txt -o $DIR/$FILE.SampleID.vcf $DIR/$FILE.vcf #Update header

