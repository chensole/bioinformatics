#script www.omicsclass.com
die "perl $0 <id><fa><OUT>" unless(@ARGV==3);

use Bio::SeqIO;
use Bio::Seq;

my$in  = Bio::SeqIO->new(-file => "$ARGV[1]" ,
                               -format => 'Fasta');
my$out = Bio::SeqIO->new(-file => ">$ARGV[2]" ,
                               -format => 'Fasta');
my%keep=();

open IN ,"$ARGV[0]" or die "$!";
while(<IN>){
        chomp;
        next if /^#/;
        my@tmp=split(/\s+/);
	$keep{"$tmp[1].1"}=1;
}
close(IN);
while ( my $seq = $in->next_seq() ) {
            my($id,$sequence,$desc)=($seq->id,$seq->seq,$seq->desc);
            if( exists $keep{$id}){
            	$out->write_seq($seq); 
	    }     
}
$in->close();
$out->close();

