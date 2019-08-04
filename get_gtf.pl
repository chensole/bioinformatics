use Getopt::Long;
my %opts;
use Data::Dumper;
GetOptions (\%opts,"in1=s","in2=s","out=s","h"); 
if (! defined($opts{in1}) ||! defined($opts{in2})||! defined($opts{out}) || defined($opts{h})){
	&USAGE;
}
open (IN1,"$opts{in1}") || die "open $opts{in1} failed\n";
open (IN2,"$opts{in2}") || die "open $opts{in2} failed\n";
open (OUT,">$opts{out}") || die "open $opts{out} failed\n";
my%gffs;
while (<IN1>) {
	  chomp;
	  my@b=split,$_;
	  $keys= $b[0];
	#  print "$keys\n";
	 $values= $b[0];
	# print "$values";
     $gffs{$keys} = $values;
   #print "$gffs{$_}\n";
}
#print Dumper(\%gffs);
while (<IN2>) {
	 chomp;
          my @a=split /\t/,$_;
		
		 	$a[8]=~ m/transcript_id "([^\"]*)/;
		 	 	$id1=$1;
		#print "$id1\t";
		  if ( exists  $gffs{$id1} ) {
		 # print "aaa/n";
		#print OUT join ("\t",@a)."\n";
		print OUT "$a[0]\t$a[1]\t$a[2]\t$a[3]\t$a[4]\t$a[5]\t$a[6]\t$a[7]\ttranscript_id \"$gffs{$id1}\";\n";
		  }
		
		 
		 }

close OUT;
close IN1;
close IN2;
sub USAGE {
       print "usage: perl test1.pl -in1  gene_id.txt  -in2  基因组gtf文件  -out 结果文件";
	exit;
}