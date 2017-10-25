#!/usr/bin/perl
##
# finger.pl v1.5
# vim: ts=2 nohlsearch nowrapscan
#
# Usage: ./finger.pl <File containing CBEFF in binary format> 
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&cook &tlvparse);
use MIME::Base64;
use File::Basename;
use Date::Calc qw (Mktime);

my $octets;
my $validtag;
my $encoded;
my @chars = ();
my $charslen = 0;

# Check args

if (@ARGV < 1) {
	die "Usage: $0 <filename>\n";
}

# Turn off field separator

my $oldfs = $/;
$/ = undef;

# Make sure input file exists

-f $ARGV[0] or die "$ARGV[0]: $!";

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

# Parse the CBEFF

my $i = 0;
my $j = 0;
my $len;
my $container_flag = 0;
my $cbhdrsize = 0;
my $fmrsize = 0;
#
# Deal with TLV header, if present
#
if ($chars[$i] == 0x53) {
	my ($tag, $length, @value) = tlvparse (\@chars);
	@chars = @value;
	# Now, @chars should start with 0xBC
}

$charslen = scalar @chars;
if ($chars[$i] == 0xBC) {
	$container_flag = 1; 
  $i++;
	$i++;  # Skip (82)
	print "CBEFF size: " . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
}

print "***** Standard Biometric Header *****\n";
print "Patron Header Version................" . $chars[$i++] . "\n";
print "SBH Security Options................." . $chars[$i++] . "\n";
print "BDB Length..........................." . (($chars[$i++] << 24) | ($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n"; 
my $sblen = (($chars[$i++] << 8) | $chars[$i++]);
print "SB Length............................" . $sblen . "\n";
print "BDB Format Owner....................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "BDB Format Type......................" . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
printf "Biometric Creation Date..............%02d%02d%02d%02d%02d%02d%02d%c\n", $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++];
my $biosdate = sprintf "%02d%02d%02d%02d%02d%02d%02d%c", $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++];
my $bioedate = sprintf "%02d%02d%02d%02d%02d%02d%02d%c", $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++], $chars[$i++];
my $expires = Mktime (unpack ("A4A2A2A2A2A2", $bioedate));
my $now = scalar time();

print "Validity Period......................$biosdate through $bioedate\n";
print ">>> Error: Biometric is expired ($bioedate) <<<\n" if ($expires < $now);
print "Biometric Type......................." . (($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Biometric Data Type.................." . $chars[$i++] . "\n";
print "Biometric Data Quality..............." . $chars[$i++] . "\n";
print "Creator..............................";
for ($j = 0; $j < 18; $j++, $i++) {
	if ($chars[$i] != 0) {
		print chr($chars[$i]);
	}
}
my $raw = "";
my $asciihex = "";

print "\n";
print "FASC-N...............................";
for ($j = 0; $j < 25; $j++, $i++) {
	$asciihex = sprintf "%02x", $chars[$i];
	print $asciihex;
	$raw .= $asciihex;
}

print " (". cook($raw) . ")\n\n";

$i += 4;
$cbhdrsize = ($container_flag == 1) ? $i - 4 : $i;

print "***** Biometric Data Block *****\n";
print "Format Identifier....................";
for ($j = 0; $j < 4; $j++, $i++) {
	if ($chars[$i] != 0) {
		print chr($chars[$i]);
	}
}
print "\n";
print "Version Number.......................";
for ($j = 0; $j < 4; $j++, $i++) {
	if ($chars[$i] != 0) {
		print chr($chars[$i]);
	}
}
print "\n";

print "Length of Record....................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
printf "CBEFF Product Identifier.............Vendor %d Version %d\n", ($chars[$i++] << 8) | $chars[$i++], ($chars[$i++] << 8) | $chars[$i++];
print "Capture Equipment Compliance........." . (($chars[$i] & 0xF0) >> 4) . "\n";
print "Capture Equipment...................." . ((($chars[$i++] & 0x0F) << 8) | $chars[$i++]) . "\n";
print "Size of Scanned Image in x Direction." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Size of Scanned Image in y Direction." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Horizontal Resolution................" . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Vertical Resolution.................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Number of finger views..............." . $chars[$i++] . "\n";
print "Reserved Byte........................" . $chars[$i++] . "\n";
print "\n";

printf "---- Finger View %d\n", (($chars[$i + 1] & 0xF0) >> 4);
print "Finger Position......................" . $chars[$i++] . "\n";
print "View Number.........................." . (($chars[$i] & 0xF0) >> 4) . "\n";
print "Impression type......................" . (($chars[$i++] & 0x0F) << 8) . "\n";
print "Finger Quality......................." . $chars[$i++] . "\n";
my $minutiae_count = $chars[$i];
print "Number of Minutiae..................." . $chars[$i++] . "\n";

print "\n*** Minutiae ***\n";
my $min_type;
for ($j = 0; $j < $minutiae_count; $j++, $i += 6) {
	$min_type = (($chars[$i] & 0xC0) >> 6);
	printf "%6s %3d %3d %3d %3d\n",
		($min_type == 0) ? "Other" : ($min_type == 1) ? "Ridge" : "Bifur",
		((($chars[$i] & ~0xC0) << 2) | ($chars[$i + 1])),
		(($chars[$i + 2] << 8) | $chars[$i + 3]),
		$chars[$i + 4],
		$chars[$i + 5];
}

print "\n";

$i += 2;
printf "---- Finger View %d\n", (($chars[$i + 1] & 0xF0) >> 4);
print "Finger Position......................" . $chars[$i++] . "\n";
print "View Number.........................." . (($chars[$i] & 0xF0) >> 4) . "\n";
print "Impression type......................" . (($chars[$i++] & 0x0F) << 8) . "\n";
print "Finger Quality......................." . $chars[$i++] . "\n";
$minutiae_count = $chars[$i];
print "Number of Minutiae..................." . $chars[$i++] . "\n";
print "\n*** Minutiae ***\n";
for ($j = 0; $j < $minutiae_count; $j++, $i += 6) {
	$min_type = (($chars[$i] & 0xC0) >> 6);
	printf "%6s %3d %3d %3d %3d\n",
		($min_type == 0) ? "Other" : ($min_type == 1) ? "Ridge" : "Bifur",
		((($chars[$i] & ~0xC0) << 2) | ($chars[$i + 1])),
		(($chars[$i + 2] << 8) | $chars[$i + 3]),
		$chars[$i + 4],
		$chars[$i + 5];
}

print "\n";

$fmrsize = $i - $cbhdrsize;

# Create a CBEFF header file

my $outfile;
print "***** CBEFF Header *****\n";
my $unencoded = "";
my $outname = basename("$ARGV[0]", ".bin") . ".cbeffhdr";

open ($outfile, ">$outname") or die "$outname: $!";
binmode $outfile;

for ($j = ($container_flag == 1) ? 4 : 0; $j < $cbhdrsize + 4; $j++) {
	$unencoded .= sprintf "%02X", $chars[$j];
	print $outfile chr($chars[$j]);
}
close $outfile;

$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);

print "***** FMR *****\n";
$unencoded = "";
$outname = basename("$ARGV[0]", ".bin") . ".fmr";

open ($outfile, ">$outname") or die "$outname: $!";
binmode $outfile;

for ($j = $cbhdrsize + (($container_flag == 1) ? 4 : 0); $j < $i + 2; $j++) {
	$unencoded .= sprintf "%02X", $chars[$j];
	print $outfile chr($chars[$j]);
}
close $outfile;

$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);

# 2-byte separator

$i += 2;

print "***** Signature Block *****\n";
$unencoded = "";

open ($outfile, ">" . basename("$ARGV[0]", ".bin") . ".cms") or die "$ARGV[0]" . ".cms $!";
binmode $outfile;

my $sblen_counted = 0;

# Account for Error Detection tag, since we saw the 0xBC earlier
my $nbytes = ($container_flag == 1) ? $charslen - 2 : $charslen + 2;

for ( ; $i < $nbytes; $i++, $sblen_counted++) {
	$unencoded .= sprintf "%02X", $chars[$i];
	print $outfile chr($chars[$i]);
}
close $outfile;

if ($sblen_counted != $sblen) {
	print ">>> Error: Actual SB length ($sblen_counted) doesn't match header ($sblen) <<<\n";
}

$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);
exit 0;
