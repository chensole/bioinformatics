#!/usr/bin/perl -w
use strict;
use Cwd qw(abs_path getcwd);
use Getopt::Long;
use Data::Dumper;


die "perl $0 <gff> <outfile>" unless(@ARGV==2);



my$gff=$ARGV[0];
my%gene=();
my%gene_region=();
my%mRNA2Gene=();
open IN,"$gff" or die "$!";
open OUT ,">$ARGV[1]" or die "$!";
print OUT "#mRNA_ID\tgene_ID\tchr\tstart\tend\tstrand\n";
while(<IN>){
	chomp;
	next if (/^#/);
	my@tmp=split(/\t/);
	

	
	if($tmp[2] =~/^gene/){
		my($id)=($tmp[8]=~/ID=([^;]+)/);
		$gene{$id}=1;
		$gene_region{$id}=[$tmp[0],$tmp[3],$tmp[4],$tmp[6]];
		
		
		#print "gene:$id\n";
		#my$gene_chr->{$id}=$tmp[0];
	}
	if($tmp[2] =~/mRNA|transcript/i){
		my($id)=($tmp[8]=~/ID=([^;]+)/);
		my($pid)=($tmp[8]=~/Parent=([^;]+)/);
		print OUT "$id\t$pid\t";
		
		if(exists $gene{$pid}){
			print OUT "$tmp[0]\t$tmp[3]\t$tmp[4]\t$tmp[6]\n";
		}
		#print "mRNA:$id\n";
	}
}

close(IN);
close(OUT);


	

