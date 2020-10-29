#!/bin/bash

PATH1="/localdisk/data/BPSM/Assignment1"
PATH2="/localdisk/home/s2085922"

cp -r $PATH1 $PATH2
cd $PATH2/Assignment1
mkdir ./result

#build bowtie2 new index
gunzip ./Tbb_genome/Tb927_genome.fasta.gz
bowtie2-build ./Tbb_genome/Tb927_genome.fasta Trypanosome_brucei
number=216
endnumber=222
startnumber=216

for file in $PATH2/Assignment1/fastq/*.fq.gz
do
	#use fastqc to do quality check
	gunzip $file
done

for file in $PATH2/Assignment1/fastq/*.fq
do
	fastqc -o $PATH2/Assignment1/result $file
done

cd $PATH2/Assignment1
#use bowtie2 to align the read pairs
bowtie2 -x Trypanosome_brucei -1 ./fastq/${number}_L8_1.fq -2 ./fastq/${number}_L8_2.fq -S output_${number}.sam
samtools sort output_${number}.sam > output_${number}.bam
samtools index output_${number}.bam
touch count_result_${number}.txt
bedtools multicov -bams output_${number}.bam -bed Tbbgenes.bed > count_result_${number}.txt
let number+=1

if test "${number}" < "${endnumber}" 
then
	let number+=1
	bowtie2 -x Trypanosome_brucei -1 ./fastq/${number}_L8_1.fq -2 ./fastq/${number}_L8_2.fq -S output_${number}.sam
	samtools sort output_${number}.sam > output_${number}.bam
	samtools index output_${number}.bam
	touch count_result_${number}.txt
	bedtools multicov -bams output_${number}.bam -bed Tbbgenes.bed > count_result_${number}.txt
fi

#n=219
#if test ${statnumber} < $n 
#then
#	for  in $PATH2/Assignment1/count_result_${startnumber}.txt
#		do
	
 
