#!/bin/bash -l
#SBATCH -A naiss2024-5-54
#SBATCH -p core -n 8
#SBATCH -J RAxML-NG
#SBATCH -t 10-00:00:00

module load bioinfo-tools
module load RAxML-NG/1.1.0

DIR=/proj/sllstore2017093/mammoth/marianne/GIT/data_BCM/mitogenomes

cd $DIR


#MSA format check
raxml-ng --check --msa BCM.vdv2021.aligned.OutgroupFiltered.fasta --model GTR+G --prefix BCM.vdv2021

#Run Raxml
raxml-ng --msa BCM.vdv2021.raxml.reduced.phy --all --bs-trees 100 -model GTR+G --prefix BCM.vdv2021 --outgroup NC_005129_E.maximus_0,EF588275_E.maximus_0 --threads 8 --seed 2 

#Bootstrap
raxml-ng --bootstrap --bs-trees 1000 --msa BCM.vdv2021.raxml.reduced.phy --model GTR+G --prefix BCM.vdv2021.bootstrap --seed 555 --threads 8

#Check convergence
raxml-ng --bsconverge --bs-trees BCM.vdv2021.bootstrap.raxml.bootstraps --prefix BCM.vdv2021 --seed 555 --threads 1
#Convergence after 450 trees

#Compute branch support
raxml-ng --support --tree BCM.vdv2021.raxml.bestTree --bs-trees BCM.vdv2021.bootstrap.raxml.bootstraps --prefix BCM.vdv2021.support --threads 2 