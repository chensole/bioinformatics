
use strict;
use List::Util qw(any);

my $f1 = shift;
my $f2 = shift;
my $f3 = shift;

my (@a1,@a2);

open I1,$f1 or die "$!";
open I2,$f2 or die "$!";
open I3,$f3 or die "$!";

while (defined(my $line = <I1>)) {
	chomp $line;

	push @a1,$line;


}
while (defined(my $line = <I2>)) {
	chomp $line;

	push @a2,$line;


}
while (defined(my $line = <I3>)) {
	chomp $line;

	next if $line =~ /^#/;
		
		my @tmp = split(/\s+/,$line);
		
		if ((any {/$tmp[0]/} @a1) and (any {/$tmp[1]/} @a2)) {

			print $line."\n";
		}			

	}
	
		










