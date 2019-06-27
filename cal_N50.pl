#/usr/bin/perl -w
use strict;
use List::Util qw(sum min max);
use Getopt::Long;
use File::Basename;

# Parameter variables
my $file;
my $helpAsked;
my $outfile = "";

GetOptions(
			"i=s" => \$file,
			"h|help" => \$helpAsked,
			"o|outputFile=s" => \$outfile,
		  );
if(defined($helpAsked)) {
	prtUsage();
	exit;
}
if(!defined($file)) {
	prtError("No input files are provided");
}

my ($fileName, $filePath) = fileparse($file);
$outfile = $file . "_n50_stat" if($outfile eq "");




open IN, "$file" or die "$!";
open O,">$outfile" or die "$!";
my @len;
my $totseq;

sub median (\@){

	my @x = sort {$a <=> $b} @{$_[0]};
	my $len = scalar @x;
	my $median;	
	if ($len % 2 == 0) {
		$median = ($x[$len/2 - 1] + $x[$len/2]) / 2;
	
	}else {
	
		$median = $x[($len + 1) / 2];
	}
	return $median;
}


my $As = 0;
my $Ts = 0;
my $Gs = 0;
my $Cs = 0;
my $Ns = 0;

#-------------------------------------- 子程序 -----------------------------------------------

sub basecount (\$){
	my $seq = ${$_[0]};
	
	my $tAs += $seq =~ s/A/A/gi;
	my $tGs += $seq =~ s/G/G/gi;
	my $tCs += $seq =~ s/C/C/gi;
	my $tTs += $seq =~ s/T/T/gi;
	my $Ns = (length $seq) - $tAs - $tTs - $tCs - $tGs; 
	$As += $tAs;
	$Ts += $tTs;
	$Gs += $tGs;
	$Cs += $tCs;

}

##计算N50

#### 从大到小排序--> for循环相加,直到>= $ /2

sub calN50 (\@$){
	my @x = sort {$b <=> $a} @{$_[0]};
	my $n = $_[1];
	my $totlen = sum(@x);
	my ($tot,$n50) = (0,0);
	for (my $i = 0;$i <@x;$i++) {
		$tot += $x[$i];
		if ($tot >= $totlen*$n/100) {
			$n50 = $x[$i];
			last;
		}
		
	
	}
	return $n50;
 }

sub prtHelp {
	print "\n$0 options:\n\n";
	print "### Input reads/sequences (FASTA) (Required)\n";
	print "  -i <Read/Sequence file>\n";
	print "    Read/Sequence in fasta format\n";
	print "\n";
	print "### Other options [Optional]\n";
	print "  -h | -help\n";
	print "    Prints this help\n";
	print "  -o | -outputFile <Output file name>\n";
	print "    Output will be stored in the given file\n";
	print "    default: By default, N50 statistics file will be stored where the input file is\n";
	print "\n";
}

sub prtError {
	my $msg = $_[0];
	print STDERR "+======================================================================+\n";
	printf STDERR "|%-70s|\n", "  Error:";
	printf STDERR "|%-70s|\n", "       $msg";
	print STDERR "+======================================================================+\n";
	prtUsage();
	exit;
}

sub prtUsage {
	print "\nUsage: perl $0 <options>\n";
	prtHelp();
}


#----------------------------- 主程序 -----------------------------------------------

while (defined(my $line = <IN>)) {
	chomp $line;
	if ($line =~ /^>/) {
		my $genenID = $line;
		my $seq = <IN>;
		chomp $seq;
		push @len,length $seq;
		$totseq .= $seq;
	}
	
}
#print "@len\n";
my $totlen = sum(@len);
my $totreads = scalar @len;
my $min = min(@len);
my $max = max(@len);
my $avg = sprintf "%0.2f", $totlen/$totreads;
my $median = median(@len);
#print "$totseq\n";
#print "$median\n";

basecount($totseq);
my $n25 = calN50(@len,25);
my $n50 = calN50(@len,50);
my $n75 = calN50(@len,75);
my $n90 = calN50(@len,90);
my $n95 = calN50(@len,95);


printf O "%-25s %d\n", "Total sequences",$totreads;
printf O "%-25s %d\n", "total base",$totlen;
printf O "%-25s %d\n" , "Min sequence length", $min;
printf O "%-25s %d\n" , "Max sequence length", $max;
printf O "%-25s %0.2f\n", "Average sequence length", $avg;
printf O "%-25s %0.2f\n", "Median sequence length", $median;
printf O "%-25s %d\n", "N25 length", $n25;
printf O "%-25s %d\n", "N50 length", $n50;
printf O "%-25s %d\n", "N75 length", $n75;
printf O "%-25s %d\n", "N90 length", $n90;
printf O "%-25s %d\n", "N95 length", $n95;
printf O "%-25s %0.2f %s\n", "As", $As/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "Ts", $Ts/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "Gs", $Gs/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "Cs", $Cs/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "(A + T)s", ($As+$Ts)/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "(G + C)s", ($Gs+$Cs)/$totlen*100, "%";
printf O "%-25s %0.2f %s\n", "Ns", $Ns/$totlen*100, "%";

print "N50 Statistics file: $outfile\n";











