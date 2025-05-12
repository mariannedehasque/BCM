#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=beast_strict
#SBATCH --partition=shared
#SBATCH --cpus-per-task=96
#SBATCH --time=7-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load beast/1.10.4

DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes
#INPUT=BCM.vdv2021dated.aligned.OutgroupFiltered.add.novntr.strict.xml
#INPUT=BCM.vdv2021dated.aligned.OutgroupFiltered.add.novntr.relaxed.xml
#INPUT=BCM.vdv2021.aligned.OutgroupFiltered.add.novntr.strict.xml
INPUT=BCM.vdv2021.aligned.OutgroupFiltered.add.novntr.tipdating.short.xml
#INPUT=BCM.vdv2021.aligned.OutgroupFiltered.add.novntr.tipdating.xml


cd $DIR

beast -beagle_cpu -beagle_sse -beagle_double -threads 80 -overwrite $INPUT