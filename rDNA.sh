## rDNA identification and copy number estimation

# rDNA loci identification
RNAmmer-1.2 -S euk -m lsu,ssu,tsu ZM113_v0.fa -gff ZM113_v0.ncRNA.gff3
RNAmmer-1.2 -S euk -m lsu,ssu,tsu ZM113_t2t.fa -gff ZM113_t2t.ncRNA.gff3

# calculate sequence depth
# --- HiFi and ONT reads mapping：
module --force purge
ml biocontainers winnowmap
winnowmap  --MD   -H --secondary=no  -t  40  -L  -ax  map-pb ZM113_v0.fa >ZM113_v0_hifi.sam
winnowmap  --MD   -H --secondary=no  -t  40  -L  -ax  map-ont ZM113_v0.fa >ZM113_v0_ONT.sam
# --- MGI reads mapping：
minimap2 --split-prefix ${prefix}  --secondary=no  -t 40 -ax sr ZM113_v0.fa  short.clean1.fq short.clean2.fq
#
samtools view -bs test.sam >test.bam
bamdst -p test.bed -o ./ test.bam 
