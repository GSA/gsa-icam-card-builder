#!/usr/bin/perl
#
# decode.pl v1.7.4
# vim: set ts=2 nowrap
#
# ddecode.pl
#
# Converts STDIN input containing any object in ASCII Hex or BASE64 to binary.
#
# Usage: ./decode.pl
#
# Handles input with hex values with space, quote or no delimiters such as:
#
# 30:19:D4:E7:39:DA:73:9C:ED:39:CE:73:9D:A1 or
# 30 19 D4 E7 39 DA 73 9C ED 39 CE 73 9D A1 or
# 3019D4E739DA739CED39CE739DA1
# 0TgQ2CivLBCEOeWhaFgorwIQhzyE5znD6w==
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
my $stdinflg = 0;
my $encoded;
my $line = "";

# Things to look for:
# javelin_protocol.*content sent
#                  {
#                  }
#
#

while ($line = <STDIN>) {
	chomp $line;
	my $len = length $line;
	if (substr ($line, ($len - 1), 1) ne "=") {
		$octets = pack ("H*", clean($line));
		for (my $i = 0; $i < length $octets; $i++) {
			printf "%c", ord(substr $octets, $i, 1); 
			my $a = my $b;
		}
		print "\n";
	} else {
		my $decoded = MIME::Base64::decode($line);
		my @chars = unpack('C*', $decoded);
		for (my $i = 0; $i < scalar @chars; $i++) {
			printf "%02X", $chars[$i]; 
		}
		print "\n";
	}
}

exit 0;

__END__
