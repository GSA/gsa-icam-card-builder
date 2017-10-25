#!/usr/bin/perl
#
# facial.pl v1.5
# vim: ts=2 nohlsearch nowrap
#
# Usage: ./facial.pl <File containing facial image CBEFF in binary format> 
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&cook &tlvparse);
use MIME::Base64;
use File::Basename;
use Date::Calc qw (Mktime);

sub image_matches($$$) {
	my $headersref = shift;
	my $charsref = shift;
	my $index = shift;
	my @headers = @$headersref;
	my @chars = @$charsref;
	my $numheaders = scalar @headers;
	my $i = 0;
	my $j = 0;
	my $k = 0;
	my $count = 0;
	my $headerlen = 0;
	my $type = -1;
	my $headerref = undef;
	my @header = ();
	for ($i = 0; $i < $numheaders; $i++) {
		$headerref = $headers[$i];	
		@header = @$headerref;
		$headerlen = scalar @header;
		for ($j = 0, $k = $index; $j < $headerlen; $j++, $k++) {
			$count++ if ($chars[$k] == $header[$j]);
		}
		if ($count == $headerlen) {
			# We have a match!
			return $i;
		}
	}

	return -1;
}

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
my $tag = 0;
my $bsize = 0;
my $cbsize = 0;
my $container_flag = 0;
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
print "\n";
#
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

# 4 bytes for Reserved

$i += 4;

print "***** Facial Record Header *****\n";
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

print "Length of Record....................." .  (($chars[$i++] << 24) | ($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n"; 
print "Number of Faces......................" . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "\n";
print "***** Facial Data Record *****\n";
print "---- Facial Information ----\n";
my $fiblength = (($chars[$i++] << 24) | ($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]); 
print "Face Image Block Length.............." . $fiblength . "\n";
my $nfpoints = (($chars[$i++] << 8) | $chars[$i++]);
print "Number of Feature Points............." . $nfpoints . "\n";
print "Gender..............................." . $chars[$i++] . "\n";
print "Eye Color............................" . $chars[$i++] . "\n";
print "Hair Color..........................." . $chars[$i++] . "\n";
print "Feature Mask........................." . (($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Expression..........................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Pose Angle..........................." . (($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Pose Angle Uncertainty..............." . (($chars[$i++] << 16) | ($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "\n";

# This loop could occur zero or more times.

for ($j = 0; $j < $nfpoints; $j++) {
	print "---- Feature Points ($j) ----\n";
	print "Feature Type........................." . $chars[$i++] . "\n";
	print "Feature Points......................." . $chars[$i++] . "\n";
	print "Horizontal Position (x).............." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
	print "Vertical Position (y)................" . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
	print "Reserved............................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
	print "\n";
}
print "---- Image Information ----\n";
print "Facial Image Type...................." . $chars[$i++] . "\n";
my $imagedtype = $chars[$i];

print "Image Data Type......................" . $chars[$i++] . "\n";
print "Width................................" . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Height..............................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Image Color Space...................." . $chars[$i++] . "\n";
print "Source Type.........................." . $chars[$i++] . "\n";
print "Device Type.........................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";
print "Quality.............................." . (($chars[$i++] << 8) | $chars[$i++]) . "\n";

print "---- Image Data ----\n";

my %types = (-1 => "Unknown", 0 => "JPEG", 1 => "JPEG 2000");

# Create arrays of all magic bytes we will be looking for

my @jpheader = (0xFF, 0xD8);
my @jp2header = (0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, 0x87, 0x0a);

# Stick them all in an array

my @headers = (\@jpheader, \@jp2header);

# See what type they match

my $actualtype = image_matches(\@headers, \@chars, $i);

if ($actualtype != $imagedtype) {
	print ">>> Error: Image Data Type ($types{$actualtype}) doesn't match Image Data Type ($types{$imagedtype}) <<<\n";
}

my $imageext = ($actualtype == 0) ? ".jpg" : ($actualtype == 1) ? ".jp2" : ".dat";

my $imagelength = 0;

# Image length has to be computed based on the stated Facial Information Block Length
# minus the Facial Information and Image Information lengths.
# and the number of Feature Points which could be optional or multiple.

$imagelength = $fiblength - (($nfpoints * 8) + 20 + 12);

# Create a CBEFF header file

my $outfile;

print "***** CBEFF Header *****\n";
my $unencoded = "";
my $outname = basename("$ARGV[0]", ".bin") . ".cbeffhdr";

open ($outfile, ">$outname") or die "$outname: $!";
binmode $outfile;

for ($j = ($container_flag == 1) ? 4 : 0; $j < $i; $j++) {
	$unencoded .= sprintf "%02X", $chars[$j];
	print $outfile chr($chars[$j]);
}
close $outfile;
$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);

# Create a renderable image file

print "***** Image Data *****\n";

$unencoded = "";
$outname = basename("$ARGV[0]", ".bin") . "$imageext";

open ($outfile, ">$outname") or die "$outname: $!";
binmode $outfile;

for ($j = 0; $j < $imagelength; $j++, $i++) {
	$unencoded .= sprintf "%02X", $chars[$i];
	print $outfile chr($chars[$i]);
}
close $outfile;

$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);

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
if ($sblen_counted != $sblen) {
	print ">>> Error: Actual SB length ($sblen_counted) doesn't match header ($sblen) <<<\n";
}

if ($chars[$i++] != 0xFE) {
	print ">>> Warning: No Error Detection Code <<<\n";
}

close $outfile;
$octets = pack ("H*", $unencoded);
print MIME::Base64::encode($octets);
exit 0;
