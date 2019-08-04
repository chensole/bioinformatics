print "perl $0   <id_list>  <data_file> <out_file>\n" and die unless(@ARGV==3);

open IN,"$ARGV[0]" or die "$!";

my%t;
my$head;
while(<IN>){
	chomp;
	my@tmp=split(/\s+/);
	
	
	$t{$tmp[0]}=1;
}

close(IN);

open IN,"$ARGV[1]" or die "$!";

open OUT,">$ARGV[2]" or die "$!";
while(<IN>){
	chomp;
	if (/^#/){
		print OUT "$_\n";
		next ;
	}

	my@tmp=split(/\s+/);

	if(exists $t{$tmp[0]}){
		print OUT "$_\n";
	}else{
		#print  "$tmp[0]\n";
	}
}
close(IN);

close(OUT);
