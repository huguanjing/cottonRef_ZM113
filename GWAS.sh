#####vcf to map #####
vcftools --gzvcf vcf.gz --plink --out /geno/Gh
#####gemma gwas #####
gemma -bfile /01.geno/Gh -k Gh.cXX.txt -lmm 1 -o FD_blup  -n 2 -miss 0.2 -maf 0.05 
mv FD_blup.log.txt /gemma/
perl /script/gwas_script/chang.chr.v2.pl /gemma/FD_blup.assoc.txt /gwas_data/FD_blup.gwas.data
gzip /gemma/FD_blup.assoc.txt
