#Index reference fasta file and align.fq sequences to it
for file in *.fa
do
    echo "Current fasta is $file" 
    bwa index $file
    for sequence in *.fq
    do
        echo "Current fastq library is $sequence"
        bwa mem $file $sequence > ${sequence}.sam
	#Convert sam to bam 
	samtools view -b -o ${sequence}.bam -S ${sequence}.sam
	samtools sort ${sequence}.bam ${sequence}.sorted
	samtools index ${sequence}.sorted.bam
	samtools faidx $file
    done
done

#Create vcf table for all the individuals
samtools mpileup -gf $file *.sorted.bam | bcftools view -vc - > snps_indels.vcf 

