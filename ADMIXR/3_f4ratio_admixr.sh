#!/bin/bash -le

#SBATCH -A naiss2025-5-78
#SBATCH --job-name=admixr_f4ratio
#SBATCH --partition=main
#SBATCH --time=1-00:00:00
#SBATCH --error=slurm-%x-%j-%N-%A.out
#SBATCH --output=slurm-%x-%j-%N-%A.out

module load bioinfo-tools
module load AdmixTools/7.0.1
module load PDC/23.12 R/4.4.0

Rscript /cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/BCM/ADMIXR/f4ratio_admixr.R