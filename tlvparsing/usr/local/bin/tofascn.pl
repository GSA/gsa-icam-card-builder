#!/usr/bin/perl
#
# tofascn.pl v1.6
# vim: ts=2 nowrap
#
#
# Usage: ./tofascn.pl <FASC-N in 200-bit format> 
#
# Converts 200-bit format FASC-N to human-readble form
# 
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use Getopt::Long qw(GetOptions);
use LogParser qw(&cook &clean);

my $raw = "";
# Check args

GetOptions("--raw|r=s" => \$raw);

if (length $raw == 0) {
	die "Usage: $0 --raw=<raw fascn>\n";
}

$raw = clean($raw);
my $length = length $raw;
die "Invalid input length ($length)\n" if (length $raw != 50);

my $fascn = cook($raw);

$length = length $fascn;
die "Invalid output length ($fascn)\n" if (length $fascn != 32);

print "$fascn\n";

exit 0;
