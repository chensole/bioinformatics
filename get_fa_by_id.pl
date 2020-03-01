#北京组学生物科技有限公司
#email: huangls@biomics.com.cn

die "perl $0 <idlist> <fa> <OUT>" unless ( @ARGV == 3 );
use Math::BigFloat;
use Bio::SeqIO;
use Bio::Seq;

#读入蛋白序列
$in = Bio::SeqIO->new(
	-file   => "$ARGV[1]",
	-format => 'Fasta'
);

#输出蛋白序列：
$out = Bio::SeqIO->new(
	-file   => ">$ARGV[2]",
	-format => 'Fasta'
);

#读取需要提取基因ID
my %keep = ();
open IN, "$ARGV[0]" or die "$!";

while (<IN>) {
	chomp;
	next if /^#/;
	my @a = split /\s+/;
	$keep{$a[0]}=1;
}
close(IN);

#输出想要的基因的序列
while ( my $seq = $in->next_seq() ) {
	my ( $id, $sequence, $desc ) = ( $seq->id, $seq->seq, $seq->desc );

	if ( exists $keep{$id} ) {
		$out->write_seq($seq);
	}
}
$in->close();
$out->close();