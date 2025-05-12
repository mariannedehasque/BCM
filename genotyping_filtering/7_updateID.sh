ml bioinfo-tools plink/1.90b4.9

INDIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo
OUTDIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ANGSD/haplo

#autosomes
plink -bfile $INDIR/BCM.SampleID.snps.NewChr.X.Dsuite --update-ids /cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/SUBSET.txt --make-bed --allow-extra-chr --chr X --out $OUTDIR/BCM.SampleID.snps.NewChr.X.Dsuite.SUBSET
plink -bfile $INDIR/BCM.SampleID.snps.NewChr.autos.Dsuite --update-ids /cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/genotyping_filtering/INPUTFILES/SUBSET.txt --make-bed --allow-extra-chr --chr-set 27 --out $OUTDIR/BCM.SampleID.snps.NewChr.autos.Dsuite.SUBSET
