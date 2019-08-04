
# mcscanx 物种内基因家族共线性分析

所需文件

cds 文件 
gff 文件
pep 文件

基因家族 ID 信息

#www.omicsclass.com
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/arabidopsis_thaliana/cds/Arabidopsis_thaliana.TAIR10.cds.all.fa.gz
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.39.gff3.gz
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-39/fasta/arabidopsis_thaliana/pep/Arabidopsis_thaliana.TAIR10.pep.all.fa.gz
#gunzip *gz

#mkdir mcscan
#perl get_gene_position.pl Arabidopsis_thaliana.TAIR10.39.gff3 AT.gff
#sed -i 's#gene:##' AT.gff
#perl get_fa_by_id.pl AT.gff Arabidopsis_thaliana.TAIR10.pep.all.fa pep.fa
#sed -i 's#\.1##' pep.fa
makeblastdb -in pep.fa  -dbtype prot -title pep.fa
blastall -i pep.fa -d pep.fa -e 1e-10  -p blastp  -b 5 -v 5 -m 8 -o mcscan/AT.blast
cp AT.gff mcscan/AT.gff

/biosoft/MCScanX/MCScanX/MCScanX mcscan/AT

# 编辑物种染色体信息
wget http://chibba.pgml.uga.edu/mcscan2/examples/family.ctl


# 基因家族 geneID 文件
wget http://chibba.pgml.uga.edu/mcscan2/examples/MADS_box_family.txt

sed -i 's#at##g' family.ctl

# 绘制图形

cd /biosoft/MCScanX/MCScanX/downstream_analyses 
java family_circle_plotter -g /home/manager/share/mcscan/mcscan/AT.gff -s /home/manager/share/mcscan/mcscan/AT.collinearity -c /home/manager/share/mcscan/family.ctl -f /home/manager/share/mcscan/MADS_box_family.txt -o /home/manager/share/mcscan/mcscan/MADS.circle.PNG


# 分析基因家族的串联重复 以及 基因组内所有串联重复信息
cd /biosoft/MCScanX/MCScanX/downstream_analyses
perl detect_collinearity_within_gene_families.pl -i /home/manager/share/mcscan/MADS_box_family.txt -d /home/manager/share/mcscan/mcscan/AT.collinearity -o /home/manager/share/mcscan/mcscan/MADS.collinear.pairs

# 由于绘制的圈图不是很美观，因此我们会对分析结果利用 circos 进行图形的绘制
