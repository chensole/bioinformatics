use Getopt::Long;
my %opts;
use Data::Dumper;
GetOptions( \%opts, "in1=s", "out=s", "h" );
if ( !defined( $opts{in1} ) || !defined( $opts{out} ) || defined( $opts{h} ) ) {
	&USAGE;
}
open( IN1, "$opts{in1}" )  || die "open $opts{in1} failed\n";
open( OUT, ">$opts{out}" ) || die "open $opts{out} failed\n";

while (<IN1>) {
	chomp;
	my @a = split /\t/, $_;
	if ( $a[2] eq "gene" ) {
		#if ($a[2] eq "mRNA") {
		$a[8] =~ m/ID=([^;]*)/;    #注意这里匹配基因的ID信息
		$id = $1;

		print OUT "$a[0]\t$a[3]\t$a[4]\t$id\t$a[7]\t$a[6]\n";

	}

}
close OUT;
close IN1;
close IN2;

sub USAGE {
	print "usage: perl $0 -in1  gff   -out gene_location.bed ";
	exit;
}
