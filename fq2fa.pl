#!usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Basename;

#---------------------------------------- 模板 ----------------------------------------------------------------
#定义命令行参数
my $file;
my $help;
my $outFile = "";

GetOptions(
		"i=s" => \$file,
		"h|help" => \$help,
		"o|outputfile" => \$outFile,
);

#检查参数

#定义help文档
sub prtHelp {
	print "\n$0 options:\n\n";
	print "### Input reads (FASTQ) (Required)\n";
	print "  -i <FASTQ read file>\n";
	print "    Read file in FASTQ format\n";
	print "\n";
	print "### Other options [Optional]\n";
	print "  -h | -help\n";
	print "    Prints this help\n";
	print "  -o | -outputFile <Output file name>\n";
	print "    Output will be stored in the given file\n";
	print "    default: By default, file will be stored where the input file is\n";
	print "\n";
}


sub prtError {
	my $msg = $_[0];
	print STDERR "+======================================================================+\n";
	printf STDERR "|%-60s|\n", "  Error:";	
	printf STDERR "|%-70s|\n", "       $msg";
	print STDERR "+======================================================================+\n";
	prtUsage();
	exit;
}


#定义usage

sub prtUsage {
	print "\nUsage:perl $0 <options>";
	prtHelp();
} 


if (defined($help)) {
	prtUsage();
	exit;
}

if (!defined($file)) {
	prtError("NO input files are provided");
}

#---------------------------------------- 模板 ----------------------------------------------------------------





#-----------------------------------------主程序 ---------------------------------------------------------------
	#自定义输出路径

my ($filename,$filepath) = fileparse ($file);
$outFile = $file . "_fasta" if ($outFile eq "");

open I, "<$file" or die "can not open file:$file\n";
open OF, ">$outFile" or die "can not open file:$outFile\n";

sub formatseq {
	my $seq = $_[0];
	$seq =~ s/(\w{50})/$1\n/g;
	return $seq;
}
#-----------------------------------------主程序 ---------------------------------------------------------------



#下面这是修改前的源代码

#-----------------------------------------------------------------------------#
#sub foramtseq {
#	my $seq = $_[0];
#	my $newseq = "";
#	my $ch = 60;
#	for (my $i = 0; $i <length $seq; $i += $ch) {
#		$newseq .= substr($seq,$i,$ch) . "\n";
#	}
#	chomp $newseq;
#	return $newseq;
#}
#-----------------------------------------------------------------------------#


while (defined(my $line = <I>)) {
	chomp $line;
	my $id = $line;
	$id =~ s/^\@//;
	print OF ">$id\n";
	my $seq = <I>;
	print OF formatseq($seq);
	<I>;
	<I>;
}












