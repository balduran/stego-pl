#!/usr/bin/perl
use GD;

unless ($ARGV[0]){
die "Usage: decode stegoImage {key.txt}";
}
$img = GD::Image->newFromGif($ARGV[0]) || die"can't open file";

if (!$ARGV[1]){
	#print "!!!";
	$key = 1x800;
	@key = split (//,$key);	
}else{
	if (open KEY , "$ARGV[1]"){
		$key = <KEY>;
		@key = split (//,$key);
		close KEY;
	}else{
		$max = 3 * $img->width() * $img->height();
		if ( 8 * $ARGV[1] > $max ){
			$key =1x$max;
		}else{
	  		$key =1x8x$ARGV[1];
	   	}
    	#	print length($key);
    	@key = split(//,$key);
    }
}

#print $img->width()."x".$img->height()."\n" ;


@mess =();
foreach $intX (1 .. $img->width()){
	foreach $intY (1 .. $img->height()){

		$pixel = $img->getPixel($intX,$intY);
#		print $intX.":".$intY.":".$pixel."\n" unless $intY <= 370 ;
		($r,$g,$b) = $img->rgb($pixel);

		#print $intX."-".$intY."--";
		#printf ("%08d", $r);
		if (defined($key = shift @key)){
			if ($key){
				my $lsb = $r % 2;
				push @mess ,$lsb;
			}
		}
		if (defined($key = shift @key)){
			if ($key){
	                        my $lsb = $g % 2;
        	                push @mess ,$lsb;
			}
                }
		if (defined($key = shift @key)){
			if ($key){
	                        my $lsb = $b % 2;
	                        push @mess ,$lsb;
			}
                }

		#print $r & 1 ;
		#print $g & 1 ;
		#print $b & 1 ;
		#print "\n";

		#$img -> setPixel($intX,$intY,$pixel2);

#		print $intX.".".$intY.":".$r."\t".$g."\t".$b."\n";
#		$grey = ($r+$g+$b);
#		$pixel2=$img->colorResolve($grey,$grey,$grey);
		#warn "Everything's coming up roses.\n" if $pixel2 >= 0;
#		$img->setPixel($intX,$intY,$pixel2);

	}
}
#print @mess;
$mess = join ("", @mess);
#print $mess;
$start = 0;
$offset = 8;

while ($start+$offset <= length($mess)){
	$chr = substr ($mess, $start,$offset );
	$start += $offset;
	print chr ($decimal = ord(pack('B8', $chr)));  
}
#open(OUT,"> output.gif") || die;
#binmode OUT;
#print OUT $img->gif();
#close OUT;
