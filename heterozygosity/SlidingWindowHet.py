# Script to count number of called genotypes and number of heterozygotes per sample in sliding windows.
# Script adapted from Robinson et al. 2021. Current Biology https://doi.org/10.1016/j.cub.2021.04.035.
# Modification made to work with python 3
#
# Input file is a single- or multi-sample VCF file that has been filtered (passing sites
# have "PASS" in the FILTER column). Sites without PASS in filter column are skipped.
#
# Also need to have a file called "chrom_lengths.txt" in the directory. File
# "chrom_lengths.txt" is a two-column tab-delimited list of chromosomes and chromosome
# lengths in the reference genome.
#
# Usage:
# python ./SlidingWindowHet.py [vcf] [window size] [step size] [chromosome/scaffold name]
#
# Windows will be non-overlapping if step size == window size.
#
# Example:
# python ./SlidingWindowHet.py input.vcf.gz 100000 10000 chr01


import sys
import pysam
import os
import gzip

# Open input file and make sure the VCF file is indexed (if not, create index)
filename = sys.argv[1]
VCF = gzip.open(filename, 'rt')

if not os.path.exists(f"{filename}.tbi"):
    pysam.tabix_index(filename, preset="vcf")
parsevcf = pysam.TabixFile(filename)

# Set variables
window_size = int(sys.argv[2])
step_size = int(sys.argv[3])
chrom = sys.argv[4]

outputname = sys.argv[5]

# Generate a dictionary with chromosomes and chromosome lengths
# File "chrom_lengths.txt" is a two-column tab-delimited list of chromosomes and
# chromosome lengths in the reference genome
with open("chrom_lengths.txt", 'r') as cc:
    chrom_size = {line.strip().split('\t')[0]: int(line.strip().split('\t')[1]) for line in cc}

# Get list of samples from VCF file header
samples = []
for line in VCF:
    if line.startswith('##'):
        continue
    else:
        samples = line.strip().split()[9:]
        break

# Get start and end positions of chromosome
for line in VCF:
    if not line.startswith('#'):
        start_pos = int(line.strip().split()[1])
        end_pos = chrom_size[chrom]
        break

# Create output file
output = open(f"{outputname}_het_{window_size}win_{step_size}step_{chrom}.txt", 'w')
output.write(
    "chrom\twindow_start\tsites_total\t{calls}\t{hets}\n".format(
        calls='\t'.join([f"calls_{sample}" for sample in samples]),
        hets='\t'.join([f"hets_{sample}" for sample in samples])
    )
)

# Fetch a region, ignore sites that fail filters, tally genotype calls and heterozygotes
def snp_cal(chrom, window_start, window_end):
    #print(f"{chrom}:{window_start}")
    rows = tuple(parsevcf.fetch(region=f"{chrom}:{window_start}-{window_end}", parser=pysam.asTuple()))
    sites_total = 0
    calls = [0] * len(samples)
    hets = [0] * len(samples)

    for line in rows:
        if line[6] != "PASS":
            continue
        sites_total += 1
        for i in range(len(samples)):
            if line[i + 9].startswith('.'):
                continue
            calls[i] += 1
            GT = line[i + 9].split(':')[0]
            sp = '/' if '/' in GT else '|'
            if GT.split(sp)[0] != GT.split(sp)[1]:
                hets[i] += 1

    output.write("{}\t{}\t{}\t{}\t{}\n".format(
    chrom,
    window_start,
    sites_total,
    '\t'.join(map(str, calls)),
    '\t'.join(map(str, hets))
))

# Initialize window start and end coordinates
window_start = start_pos
window_end = start_pos + window_size - 1

# Calculate stats for window, update window start and end positions,
# repeat to end of chromosome
while window_end <= end_pos:
    if window_end < end_pos:
        snp_cal(chrom, window_start, window_end)
        window_start += step_size
        window_end = window_start + window_size - 1
    else:
        snp_cal(chrom, window_start, window_end)
        break
else:
    window_end = end_pos
    snp_cal(chrom, window_start, window_end)

# Close files and exit
VCF.close()
output.close()
