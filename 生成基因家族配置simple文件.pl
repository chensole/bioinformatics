#!usr/bin/perl -w
use strict;

my $file = shift;

open I,$file or die "$!";



while (defined (my $line = <I>)) {

	chomp $line;

	my @tmp = split(/\s+/,$line);

	print "#FF0000*$tmp[0]\t$tmp[0]\t$tmp[1]\t$tmp[1]\t$tmp[2]\t+\n";


}
