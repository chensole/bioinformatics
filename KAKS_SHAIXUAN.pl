use Getopt::Long;
my %opts;
use Data::Dumper;
GetOptions (\%opts,"in1=s","in2=s","out=s","h"); 
if (! defined($opts{in1}) ||! defined($opts{in2})||! defined($opts{out}) || defined($opts{h})){
	&USAGE;
}
open (IN1,"$opts{in1}") || die "open $opts{in} failed\n";
open (IN2,"$opts{in2}") || die "open $opts{ina} failed\n";
open (OUT,">$opts{out}") || die "open $opts{out} failed\n";
 my %cds_length;
while(<IN1>){
	chomp;
	my @line = split("\t",$_);
	$cds_length{$line[0]}= $line[1];
	#print "$cds_length{$line[0]}\n";
} 

while( <IN2>){
	
		chomp($_);
		my @line1 = split ("\t",$_);
		#print @line1;
		#print "\n";
		my $max_length = $cds_length{$line1[0]} > $cds_length{$line1[1]} ? $cds_length{$line1[0]}:$cds_length{$line1[1]};
		if(($line1[0] ne $line1[1]) && ($line1[2] > 70 )&& ($line1[3] > 0.70*$max_length)){
			print OUT $_."\t$max_length\n";
		
		}
		#print $cds_length1{$line1[0]};
	
}


close(IN1);
close(IN2);
close(OUT);
sub USAGE {
       print "usage: perl $0 -in1 cds_length   -in2 result.txt -out shaixuan_result.txt";
	exit;
}