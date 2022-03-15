CeleScope.R

#sh
for i in *sra
do
echo $i
# fastq-dump --split-3 $i
./pfastq-dump $i --split-3 --gzip --outdir ./ -t 8
done




git clone https://github.com/singleron-RD/CeleScope.git

cd CeleScope
conda create -n celescope -y --file conda_pkgs.txt

conda activate celescope
pip install celescope

# ModuleNotFoundError: No module named '_sysconfigdata_x86_64_conda_linux_gnu'
# 解决办法：ls -l /share2/pub/zhenggw/zhenggw/anaconda3/envs/celescope/lib/python3.6/_sysconfigdata_x86_64_conda*
# -rw-rw-r-- 1 zhenggw sulab 27060 Feb 16 16:57 /share2/pub/zhenggw/zhenggw/anaconda3/envs/celescope/lib/python3.6/_sysconfigdata_x86_64_conda_cos6_linux_gnu.py
# 发现有带cos6的文件 查询发现拷贝一份该文件即可
# cp /share2/pub/zhenggw/zhenggw/anaconda3/envs/celescope/lib/python3.6/_sysconfigdata_x86_64_conda_cos6_linux_gnu.py /share2/pub/zhenggw/zhenggw/anaconda3/envs/celescope/lib/python3.6/_sysconfigdata_x86_64_conda_linux_gnu.py

mkdir hs_ensembl_99
cd hs_ensembl_99

wget ftp://ftp.ensembl.org/pub/release-99/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
wget ftp://ftp.ensembl.org/pub/release-99/gtf/homo_sapiens/Homo_sapiens.GRCh38.99.gtf.gz

gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
gunzip Homo_sapiens.GRCh38.99.gtf.gz

#conda activate celescope
celescope rna mkref \
 --genome_name Homo_sapiens_ensembl_99 \
 --fasta Homo_sapiens.GRCh38.dna.primary_assembly.fa \
 --gtf Homo_sapiens.GRCh38.99.gtf


#run.sh
conda activate celescope
multi_rna\
	--mapfile ./mapfile\
	--genomeDir /share2/pub/zhenggw/zhenggw/metastasis/hs_ensembl_99/\
	--thread 8\
	--mod shell

# $cat ./my.mapfile
# fastq_prefix1	fastq_dir1	sample1
# fastq_prefix2	fastq_dir2	sample1
# fastq_prefix3	fastq_dir1	sample2

# $ls fastq_dir1
# fastq_prefix1_1.fq.gz	fastq_prefix1_2.fq.gz
# fastq_prefix3_1.fq.gz	fastq_prefix3_2.fq.gz

# $ls fastq_dir2
# fastq_prefix2_1.fq.gz	fastq_prefix2_2.fq.gz

sh ./shell/BC.sh

SRR15180322	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT4-TNBC-LN1
SRR15180323	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT4-TNBC-LN2
SRR15180324	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT5-Her2-PC
SRR15180325	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT5-Her2-LN1
SRR15180326	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT5-Her2-LN2
SRR15180327	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT1-TNBC-PC
SRR15180328	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT1-TNBC-LN1
SRR15180329	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT1-TNBC-LN2
SRR15180330	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT2-luminalB-PC
SRR15180331	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT2-luminalB-LN1
SRR15180332	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT2-luminalB-LN2
SRR15180333	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT3-Her2-PC
SRR15180334	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT3-Her2-LN1
SRR15180335	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT3-Her2-LN2
SRR15180336	/share2/pub/zhenggw/zhenggw/metastasis/SRP328759	PT4-TNBC-PC

multi_rna --mapfile ./rna.mapfile --genomeDir /share2/pub/zhenggw/zhenggw/metastasis/hs_ensembl_99/ --thread 8 --mod shell --chemistry scopeV1 --save_rds

for i in ./pfastq-dump-test/*sra
do
echo $i
# fastq-dump --split-3 $i
fastq-dump --split-3 $i --gzip --outdir ./SRP-2
done

multi_rna --mapfile ./rna.mapfile.15samples --genomeDir /share2/pub/zhenggw/zhenggw/metastasis/hs_ensembl_99/ --thread 8 --mod shell --chemistry scopeV1 --save_rds
