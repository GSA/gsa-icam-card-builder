#!/usr/bin/perl
#
## txtchuid.pl v1.5
# vim: set ts=2 nowrap
# 
# Usage: ./txtchuid.pl <File containing CHUID in ASCII Hex> 
#
# Handles files with CHUID represented by hex values with space, quote or no delimiters such as:
#
# 30:19:D4:E7:39:DA:73:9C:ED:39:CE:73:9D:A1 or
# 30 19 D4 E7 39 DA 73 9C ED 39 CE 73 9D A1 or
# 3019D4E739DA739CED39CE739DA1
#

use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&clean &output_value);
use MIME::Base64;
use Digest::SHA qw(sha256_hex);
use File::Basename;

my $infile;
my $octets;
my @chars = ();
my $charslen = 0;
my $hashable = "";

# Check args

if (@ARGV < 1) {
	die "Usage: $0 <filename>\n";
}

# Make sure input file exists

-f $ARGV[0] or die "$ARGV[0]: $!";

my $bname = ($ARGV[0] =~ m/(\..*$)/) ? basename $ARGV[0], $1 : basename $ARGV[0];

# Open or die

open ($infile, "<$ARGV[0]") or die "$ARGV[0]: $!";

# Read the file in as single line.  If the file has multiple lines then
# either concatenate the lines in the file or change this to read everything
# into a single string ($line) using slurp().

my $line = <$infile>;
chomp $line;

# Strip out the delimiters and convert to a string.

$octets = pack ("H*", clean ($line));

close $infile;

# Output CHUID fields

@chars = unpack('C*', $octets);
$charslen = scalar @chars;

my $i = 0;
my $j = 0;
my $tag;
my $len = 0;
my $container_flag = 0;

#
# Deal with TLV header, if present
#
if ($chars[$i++] == 0x53) {
	$container_flag = 1; 
	if ($chars[$i] & 0x80) { # long form
		my $k = 0; 
		my $lenbytes = $chars[$i++] & 0x7F;
		for ($k = 0; $k < $lenbytes; $k++) {
			$len = ($len << 8) | $chars[$i++];
		}
	} else {
		$len = $chars[$i++] & 0x7F;
	}
	print "CHUID size: " . $len . "\n";
}
else {
	die ">>> Error: Malformed data object <<<";
}

do {
	$tag = $chars[$i];
	if ($tag == 0xEE) {
		$i++; $len = $chars[$i++]; print "EE - Buffer Length (Deprecated) ($len)\n"; 
		output_value ($i, $len, "$bname.Buffer_Length", \@chars, $octets, undef, 0);
	} elsif ($tag == 0x30) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "30 - FASC-N ($len)\n"; 
		output_value ($i, $len, "$bname.FASC-N", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x32) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "32 - Organizational Identifier ($len)\n";
		output_value ($i, $len, "$bname.Organizational_Identifier", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x33) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "33 - DUNS (Optional) ($len)\n";
		output_value ($i, $len, "$bname.DUNS", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x34) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "34 - GUID ($len)\n"; 
		output_value ($i, $len, "$bname.GUID", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x35) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "35 - Expiration Date ($len)\n";
		output_value ($i, $len, "$bname.Expiration_Date", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x36) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "36 - Cardholder UUID (Optional) ($len)\n";
		output_value ($i, $len, "$bname.Cardholder_UUID", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x3D) {
		$i++; $len = $chars[$i++]; print "3D - Deprecated ($len)\n"; 
		output_value ($i, $len, undef, \@chars, $octets, undef, 0);
	} elsif ($tag == 0x3E) {
		# Issuer Asymmetric Signature has an extra 0x82 tag that we really don't need
		$i++; $i++; $len = ($chars[$i++] << 8) | $chars[$i++]; print "3E - Issuer Asymmetric Signature ($len)\n"; 
		output_value ($i, $len, "$bname.Issuer_Signature", \@chars, $octets, undef, 1);
	} elsif ($tag == 0xFE) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "FE - Error Detection code ($len)\n"; 
		output_value ($i, $len, "$bname.Error_Detection_Code", \@chars, $octets, \$hashable, 0);
	} else {
		die "Unknown tag ($tag)\n";
	}
	$i += $len;
} while ($i < $charslen);

print "Length of data: " . length($hashable) . "\n";
print "Message Digest: " . sha256_hex($hashable);

exit 0;
