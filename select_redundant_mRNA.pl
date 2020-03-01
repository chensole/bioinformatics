die "perl $0 <mRNA2genefile> <idlist> <outfile>" unless(@ARGV==3);



open IN ,"$ARGV[0]" or die "$!";
open OUT,">$ARGV[2]" or die "$!";
my%mRNA2geneData;
my%mRNA2gene;

my%gene2mRNA;

print OUT "#geneID\tmRNAID\n";
while (<IN>){
	chomp;
	if(/^#/){
		
		next;
		
	}

	my@tmp=split(/\t/);
	$mRNA2gene{$tmp[0]}=$tmp[1];
	$mRNA2geneData{$tmp[0]}=$_;
	$gene2mRNA{$tmp[1]}{$tmp[0]}=1;

}

close(IN);

open IN,"$ARGV[1]" or die "$!";
my%uniqGene;

while (<IN>){
	chomp;
	next if /^#/;
	my@tmp=split(/\s+/);
	$uniqGene{$mRNA2gene{$tmp[0]}}{$tmp[0]}=1;

}
close(IN);


for my$geneID(keys %uniqGene){
	
	my$transcriptIDNumber=scalar keys %{$uniqGene{$geneID}};
	my@transIDs=keys %{$uniqGene{$geneID}};
	
	print OUT "$geneID\t".join("\t",sort{$a cmp $b} @transIDs)."\n";
}

close(OUT);
