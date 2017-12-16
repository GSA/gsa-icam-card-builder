#!/usr/bin/perl
#
## txtchuid.pl v1.7.4
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
use LogParser qw(&clean &output_value &tlvparse);
use MIME::Base64;
use Digest::SHA qw(sha256 sha256_hex);
use File::Basename;

my $infile;
my $octets;
my @chars = ();
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

my $i = 0;
my $j = 0;
my $tag = 0;
my $len = 0;

#
# Deal with TLV header, if present
#
if ($chars[$i] == 0x53) {
	my ($t, $l, @v) = tlvparse (\@chars);
	@chars = @v;
	# Now, @chars should start with a FASC-N tag.
}

my $charslen = scalar @chars;

do {
	$tag = $chars[$i];
	if ($tag == 0xEE) { #EE02F905
		$i++; $len = $chars[$i++]; print "EE - Buffer Length (Deprecated and not counted in signature) ($len)\n"; 
		output_value ($i, $len, "$bname.Buffer_Length", \@chars, $octets, undef, 0);
		print ">>> Error: Deprecated tag 0xEE <<<\n";
	} elsif ($tag == 0x30) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "30 - FASC-N (2 + $len)\n"; 
		output_value ($i, $len, "$bname.FASC-N", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x32) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "32 - Organizational Identifier (Deprecated) (2 + $len)\n";
		output_value ($i, $len, "$bname.Organizational_Identifier", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x33) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "33 - DUNS (Deprecated) (2 + $len)\n";
		output_value ($i, $len, "$bname.DUNS", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x34) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "34 - GUID (2 + $len)\n"; 
		output_value ($i, $len, "$bname.GUID", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x35) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "35 - Expiration Date (2 + $len)\n";
		output_value ($i, $len, "$bname.Expiration_Date", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x36) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "36 - Cardholder UUID (Optional) (2 + $len)\n";
		output_value ($i, $len, "$bname.Cardholder_UUID", \@chars, $octets, \$hashable, 0);
	} elsif ($tag == 0x3D) {
		$i++; $len = $chars[$i++]; print "3D - Authentication Key Map (Deprecated) (2 + $len)\n"; 
		output_value ($i, $len, undef, \@chars, $octets, undef, 0);
		print ">>> Error: Deprecated tag 0x3D <<<\n";
	} elsif ($tag == 0x3E) {
		# Issuer Asymmetric Signature has an extra 0x82 tag that we really don't need
		$i++; $i++; $len = ($chars[$i++] << 8) | $chars[$i++]; print "3E - Issuer Asymmetric Signature ($len)\n"; 
		output_value ($i, $len, "$bname.Issuer_Signature", \@chars, $octets, undef, 1);
	} elsif ($tag == 0xFE) {
		$hashable .= chr($chars[$i++]) . chr($chars[$i]);
		$len = $chars[$i++]; print "FE - Error Detection code (2 + $len)\n"; 
		output_value ($i, $len, "$bname.Error_Detection_Code", \@chars, $octets, \$hashable, 0);
	} else {
		$i++; $len = $chars[$i++]; printf "%02X - Unknown tag (2 + $len)\n", $tag; 
		output_value ($i, $len, "$bname.Unknown_Tag" . (sprintf "%2X", $tag), \@chars, $octets, \$hashable, 0);
		printf ">>> Error: Unknown tag 0x%02X <<<\n", $tag;
	}
	$i += $len;
} while ($i < $charslen);

open HASH, ">$bname" . ".sha-256" or die "$bname" . ".sha-256" . ": $!";
print HASH sha256($hashable);
close HASH;
print "Length of hashable data: " . length($hashable) . "\n";
print "Message Digest: " . sha256_hex($hashable);

exit 0;
