#!/bin/bash

module load bioinfo-tools
module load AdmixTools/7.0.1
module load plink/1.90b4.9 bcftools/1.20 vcftools/0.1.16

#FILE="BCM.SampleID.snps.NewChr.autos.Dsuite.LDprune.SUBSET"
FILE="BCM.SampleID.snps.NewChr.X.Dsuite.SUBSET"
DIR="/cfs/klemming/projects/supr/sllstore2017093/mammoth/marianne/GIT/data_BCM/ADMIXR"

#recombination rate in cM/Mb
rec=1

cd $DIR

#Generate map file
#plink --bfile ${FILE} --recode --allow-extra-chr --chr-set 27 --out ${FILE}
plink --bfile ${FILE} --recode --allow-extra-chr --chr X --out ${FILE}

###########################################
### Modified from Joana Meier's scripts
### https://github.com/joanam/scripts/blob/master/convertVCFtoEigenstrat.sh
###########################################

awk 'BEGIN {OFS = "\t"; add=0; lastPos=0; scaff=""}{
    if ($1 != scaff) {        # If the scaffold (chromosome) changes
        add = lastPos;        # Update the additive position
        scaff = $1;           # Update the current scaffold name
    }
    $1 = "1";                 # Set the scaffold name to 1
    $4 = $4 + add;            # Update the position column to be additive
    $2 = $1 ":" $4;           # Set the second column to be "1:<additive_position>"
    lastPos = $4;             # Update the last position
    print $0                  # Print the modified line
}' ${FILE}.map > ${FILE}.renamedScaff.map

cp ${FILE}.ped ${FILE}.renamedScaff.ped


# Change the .map FILE to match the requirements of ADMIXTOOLS by adding fake Morgan positions (assuming a recombination rate of $rec cM/Mbp)
awk -F"\t" -v rec=$rec 'BEGIN{scaff="";add=0}{
        split($2,newScaff,":")
        if(!match(newScaff[1],scaff)){
                scaff=newScaff[1]
                add=lastPos
        }
        pos=add+$4
	count+=0.00000001*rec*(pos-lastPos)
        print newScaff[1]"\t"$2"\t"count"\t"pos
        lastPos=pos
}' ${FILE}.renamedScaff.map  | sed 's/^chr//' > better.map
mv better.map ${FILE}.renamedScaff.map

# Change the .ped FILE to match the ADMIXTOOLS requirements
awk 'BEGIN{ind=1}{printf ind"\t"$2"\t0\t0\t0\t1\t";
 for(i=7;i<=NF;++i) printf $i"\t";ind++;printf "\n"}' ${FILE}.renamedScaff.ped > tmp.ped
mv tmp.ped ${FILE}.renamedScaff.ped


# create an inputFILE for convertf
echo "genotypename:    ${FILE}.renamedScaff.ped" > par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "snpname:         ${FILE}.renamedScaff.map" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "indivname:       ${FILE}.renamedScaff.ped" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "outputformat:    EIGENSTRAT" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "genotypeoutname: ${FILE}.eigenstratgeno" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "snpoutname:      ${FILE}.snp" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "indivoutname:    ${FILE}.ind" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff
echo "familynames:     NO" >> par.PED.EIGENSTRAT.${FILE}.renamedScaff


# Use CONVERTF to parse PED to eigenstrat
convertf -p par.PED.EIGENSTRAT.${FILE}.renamedScaff

# change the snp FILE for ADMIXTOOLS:
awk 'BEGIN{i=0}{i=i+1; print $1"\t"$2"\t"$3"\t"i"\t"$5"\t"$6}' $FILE.snp > $FILE.snp.tmp
mv $FILE.snp.tmp $FILE.snp
