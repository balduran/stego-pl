#!/usr/bin/perl

#for ($count = 10;$count !=150; $count++){
#	printf "%d\t%08b\t%s\n",$count,$count,chr($count);	
#}
open (MESS, "$ARGV[0]") or die "can't open message file named $ARGV[0]";
while (<MESS>){

	
	
	#print $secret."\n";
	@mess = split (//,$_);
	foreach $char(@mess){
		$encode = sprintf( "%08b",ord($char));
		$secret .= $encode;
	}
	#while ( defined ($tem = shift @mess) ){printf "$tem\t%b\n",ord($tem);}
	#$messlen += length($_);
	$messlen = length ($secret);
	#print length($mess);
	#$mess = $mess.$_;
	
}
close MESS;
#print $messlen;
open (FH , "> key");
print "message length:$messlen\n";
$messword = $messlen /8;
print "message words: $messword\n";
while($messlen){
	my $gen = int (rand(10));
	if ($gen <5){
		print FH 0;
	}else{
		print FH 1;
		$messlen--;
	}
	
}
close FH;
#my $loop = 100;
#if($ARGV[0]){$loop = $ARGV[0]}
#if($ARGV[1]){
#	open(FH , "> $ARGV[1]");
#}else{
#	open (FH ,"> key.txt");
#}
#
#foreach (0.. $loop){
#	my  $gen = int(rand(10))."\n";
#	if ($gen <5){
#		print FH 0;
#	}else{
#		print FH 1;
#	}
#}
#close FH;