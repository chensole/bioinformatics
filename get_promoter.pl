die "perl $0 <genome.fa> <weizhi.txt> <OUT> " unless(@ARGV==3 );
use Math::BigFloat;
use Bio::SeqIO;
use Bio::Seq;
$in = Bio::SeqIO -> new(-file => "$ARGV[0]",
                                  -format => 'Fasta');
$out = Bio::SeqIO -> new(-file => ">$ARGV[2]",
                                  -format => 'Fasta');
my %keep=() ;
open IN,"$ARGV[0]" or die "$!";
my%ref=();
while ( my $seq = $in->next_seq() ) {
     my($id,$sequence,$desc)=($seq->id,$seq->seq,$seq->desc);
     
         $ref{$id}=$seq;

}

$in->close();

open IN,"$ARGV[1]" or die "$!";
while (<IN>) {
		chomp;
		next if /^#/;
		my @a= split /\t/;
		my$seq=0;
		if(exists $ref{$a[1]}){
			$seq=$ref{$a[1]};
		}else{
			print "chromosome $a[1] not in reference file\n";
			next;
		}
		
		print "$a[1]";
     if( $a[4]  eq "-" ){
		      $start=  $a[3]+1;
			  $end=$a[3]+1500;
			  if($end>$seq->length){
              	print "Note: $seq->id: upstream don't have enough sequence to cut for $a [0] and skiped\n";
              	next;

			  }

              my$seq_string=$seq->subseq($start,$end);
              my$newseqobj1=Bio::Seq -> new(-seq => $seq_string,
				-id => "$a[0]"
               ) ;
     	       my$reseq = $newseqobj1 ->revcom();
     	       $out->write_seq($reseq);      	
     }elsif ( $a[4]  eq "+" ){
              $start=  $a[2]-1500;
              if ($start<0){
              	print "Note: $seq->id: upstream don't have enough sequence to cut for $a[0] and skiped\n";
              	next;
              }
			  $end=$a[2]-1;

               my$seq_string=$seq->subseq($start,$end);
           
               my$newseqobj1=Bio::Seq -> new(-seq => $seq_string,
               -id => "$a[0]"
                   
               ) ;
     	      
     	       $out->write_seq($newseqobj1);          
     }

}
close (IN);
$in->close();
$out->close();
