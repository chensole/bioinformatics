

# ----------------------------------------------- 基因家族分析 ---------------------------------------------------


#--------------------------  1. 搜索物种的基因家族信息 ----------------------------------------

所需文件：

	基因组 fasta 文件
	
	基因组 CDS fasta 文件

	基因组 蛋白质 fasta 文件

	基因注释文件 gff

	基因家族 pfam 文件


#下载拟南芥基因组信息
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-41/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-41/fasta/arabidopsis_thaliana/cds/Arabidopsis_thaliana.TAIR10.cds.all.fa.gz
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-41/fasta/arabidopsis_thaliana/pep/Arabidopsis_thaliana.TAIR10.pep.all.fa.gz
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-41/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.41.gff3.gz
#
#解压压缩文件
#gunzip *gz

#处理GFF 文件里面ID中一些不必要的信息，gene:  transcript: 删除；与蛋白质中的ID保持一致：Arabidopsis_thaliana.TAIR10.pep.all.fa 
#sed -i 's#gene:##' Arabidopsis_thaliana.TAIR10.41.gff3
#sed -i 's#transcript:##' Arabidopsis_thaliana.TAIR10.41.gff3
#sed -i 's#CDS:##' Arabidopsis_thaliana.TAIR10.41.gff3


#------------------- gff文件  获取基因与mRNA的对应关系

perl script/mRNAid_to_geneid.pl Arabidopsis_thaliana.TAIR10.41.gff3 mRNA2geneID.txt
perl script/geneid_to_mRNAid.pl Arabidopsis_thaliana.TAIR10.41.gff3 geneid2mRNAid.txt

#与Arabidopsis_thaliana.TAIR10.pep.all.fa 文件中的ID保持一致，如果第20-21行没有做，这里可以补做；
#sed -i 's#gene:##' mRNA2geneID.txt
#sed -i 's#transcript:##' mRNA2geneID.txt
#sed -i 's#CDS:##' mRNA2geneID.txt

#---------------------  在 蛋白文件  中搜索 基因家族 保守结构域

hmmsearch --domtblout WRKY_hmm_out.txt --cut_tc WRKY.hmm Arabidopsis_thaliana.TAIR10.pep.all.fa


# -------------------  筛选比对搜索结果，并提取 保守结构域 序列

#提取结构域序列，脚本最后的evalue参数1.2e-28，根据实际情况可调,大于这个E值脚本会跳过这个一行;注意脚本提取的是第一个domain，如要提取其他domain，请修改脚本27行$a[9]==1为第一个，$a[9]==2为第二个，依次类推

perl script/domain_xulie.pl WRKY_hmm_out.txt Arabidopsis_thaliana.TAIR10.pep.all.fa WRKY_domain.fa 1.2e-28



###########以下部分为建立物种特异模型再次搜索，可根据自己基因家族情况选做这部分内容#############################  ( 这一步可选 )


#clusterW多序列比对快捷方法

echo "1\nWRKY_domain.fa\n2\n1\nWRKY_domain.aln\nWRKY_domain.dnd\nX\n\n\nX\n" |clustalw

#利用比对结果建立物种特异hmm模型
hmmbuild WRKY_domain_new.hmm WRKY_domain.aln

#新建物种特异hmm模型，再次搜索

hmmsearch --domtblout WRKY_domain_new_out.txt --cut_tc WRKY_domain_new.hmm Arabidopsis_thaliana.TAIR10.pep.all.fa

############################################################################################################



# ------------------------ 转录本选择，去冗余

#筛选 hmm搜索结果，可以用excel手动筛选，筛选标准，
#1.E-value值小于0.001；
#2.如果有多个转录本选第一个转录本
#3.只有一个转录本，就选那个转录本

#筛选EValue  <0.001
#如果只想用hmmer搜索一次，可将下面的文件：WRKY_domain_new_out.txt 替换成 57行 生成的文件：WRKY_hmm_out.txt
grep -v "^#" WRKY_domain_new_out.txt|awk '$7<0.001 {print}' >WRKY_domain_new_out_selected.txt


#去除重复的hmmer搜索的转录本ID，多个转录本ID保留一个作为基因的代表，此步建议对脚本输出的文件手动筛选，挑选ID：
perl script/select_redundant_mRNA.pl mRNA2geneID.txt WRKY_domain_new_out_selected.txt WRKY_remove_redundant_IDlist.txt


#请手动挑选完mRNA的ID放在第一列，也就是挑选一个转录本ID代表这个基因，存成新的文件WRKY_removed_redundant_IDlist.txt：


# ------------------------ 提取 筛选过后 转录本所对应的 基因的序列

#利用脚本得到对应基因的蛋白序列，脚本会读取第一个文件的第一列ID，把对应ID的序列提取出来：
perl script/get_fa_by_id.pl WRKY_removed_redundant_IDlist.txt Arabidopsis_thaliana.TAIR10.pep.all.fa WRKY_pep_need_to_confirm.fa


#将上面WRKY_pep_need_to_confirm.fa文件中的蛋白序列，再手动验证一下，把不需要的ID删除，最终确认：WRKY_removed_redundant_IDlist.txt 存成新文件：WRKY_removed_redundant_and_confirmed_IDlist.txt

#手动确认结构域，CDD，SMART，PFAM
#确定分子量大小：http://web.expasy.org/protparam/
#perl script/stat_protein_fa.pl WRKY_pep_need_to_confirm.fa WRKY_pep_need_to_confirm.MW.txt
#三大数据库网站，筛选之后去除一些不确定的基因ID，最终得到可靠的基因家族基因列表,存储在文件：WRKY_removed_redundant_and_confirmed_IDlist.txt ; 


#脚本提取hmm结果文件，重新筛选一下hmm的结果：

perl script/get_data_by_id.pl WRKY_removed_redundant_and_confirmed_IDlist.txt WRKY_domain_new_out_selected.txt WRKY_domain_new_out_removed_redundant.txt

#截取得到序列上的保守结构域序列，注意脚本提取的是第一个domain，如要提取其他domain，请修改脚本27行$a[9]==1为第一个，$a[9]==2为第二个，依次类推

perl script/domain_xulie.pl WRKY_domain_new_out_removed_redundant.txt Arabidopsis_thaliana.TAIR10.pep.all.fa WRKY_domain_confirmed.fa 0.1

#得到对应基因的蛋白序列全长：

perl script/get_fa_by_id.pl WRKY_domain_new_out_removed_redundant.txt Arabidopsis_thaliana.TAIR10.pep.all.fa WRKY_pep_confirmed.fa

#得到对应基因的cds序列：

perl script/get_fa_by_id.pl WRKY_domain_new_out_removed_redundant.txt Arabidopsis_thaliana.TAIR10.cds.all.fa WRKY_cds_confirmed.fa






########################进化树分析##########################################

所需文件

	上面搜索到的 基因家族蛋白质保守结构域序列(也可以用蛋白序列全长)

	mega 分析绘制 树

	Evoview 进行美化

#cd $workdir 回到工作路径

mkdir gene_tree_analysis
cd gene_tree_analysis
cp ../WRKY_domain_confirmed.fa .
cp ../WRKY_pep_confirmed.fa .
cp ../WRKY_cds_confirmed.fa .
cp ../WRKY_domain_new_out_removed_redundant.txt .


#########################利用meme软件做motif分析################################33


所需文件

	基因家族蛋白质 全长

#cd $workdir
mkdir meme_motif_analysis
cd meme_motif_analysis
#搜索结构域：
#-nmotifs 10  搜索motif的总个数
#-minw 6   motif的最短长度
#-maxw 50   motif的最大长度

# meme 输出 motif 图

/biosoft/meme/meme-v4.12.0/bin/meme ../WRKY_pep_confirmed.fa -protein -oc ./ -nostatus -time 18000 -maxsize 6000000 -mod anr -nmotifs 10 -minw 6 -maxw 100




##################################基因结构分析structure####################

所需文件

	基因蛋白结构域所对应的 geneID 信息

	gff 文件

#cd $workdir 回到工作路径
cd $workdir
mkdir gene_structure_analysis
cd gene_structure_analysis
cp ../WRKY_domain_new_out_removed_redundant.txt .



#获得基因的在染色体上的外显子，CDS，UTR位置信息，用于绘制基因结构图

perl ../script/get_gene_exon_from_gff.pl -in1 WRKY_domain_new_out_removed_redundant.txt -in2 ../Arabidopsis_thaliana.TAIR10.41.gff3 -out gene_exon_info.gff

# 将上述的 gff文件放到 GSDS 网站即可绘制图形

################################基因定位到染色体############################################### （蜈蚣图）

所需文件

	基因家族 geneID

	染色体 长度信息

#cd $workdir 回到工作路径
cd $workdir
mkdir map_to_chr
cd map_to_chr
cp ../WRKY_domain_new_out_removed_redundant.txt .    #WRKY基因家族文件


#获得基因的在染色体上的位置信息，用于绘制染色体位置图,注意提取的是基因位置还是mRNA位置,以下代码是提取的 mRNA位置
perl ../script/get_gene_weizhi.pl -in1 WRKY_domain_new_out_removed_redundant.txt -in2 ../Arabidopsis_thaliana.TAIR10.41.gff3 -out mrna_location.txt

#获得基因组染色体长度：
samtools faidx ../Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

cp ../Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.fai .

#绘图参考：http://www.omicsclass.com/article/397


###############################blast方法 复制基因查找  及KAKS分析#################################

基因串联重复
	
	两个基因比对率 > 70% (相对于较长的基因)，且基因的比对相似性 > 70%
	两个基因在同一条染色体上，且位置 < 100 kb


所需文件

	基因家族 geneID

	基因家族 CDS 序列


#cd $workdir 回到工作路径
mkdir gene_duplication_kaks_blast
cd gene_duplication_kaks_blast
cp ../WRKY_domain_new_out_removed_redundant.txt .
cp ../WRKY_cds_confirmed.fa .
#blast建库,DNA序列,all vs all 比对，结果说明见：http://www.omicsclass.com/article/505
makeblastdb -in WRKY_cds_confirmed.fa -dbtype nucl -title WRKY_cds_confirmed.fa 
blastall -i WRKY_cds_confirmed.fa -d WRKY_cds_confirmed.fa -p blastn -e 1e-20  -m 8 -o WRKY_cds_confirmed_blast.out

#获取基因cds序列的长度：
samtools faidx WRKY_cds_confirmed.fa

perl ../script/KAKS_SHAIXUAN.pl -in1 WRKY_cds_confirmed.fa.fai -in2 WRKY_cds_confirmed_blast.out -out duplication_gene.out


# 对上面的结果进行去重复 
基因之间两两比对，会存在 AvsB BvsA 因此用下面的脚本去重复

perl ../clean_blastall.pl duplication_gene.out


###kaks 分析###

所需文件
	上面的 基因家族 复制基因


#提取成对基因的序列
echo "AT1G66600.1\nAT1G66560.1" >dupid.txt
perl ../script/get_fa_by_id.pl dupid.txt WRKY_cds_confirmed.fa dup_gene_paired1.fa

#多序列比对 clustalw
echo "1\ndup_gene_paired1.fa\n2\n9\n4\n\n1\ndup_gene_paired1.aln\ndup_gene_paired1.dnd\nX\n\n\nX\n" |clustalw

#格式转换axt  如果遇到报错not equal，可参考：http://www.omicsclass.com/article/700 （ KAKS 一次只能进行 一对基因的分析 ）
/biosoft/KaKs_Calculator2.0/src/AXTConvertor dup_gene_paired1.aln dup_gene_paired1.axt
/biosoft/KaKs_Calculator2.0/bin/Linux/KaKs_Calculator  -i dup_gene_paired1.axt -o dup_gene_paired1.kaks.result

#分离时间计算：http://www.omicsclass.com/question/896


###########################################以下blast为可选分析内容########################################################################

所需文件 
	
	从 NCBI 下载蛋白序列

#blastp比对寻找基因家族成员，WRKY部分
#参考文献：https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-018-4955-8
#NCBI上搜索WRKY蛋白序列：搜索条件：WRKY[title] NOT putative[title] AND plants[filter]


#blast比对首先建库
#makeblastdb -in WRKY_NCBI_pep.fasta -dbtype prot -title WRKY_NCBI_pep.fasta   #蛋白质序列
#
#blastp比对
#blastall -i ../Arabidopsis_thaliana.TAIR10.pep.all.fa -d WRKY_NCBI_pep.fasta -p blastp -e 1e-10 -b 1 -v 1 -m 8 -o ncbi_WRKY_blast.out 

利用上述的比对结果提取 序列间的局部匹配区域，利用匹配区域，进行 clustalw 多序列比对,然后通过 hmmbuild 构建物种的hmm文件 


#######################基因上游顺势作用原件分析#######################################

所需文件

	geneID 信息
	
	gff 文件

	基因组文件

#回到工作路径
cd $workdir
mkdir gene_promoter
cd gene_promoter
cp ../WRKY_domain_new_out_removed_redundant.txt .

#得到基因在染色体上的位置，此脚本会把基因组所有的序列读入内存，如果基因组较大，可能因为内存不足使脚本运行不成功，可以分染色体分开分析：
perl ../script/get_gene_weizhi.pl -in1 WRKY_domain_new_out_removed_redundant.txt -in2 ../Arabidopsis_thaliana.TAIR10.41.gff3 -out mrna_location.txt
#根据位置信息提取，promoter序列 1500
perl ../script/get_promoter.pl ../Arabidopsis_thaliana.TAIR10.dna.toplevel.fa mrna_location.txt promoter.fa

#生成 GSDS配置文件
cat WRKY_domain_new_out_removed_redundant.txt|awk 'BEGIN{OFS="\t"}{print $1,"0","1500","CDS","."}' >gene.bed
#生成feature文件
cat PlantCARE_9210__plantCARE/plantCARE_output_PlantCARE_9210.tab|grep "Arabidopsis"|awk -F"\t"  'BEGIN{OFS="\t"} {print $1,$4,$4+length($3),$2}'>feature.bed
