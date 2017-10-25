#!/usr/bin/perl
#
# toraw.pl v1.1
# vim: ts=2 nowrap
#
# Usage: ./toraw.pl --fascn=FASC-N [--upper] --delim=delimiter
#
# Converts human readable FASC-N to raw form as seen on card ojects
# 
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use Getopt::Long qw(GetOptions);
use LogParser qw(&raw &rawdelim $TRUE $FALSE);

my $fascn = "";
my $upper = $FALSE;
my $delim = "";
my $rawlen = 50;
my $length = 0;
my $raw = "";

# Check args

GetOptions("--fascn|f=s" => \$fascn, "--delim|d=s" =>\$delim, "--upper|u" =>\$upper);

$length = length $fascn;

if (length $fascn == 0) {
	die "Usage $0 -f|fascn=FASC-N [-d|--delim=delimiter] [-u|-upper]\n";
}
die "Invalid input length ($length)\n" if (length $fascn != 32);

$raw = rawdelim($fascn, $delim, $upper);
die "Invalid output length ($raw)\n" if (length $raw != 50 + ((length ($delim)) * 24));
print "$raw\n";

exit 0;
