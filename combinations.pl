#!usr/bin/perl;

#INPUT: CATAGORY FILE
#				SEQ DEFINITION FILE
#SEE HARD CODED EXAMPLES FOR AMINOACID CATAGORIES AND SEQ DEFINITION BELOW.
#OUTPUT:	GENERATES COMBINATIONS OF AMINOACIDS OR ANY GIVEN SYMBOLS BASED ON SEQ DEFINITION AND CATAGORY FILE.
#					THESE FILES END WITH .comb EXTENSION.


#Amino acid catagory file
my $aaCatFile = "aaCat";

#Sequence definition file, can contain multiple seq definitions separated by new line
my $seqDefFile = "peptideSeqDef";

my $outDir = "testCombinations";

=head
%aaCat =
(
	'X' => ['A','T'],
	'Y' => ['G','C']
);

@seqDef = ('X','Y','Y','X');
=cut

my %aaCat = ();

open(AACAT,$aaCatFile)||die"$!\nCan not open AACAT.\n";
map{ if($_=~m/(.)\s=\s(.*)\n*/)	{$aaCat{$1} = [split(",",$2)];} }<AACAT>;
#map{print "$_ => @{$aaCat{$_}}\n";}keys %aaCat;
close(AACAT);

open(SEQDEF,$seqDefFile)||die"$!\nCan not open SEQDEF.\n";

my @seqDefArray = ();
map{chomp $_; push @seqDefArray,[split("",$_)]}<SEQDEF>;
#map{print "@{$_}\n";}@seqDefArray;
close(SEQDEF);

mkdir($outDir);

my @seqDef = ();
my $cnt = 1;
foreach (@seqDefArray)
{
	if(trim(join("",@{$_})) ne "")
	{
		print "Generating combinations for sequence definition: ",join("",@{$_})," ...\n";
		generateCombinations($outDir,$_);
	}
	else{print "Wrong sequence definition found at row $cnt.\n";}
	$cnt++;

}


sub generateCombinations
{
	my $outDir = $_[0];
	@seqDef = @{$_[1]};

	my $outFile = join("",@seqDef).".comb";
	open(OUT,">".$outDir."/".$outFile)||print "Can not open OUT.\n";

	print OUT "#SEQDEF: ",join("",@seqDef),"\n#SEQLENGTH: ".@seqDef."\n";

	my $index = 0;
	recurse($index);

	close(OUT);
	#print "-----\n";
}

sub recurse
{
	my $index = $_[0];
	my $i;

	for($i=0;$i<@{$aaCat{$seqDef[$index]}};$i++)
	{
		push(@seq,${$aaCat{$seqDef[$index]}}[$i]);

		if($index<$#seqDef){recurse($index+1);}
		else{print OUT join("",@seq),"\n";}

		pop(@seq);
	}
}

sub trim
{
	my $str = $_[0];
	$str=~s/^\s*(.*)/$1/;
	$str=~s/\s*$//;
	return $str;
}
