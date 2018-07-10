#!/usr/bin/perl
#
# finger.pl v1.7.7
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
my $bdblen = 0;
my $bdblen_counted = 0;
my $sblen = 0;
my $sblen_counted = 0;

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
my $bcsize = 0;
my $cbeffsize = 0;
my $container_flag = 0;
my $cbhdrsize = 0;
my $fmrsize = 0;
#
# Deal with TLV header, if present
#
if ($chars[0] == 0x53) {
	shift @chars; shift @chars;
	$bcsize = (($chars[0] << 8) | $chars[1]);
	shift @chars; shift @chars; 
	# Now, @chars should start with 0xBC
}

if ($chars[0] == 0xBC) {
	shift @chars; shift @chars;
	$cbeffsize = (($chars[0] << 8) | $chars[1]);
	print "Stated CBEFF size: $cbeffsize\n";
	shift @chars; shift @chars;
} else {
	print ">>> Error: Invalid CBEFF format <<<\n";
	exit 1;
}

$charslen = scalar @chars;

if ($chars[scalar @chars - 2] == 0xFE) {
	print "File CBEFF size: " . scalar @chars - 2 . " (" . (($cbeffsize == scalar @chars -2) ? "good" : "bad") . ")\n";
} else  {
	print "File CBEFF size (no EDC): " . scalar @chars . " (" . (($cbeffsize == scalar @chars) ? "good" : "bad") . ")\n";
}

print "***** Standard Biometric Header *****\n";
print "Patron Header Version................" . $chars[$i++] . "\n";
print "SBH Security Options................." . $chars[$i++] . "\n";
$bdblen = (($chars[$i++] << 24) | ($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]);
print "BDB Length..........................." . $bdblen . "\n"; 
$sblen = (($chars[$i++] << 8) | $chars[$i++]);
print "SB Length............................" . $sblen . "\n";

my $testlen = 88 + $bdblen + $sblen;

if ($testlen != $cbeffsize) {
	print ">>> Error: HDR + BDB + SB len ($testlen) not equal to stated CBEFF size ($cbeffsize) <<<\n";
}

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

if ($chars[$i++] != 0 || $chars[$i++] != 0 || $chars[$i++] != 0 || $chars[$i++] != 0) {
	print ">>> Error: non-zero characters in separator <<<\n";
}

$cbhdrsize = $i;
if ($cbhdrsize != 88) {
	print ">>> Error: CBEFF header should be 88 bytes, not $cbhdrsize <<<\n";
}

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
my $nfv = $chars[$i++];
print "Number of finger views..............." . $nfv . "\n";
print "Reserved Byte........................" . $chars[$i++] . "\n";
print "\n";

my %fqh = ( 20 => "20", 40 => "40", 60 => "60", 80 => "80", 100 => "100", 254 => "254", 255 => "255" );

my $view;
my $lfp = -1;

for ($view = 0; $view < $nfv; $view++) {
	printf "---- Finger View %d\n", (($chars[$i + 1] & 0xF0) >> 4);
	print "Finger Position......................" . $chars[$i++] . "\n";
	my $vn = (($chars[$i] & 0xF0) >> 4);
	print "View Number.........................." . $vn . "\n";
	print ">>> Warning: View number should be 0 (not $vn) <<<\n" if ($vn != 0);
	my $it = (($chars[$i++] & 0x0F) << 8);
	print "Impression type......................" . $it . "\n";
	print ">>> Error: Impression type should 0 or 2 (not $it) <<<\n" if ($it != 0 && $it != 2);
	my $fq = $chars[$i++];
	print "Finger Quality......................." . $fq . "\n";
	print ">>> Error: Finger quality should be 20, 40, 60, 80, 100, 254, or 255 (not $fq) <<<\n" if (!exists $fqh{$fq});
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
	# 2-byte separator
	$i += 2;
}

# Create the CBEFF header file

my $outfile;
print "***** CBEFF Header *****\n";
my $unencoded = "";
my $outname = basename("$ARGV[0]", ".bin") . ".cbeffhdr";

open ($outfile, ">$outname") or die "$outname: $!";
binmode $outfile;

for ($j =  0; $j < $cbhdrsize; $j++) {
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

for ($j = $cbhdrsize; $j < $i; $j++, $bdblen_counted++) {
	$unencoded .= sprintf "%02X", $chars[$j];
	print $outfile chr($chars[$j]);
}
close $outfile;

# Some CMSs throw in some padding after the BDB. Since we are not
# going by the stated data structure sizes (other than the 88 bytes
# for the header), we will slog through the padding until the 
# CMS starts.

my $padding = 0;

for ( ; $chars[$i] != 0x30; $bdblen_counted++, $i++) { 
	$padding++;
}

if ($bdblen_counted != $bdblen) {
	print ">>> Error: Actual BDB length ($bdblen_counted) doesn't match header ($bdblen) <<<\n";
}

$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);

if ($padding > 0) {
	print ">>> Error: Found ($padding) bytes of extraneous padding <<<\n";
}

print "***** Signature Block *****\n";
$unencoded = "";

open ($outfile, ">" . basename("$ARGV[0]", ".bin") . ".cms") or die "$ARGV[0]" . ".cms $!";
binmode $outfile;

# Account for Error Detection tag, since we saw the 0xBC earlier
# If the 0xBC exists, then expect to find the Error Detection Code 0xFE00

my $lastidx = $charslen;

if ($chars[$lastidx - 2] == 0xFE) { 
		$lastidx -= 2;
} else {
		print ">>> Warning: No Error Detection Code <<<\n";
}

for ( ; $i < $lastidx; $i++, $sblen_counted++) {
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

__END__
