### SCRIPT BY Hannah Moots, Juliana Larsdotter, and Florentine Tubessing ####

#Calculates the genetic sex of samples based on X, Y, and autosomal read counts.

# Inputs:
# lab_ids.txt : A text file with one sample ID per line.
# BAM files   : path to BAM files for each sample.

# Output:
# genetic_sex.csv : A CSV file summarizing read counts and X/autosome, Y/autosome coverage ratios.

# Notes:
# Modify /path/to/BAMs below to the path where your BAM files are stored.
# Ensure that sample IDs in lab_ids.txt match the BAM file naming pattern.


echo "lab_ID,X_reads,Y_reads,total_reads_autosome,X_auto_reads,Y_auto_reads" > genetic_sex.csv

for i in $(cat lab_ids.txt); do

X_reads=$(samtools view -c -q 25 /path/to/BAMs/$i*.bam NC_064846.1)
 
Y_reads=$(samtools view -c -q 25 /path/to/BAMs/$i*.bam NC_064847.1)

auto_reads=$(samtools view -c -q 25 /path/to/BAMs/$i*.bam {NC_064819.1,NC_064820.1,NC_064821.1,NC_064822.1,NC_064823.1,NC_064824.1,NC_064825.1,NC_064826.1,NC_064827.1,NC_064828.1,NC_064829.1,NC_064830.1,NC_064831.1,NC_064832.1,NC_064833.1,NC_064834.1,NC_064835.1,NC_064836.1,NC_064837.1,NC_064838.1,NC_064839.1,NC_064840.1,NC_064841.1,NC_064842.1,NC_064843.1,NC_064844.1,NC_064845.1})

X_auto_cov=$(echo "scale=4; $X_reads / $auto_reads" | bc)
Y_auto_cov=$(echo "scale=4; $Y_reads / $auto_reads" | bc)

echo "$i,$X_reads,$Y_reads,$auto_reads,0$X_auto_cov,0$Y_auto_cov" >> genetic_sex.csv

done