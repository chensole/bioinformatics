#北京组学生物科技有限公司
#email: huangls@biomics.com.cn

die "perl $0 <hmmoutfile> <fa> <OUT> <E-value>" unless ( @ARGV == 4 );
use Math::BigFloat;
use Bio::SeqIO;
use Bio::Seq;
$in = Bio::SeqIO->new(
	-file   => "$ARGV[1]",
	-format => 'Fasta'
);
$out = Bio::SeqIO->new(
	-file   => ">$ARGV[2]",
	-format => 'Fasta'
);
my %keep = ();
open IN, "$ARGV[0]" or die "$!";

while (<IN>) {
	chomp;
	next if /^#/;

	my @a = split /\s+/;
	next if $a[6] > $ARGV[3];
	my @b = ( $a[17], $a[18] );
	my $keys = $a[0];
	if ($a[9]==1 and !exists $keep{$keys} ) { #提取序列中第一个结构域所在的序列
		$keep{$keys} = \@b;

	}
}
close(IN);
while ( my $seq = $in->next_seq() ) {
	my ( $id, $sequence, $desc ) = ( $seq->id, $seq->seq, $seq->desc );

	if ( exists $keep{$id} ) {
		my $subseq = $seq->subseq( $keep{$id}->[0], $keep{$id}->[1]); #截取序列
		my $newseqobj = Bio::Seq->new(
			-seq  => $subseq,
			-desc => "domain:$keep{$id}[0]-$keep{$id}[1]",
			-id   => "$id",
		);

		$out->write_seq($newseqobj);
	}
}
$in->close();
$out->close();
