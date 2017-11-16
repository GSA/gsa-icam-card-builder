#!/usr/bin/perl
#
# binchuid.pl v1.7
# vim: set ts=2 nowrap
#
# Usage: binchuid.pl <File containing CHUID in binary format> 
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&output_value &tlvparse);
use MIME::Base64;
use Digest::SHA qw(sha256 sha256_hex);
use File::Basename;

my $octets;
my $validtag;
my $encoded;
my @chars = ();
my $hashable = "";

# Check args

if (@ARGV < 1) {
	die "Usage: $0 <filename>\n";
}

# Turn off field separator

my $oldfs = $/;
$/ = undef;

# Make sure input file exists

-f $ARGV[0] or die "$ARGV[0]: $!";

my $bname = ($ARGV[0] =~ m/(\..*$)/) ? basename $ARGV[0], $1 : basename $ARGV[0];

# Open or die

open INFILE, "$ARGV[0]" or die "$ARGV[0]: $!";

# Set binary mode (Windoze and DOS need this)

binmode INFILE;

# Read the whole file into a string

$octets = <INFILE>;

close INFILE;

# Reset field separator

$/ = $oldfs;

# Convert the string to an array of 1-byte strings

@chars = unpack('C*', $octets);

# Parse the CHUID

my $i = 0;
my $j = 0;
my $tag = 0;
my $len = 0;

#
# Deal with TLV header, if present
#
if ($chars[$i] == 0x53) {
	my ($tag, $length, @value) = tlvparse (\@chars);
	@chars = @value;
	# Now, @chars should start with a FASC-N tag
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
