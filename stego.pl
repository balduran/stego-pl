#!/usr/bin/perl
use GD;

unless ($ARGV[1]){
	die "usage: stego.pl Cover.gif Message.txt {Key.txt}"
}

#foreach (0..$#ARGV) {print "$ARGV[$_]\n";}

$img = GD::Image->newFromGif($ARGV[0]) || die"can't open file";
#$stego = $img -> clone();

open(MESS , "$ARGV[1]") or die "can't open message";
while(<MESS>){
	@mess = split(//,$_);
	foreach $char(@mess){
		$encode = sprintf( "%08b",ord($char));
		$secret .= $encode;
	}
	#print $secret."\n";
}
close MESS;
@mess = split(//,$secret);

if (open (KEY , "$ARGV[2]") ){
	$key = <KEY>;
	close KEY;
}else{
	$key = "1" x length($secret);
	#print length($mess);
}
@key = split (//,$key);
#print $key;
 
#print $img->width()."x".$img->height()."\n" ;
my $total = $img->width()*$img->height()*3;
print "Q=".length($secret)/$total."\n";
foreach $intX (1 .. $img->width()){
	foreach $intY (1 .. $img->height()){

		$pixel = $img->getPixel($intX,$intY);
#		print $intX.":".$intY.":".$pixel."\n" unless $intY <= 370 ;
		($r,$g,$b) = $img->rgb($pixel);
		#printf("%08d\t", $r);
		if (defined($key = shift @key)){
			if ($key){
				my $mess = shift @mess;
				my $lsb = $r % 2;
				if ($lsb  ^ $mess){
					if ($lsb){$r--;}else{$r++;}
				}
			}
		}
		if (defined( $key = shift @key)){
			if ($key){
				$mess = shift @mess;
        		        $lsb = $g % 2;
                		if ($lsb  ^ $mess){
                        		if ($lsb){$g--;}else{$g++}
	                	}
			}
		}
		if (defined ( $key = shift @key)){
			if ($key){
				$mess = shift @mess;
        		        $lsb = $b % 2;
		                if ($lsb  ^ $mess){
                        		if ($lsb){$b--;}else{$b++}
                		}
			}
		}
		#printf("\t%08d\n",$r);
		#if ($r%2) {$r--};
		#print $intX."-".$intY."--";
		#printf("%08d\n",$r);
		#if ($g%2) {$g--};
		#if ($b%2) {$b--};
		
		$pixel2 = $img -> colorResolve($r,$g,$b);
		$img -> setPixel($intX,$intY,$pixel2);

#		print $intX.".".$intY.":".$r."\t".$g."\t".$b."\n";
#		$grey = ($r+$g+$b);
#		$pixel2=$img->colorResolve($grey,$grey,$grey);
		#warn "Everything's coming up roses.\n" if $pixel2 >= 0;
#		$img->setPixel($intX,$intY,$pixel2);

	}
}
open(OUT,"> output.gif") || die;
binmode OUT;
print OUT $img->gif();
close OUT;
