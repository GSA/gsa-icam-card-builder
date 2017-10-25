package LogParser;
# LogParser.pm v1.5

use strict;
use warnings;
use Exporter;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION     = 1.01;
@ISA         = qw(Exporter);
@EXPORT      = qw($TRUE $FALSE);
@EXPORT_OK   = qw(cook raw rawdelim clean output_value tlvparse);
%EXPORT_TAGS = ( DEFAULT => [qw(&cook)],
                 All     => [qw(&cook &raw &rawdelim &clean &output_value &tlvparse)]);

our $TRUE = 1;
our $FALSE = 0;

#
# Deconstructs a 200-bit raw FASC-N to cooked form.
#

sub cook($) {
	my $raw = shift;
	my @hexdigits = ();
	my $value;
	my @bits = ();
	my $bctr;
	my $bitstr = "";
	my $digits = "";
	my $length;

	@hexdigits = unpack "(A)*", $raw; 

	# Convert each hex digit to 4 0's and 1's and concatenate to into a string.

	map { $bitstr .= sprintf("%04b", hex($_)); } @hexdigits;

	# Create a bit array so we can read 5 bits at a time.

	@bits = split //, $bitstr;

	for ($length = scalar @bits, $value = 0, $bctr = 0; $bctr < $length - 5; $bctr++) {

		# The bits of each digit are reversed, with a trailing parity bit

		$value |= ((($bits[$bctr] == 1) ? 0x01 : 0x00) << ($bctr % 5));

		# Peek if we've done 5 bits, process, and roll over to another digit

		if (($bctr + 1) % 5 == 0) { 
			# Strip off high order (parity bit)
			$value = $value & 0xF; 
			# All of the field separators, etc., are > 9 so
			$digits .= $value if ($value < 10);
			# Ready for next digit
			$value = 0;
		}
	}

	return $digits
}

#
# Cleans a line of ASCII hex of spaces or colons
#

sub clean($) {
	my $line = shift;
	$line =~ s/:|\s//g;
	return $line;
}

#
# Prints out the value and writes it to the specified file 
#

sub output_value($$$$$$$) {
	my $start = shift;
	my $len = shift;
	my $name = shift;
	my $charsref = shift;
	my $octets = shift;
	my $hashableref = shift;
	my $base64cons = shift;
	my $end = $start + $len;
	my $outfile;
	my $encoded;
	my @chars = @$charsref;
	my $hashable = $hashableref;

	return if ($len == 0);

	open $outfile, ">$name" . ".bin" or die "$outfile" . ".bin" . ": $!";
	my $i;
	for ($i = $start; $i < $end; $i++) {
		if (defined $hashableref && defined $$hashable) {
			$$hashable .= chr($chars[$i]);
		}
		print $outfile chr($chars[$i]);
	}

	close $outfile;	

	# So that we can pipe this directly in to openssl asn1parse -inform pem ...

	if ($base64cons == 1) {
		$encoded = MIME::Base64::encode (substr ($octets, $start, $len));
		print $encoded, "\n";
	}
}

#
# Parses a TLV, returning the tag, length, and value
#

sub tlvparse ($) {
	my $charsref = shift;
	my @chars = @$charsref;
	my $len = 0;
	my $tag = $chars[0];
	my $lenbytes;
	shift @chars;
	if ($chars[0] & 0x80) {
		$lenbytes = $chars[0] & 0x7F;
		for (my $j = 0, $len = 0; $j < $lenbytes; $j++) {
			shift @chars;
			$len = (($len << 8) | $chars[0]);
		}
	} else {
		$len = $chars[0];
	}
	shift @chars;
	return ($tag, $len, @chars);
}

# Odd parity means set parity bit to 0 if odd number of bits, set 
# parity bit to 1 if even number of bits.

sub getParity($) {
	my $n = shift;
	my $retval = 0;
	my $b = 0;
	for ($n &= 0x0f, my $i = 0; $i < 4; $i++) {
		if (($n & (1 << $i)) > 0) {
			$b++;
		}
	}
	$retval = (($b % 2) == 0) ? 1 : 0;
	return $retval;
}

sub appendParity($) {
	my $v = shift;
	my $retval = 0;
	$retval = (($v << 1) | getParity($v)) & 0x1f;
	return $retval;
}

sub digitsWithParity($) {
	my $digits = shift;
	my @darray = split //, $digits;
	my @rarray = ();

	map { 
		push @rarray, appendParity($_);
	} @darray;

	return @rarray;
}

sub appendLrc($$) {
	my @bitctrs = (0, 0, 0, 0);
	my $i = 0;
	my $lrc = 0;
	map {
		for ($i = 4; $i >= 1; $i--) {
			if (($_ & (1 << $i)) != 0) {
				$bitctrs[$i - 1]++;
			}
		}
	} @{$_[0]};

	# Create a regular byte without the parity bit
	#
	# 7 = 11100

	for ($i = 3; $i >= 0; $i--) {
		$lrc |= ((($bitctrs[$i] % 2) == 1) ? (1 << $i) : 0);
	}

	$lrc = flipBits($lrc);
	$lrc = appendParity($lrc);

	push @{$_[0]}, $lrc;

	my $val = 0;
	for ($i = 4; $i >= 0; $i--) {
		$val = ($lrc & (1 << $i)) ? 1 : 0;
		push @{$_[1]}, $val;
	}
}

#
# Swaps bits so 0001 becomes 1000, etc.
# 

sub flipBits($) {
	my $num = shift;
	my $flipped = 0;
	for (my $i = 0; $i < 4; $i++) {
		if ($num & (1 << $i)) {
			$flipped |= (1 << (3 - $i));
		}
	}
	return $flipped;
}

sub raw($) {

	my $cooked = shift;
	my $ssent = 11;
	my $fsep  = 13;
	my $esent = 15;
	
	$ssent = appendParity($ssent);
	$fsep  = appendParity($fsep);
	$esent = appendParity($esent);
	
	my @bytes = ();
	
	# Start Sentinel
	push @bytes, $ssent;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 0, 4)); push @bytes, $fsep;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 4, 4)); push @bytes, $fsep;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 8, 6)); push @bytes, $fsep;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 14, 1)); push @bytes, $fsep;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 15, 1)); push @bytes, $fsep;
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 16, 10));
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 26, 1));
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 27, 4));
	map { push @bytes, $_ } digitsWithParity(substr($cooked, 31, 1));
	push @bytes, $esent;
	
	my $i;
	my @bits = ();
	my $val;
	my $x = 0;
	my $y = "";
	map { 
		$x = ((flipBits($_ >> 1)) << 1) | ($_ & 1);
		$y = sprintf "%05b", $x;
		map { push @bits, $_ } split //, $y;
	} @bytes;

	# LRC
	appendLrc(\@bytes, \@bits);
	my $fascn = "";
	
	for ($i = 0; $i <= 196; $i += 4) {
		my $v = 0;
		for ($v = 0, my $j = 0; $j < 4; $j++) {
			$v = ($v << 1) | $bits[$i + $j];
		}
		$fascn .= sprintf "%1X", $v;
	}

	return $fascn;

}

#
# Converts a readable FASC-N string to 200-bit raw delimited hex-ASCII formatted string
#

sub rawdelim($$$) {
	my $fascn = shift;
	my $delimiter = shift;
	my $ucase = shift;
	my $raw = raw($fascn);
	my @digits = split //, $raw;
	my $delimited = "";
	my $i;
	my $len = scalar @digits - 1;
	for ($i = 0; $i < $len; $i += 2) {
		$delimited .= ($digits[$i] . $digits[$i + 1]);
		$delimited .= $delimiter if ($i + 2 <= $len);
	}
	$ucase = $FALSE if (!defined $ucase || $ucase != $TRUE);
	my $retval = ($ucase == $TRUE) ? uc $delimited : lc $delimited;
	return $retval;
}

1;
