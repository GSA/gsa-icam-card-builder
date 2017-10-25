#!/usr/bin/perl
#
# text2bin.pl v1.5
# vim: set ts=2 nowrap
#
# text2bin.pl
#
# Converts files containing any object in ASCII Hex to binary.
#
# Usage: ./text2bin.pl <File containing any object in ASCII Hex> 
#
# Handles files with hex values with space, quote or no delimiters such as:
#
# 30:19:D4:E7:39:DA:73:9C:ED:39:CE:73:9D:A1 or
# 30 19 D4 E7 39 DA 73 9C ED 39 CE 73 9D A1 or
# 3019D4E739DA739CED39CE739DA1
#
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&clean);
use MIME::Base64;
use File::Basename;

my $infile;
my $outfile;
my $octets;
my $validtag;
my $encoded;

if (@ARGV < 1) {
	die "Usage: $0 <filename>\n";
}

-f $ARGV[0] or die "$ARGV[0]: $!";

open ($infile, "<$ARGV[0]") or die "$ARGV[0]: $!";

my $line = <$infile>;
chomp $line;

open ($outfile, ">" . basename("$ARGV[0]", ".txt") . ".bin") or die "$ARGV[0]" . ".bin $!";
$octets = pack ("H*", clean($line));
print $outfile $octets;
$encoded = MIME::Base64::encode($octets);
print $encoded, "\n";
close $outfile;
close $infile;

exit 0;
