## GhSat194 copy number estimation

### 1.Calculate the ratio of GhSat194 to whole genome sequencing depth based on short-read  data 根据二代测序数据计算GhSat194序列相对全基因组测序深度的比值，从而估计GhSat194的拷贝数
# input GhSat194 fasta: 194.fa 
# input illumina reads: sample_clean_1.fq.gz sample_clean_2.fq.gz
bwa mem -R "@RG\tID:ZM113\tLB:ZM113\tPL:ILLUMINA\tSM:ZM113" -t 16 -M 194.fa sample_clean_1.fq.gz sample_clean_2.fq.gz >194.sam
samtools view -bS 194.sam > 194.bam
samtools sort -@8 194.bam -o 194.sort.bam
samtools depth 194.sort.bam >194.depth.txt
awk -F "\t" 'BEGAIN{a=0;b=0}{if($3>0){a++;b+=$3}}END{print b/a}' 194.depth.txt.

#### 2. Count GhSat194 in reference genomes 根据完整拼装的参考基因组（包含scaffolds）计算GhSat194的拷贝数
ref=D5t2t.fa # example
db=D5t2t
query=194.fa
out=blast194/D5t2t
# blastn against genome
makeblastdb -in $ref -dbtype nucl -out $db -parse_seqids
blastn -query $query -out $out.blast -db $db -outfmt 6 -evalue 1e-10 -num_threads 20 -num_alignments 5
# convert blastn to bed
grep 'prefix#circ1-194' $out.blast|awk 'BEGIN {OFS="\t"} {print $2, ($9 < $10 ? $9-1 : $10-1), ($9 < $10 ? $10 : $9), $1, $12, ($9 < $10 ? "+" : "-")}' > $out.bed
awk '{count[$1, $6]++} END {for (key in count) {split(key, keys, SUBSEP); print keys[1], keys[2], count[key]}}' $out.bed
grep 'prefix#circ1-194' $out.blast|awk 'BEGIN {OFS="\t"} {print $2, ($9 < $10 ? $9-1 : $10-1), ($9 < $10 ? $10 : $9), $1, $12, ($9 < $10 ? "+" : "-")}' |sort > $out.blast.bed
### count numbers by Chr and String
awk '{count[$1, $6]++} END {for (key in count) {split(key, keys, SUBSEP); print keys[1], keys[2], count[key]}}' $out.bed
# D08 - 1047
