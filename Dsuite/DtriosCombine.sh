#!/bin/bash -le

#SBATCH -A naiss2024-5-54
#SBATCH --job-name=Dtrios_Combine
#SBATCH --partition=shared
#SBATCH --cpus-per-task=4
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

Dsuite="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/Dsuite/Build/Dsuite"
DIR=/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/Dsuite

cd $DIR

$Dsuite DtriosCombine -o BCM.ALL.autosomes \
BCM.1 \
BCM.2 \
BCM.3 \
BCM.4 \
BCM.5 \
BCM.6 \
BCM.7 \
BCM.8 \
BCM.9 \
BCM.10 \
BCM.11 \
BCM.12 \
BCM.13 \
BCM.14 \
BCM.15 \
BCM.16 \
BCM.17 \
BCM.18 \
BCM.19 \
BCM.20 \
BCM.21 \
BCM.22 \
BCM.23 \
BCM.24 \
BCM.25 \
BCM.26 \
BCM.27 \
