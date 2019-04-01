#!/usr/bin/perl
#
# idemia_atrs.pl
#
# This utility decodes ATR bytes from APDU logs from IDEMIA cards.
# It processes ASCII hex data presented to it on STDIN.  It will
# read complete streams (concatenated log files) as well as
# single lines of input from the console.
# 
# Usage: echo <string> | perl idemia_atrs.pl
#        cat <files> | perl idemia_atrs.pl
#
# This will be refactored to use an Atr.pm class when we get more
# vendor ATRs.
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin . '/../lib/perl/lib';
use LogParser qw(&clean);
use MIME::Base64;
use File::Basename;

my $TRUE  = 1;
my $FALSE = 0;

my @dis = ( -1, 1, 2, 4, 8, 16, 32, 64, 12, 20 );
my @fis = (
  372, 372, 558, 744,  1166, 1488, 1860, -1,
  -1,  512, 768, 1024, 1536, 2048, -1,   -1
);

my $nTI      = 0;
my $nTA1     = 0;
my $nTD1     = 0;
my $direct   = 0;
my $di       = 0;
my $fi       = 0;
my $cardfreq = 0;

my @chars = ();

sub getTS($) {
  return $chars[0];
}

sub isDirect($) {
  my $p1 = shift;

  # Get direct or inverse
  return ( ( $p1 & 0x4 ) == 0 ) ? 1 : 0;
}

sub byte2nibbles($) {
  my $p1   = shift;
  my $byte = $p1 & 0xff;
  my $high = ( $byte & 0xf0 ) >> 4;
  my $low  = $byte & 0x0f;
  return ( $high, $low );
}

sub nibble2bitstring($) {
  my $p1      = shift;
  my $results = "";
  for ( my $j = 3 ; $j >= 0 ; $j-- ) {
    my $bit = ( ( $p1 & ( 1 << $j ) ) > 0 ) ? 1 : 0;
    $results .= $bit;
  }
  return $results;
}

sub byte2bitstring($) {
  my $p1      = shift;
  my $len     = length $p1;
  my $results = "";
  for ( my $j = 7 ; $j >= 0 ; $j-- ) {
    $results .= " " if ( $j == 3 );
    my $bit = ( ( $p1 & ( 1 << $j ) ) > 0 ) ? 1 : 0;
    $results .= $bit;
  }
  return $results;
}

sub main() {

  my $idx = 0;
  print "\n";
  my $convention = $chars[$idx] & 0xff;

  my %conventions = (
    0x3B => "Direct",
    0x3F => "Inverse"
  );

  if ( defined $conventions{$convention} ) {
    print "Convention: " . $conventions{$convention} . "\n";
  }
  else {
    return;
  }

  $idx++;

  my ( $high, $low ) = byte2nibbles( $chars[$idx] );
  my ( $newhigh, $newlow ) = ( 0, 0 );
  my $tc = 1;

  printf "T0    Presence of TA(%d)..TD(%d) byte: %s\n", $tc, $tc,
    nibble2bitstring($high);
  printf "T0    Historical bytes: %d\n", $low;

  $idx++;

  do {
    if ( ( $high & 0x01 ) != 0 ) {

      #print "TA(" . $tc . ") \$chars[$idx]:\n";
      if ( $tc <= 2 ) {
        if ( $tc == 1 ) {

          # Di
          if ( ( $chars[$idx] & 0x0f ) == 0 ) {
            die "Error: DI value is zero\n";
          }
          else {
            if ( ( $chars[$idx] & 0x0f ) < scalar @dis ) {
              $di = $dis[ ( ( $chars[$idx] ) & 0x0f ) ];
              print "TA(1) Di: " . $di . "\n";
            }
            else {
              die "Error: Di value ($di) not found\n";
            }
          }

          # Fi
          if ( ( ( $chars[$idx] ) >> 4 ) == 0 ) {
            die "Error: Fi value is zero\n";
          }
          else {
            if ( ( ( $chars[$idx] >> 4 ) & 0x0f ) < scalar @fis ) {
              $fi = $fis[ ( ( $chars[$idx] >> 4 ) & 0x0f ) ];
              print "TA(2) Fi: " . $fi . "\n";
            }
            else {
              die "Error: Fi value ($fi) not found\n";
            }
          }
          printf "TA(2) Fi/Di: " . $fi / $di . "\n";
        }
        else {
          printf "TA(%d) Global, specific mode byte: %d\n", $tc, $chars[$idx];
        }
      }
      elsif ( $tc > 2 ) {

        # 11.4.1 Specific interface bytes for T=1
        #
        #   Three specific interface bytes are specified: the first TA for T=1,
        #   the first TB for T=1 and the first TC for T=1 (see 8.2.3). They are
        #   used to set up protocol parameters at non-default values.

        # TA1 is Information Field Size

        printf "TA(%d) Information field size: 0x%x\n", $tc, $chars[$idx];
      }
      else {
        printf "TA%d: %d\n", $tc, byte2bitstring( $chars[$idx] );
      }
      $idx++;
    }

    if ( ( $high & 0x02 ) != 0 ) {

      #print "TB(" . $tc . ") \$chars[$idx]:\n";
      if ( $tc > 2 ) {
        my ( $cwi, $bwi ) = byte2nibbles( $chars[$idx] );

        # Bits 4 to 1 of the first TB for T=1 encode CWI from zero to fifteen.
        printf "TB(%d) CWI: 0x%x\n", $tc, $cwi;

        # Bits 8 to 5 of the first TB for T=1 encode BWI from zero to nine.
        printf "TB(%d) BWI: 0x%x\n", $tc, $bwi;
      }
      else {
        printf "TB(%d) Deprecated VPP requirements byte: %d\n", $tc,
          $chars[$idx];
      }
      $idx++;
    }

    if ( ( $high & 0x04 ) != 0 ) {

      #print "TC(" . $tc . ") \$chars[$idx]:\n";
      if ( $tc > 2 ) {

        # Bit 1 of the first TC for T=1 indicates the error detection code to be used:
        #   CRC if bit 1 is set to 1;
        #   LRC (default value) if bit 1 is set to 0.
        printf "TC(%d) Error detection: %s\n", $tc,
          ( ( $chars[$idx] & 0x1 ) == 1 ) ? "CRC" : "LRC";
      }
      else {
        printf "TC(%d) Guard time: %d\n", $tc, ( $chars[$idx] & 0xff ) . "\n";
      }
      $idx++;
    }

    if ( ( $high & 0x08 ) != 0 ) {
      ( $newhigh, $newlow ) = byte2nibbles( $chars[$idx] );

      #print "TD(" . $tc . ") \$chars[$idx]:\n";
      printf "TD(%d) %s offered transmission protocol: T=%d\n", $tc,
        ( $tc == 1 ) ? "First" : "Next", $newlow . ".\n";
      printf "TD(%d) Presence of TA%d..TD%d byte: %s\n", $tc, $tc + 1,
        $tc + 1, nibble2bitstring($newhigh);
      $tc++;
      $idx++;
    }
    else {
      ( $newhigh, $newlow ) = byte2nibbles( $chars[$idx] );
    }

    $high = $newhigh;

  } while ( ( $high & 0x08 ) != 0 );

cont:

  my $hboffset = $idx;
  my $i;

  for ( $i = $hboffset + 2, my $j = 1 ; $i < scalar @chars ; $i++, $j++ ) {
    printf "HB(%d): 0x%02x\n", $j, $chars[$i];
  }

  my $hw = ( $chars[14] & 0xff );

  my %configs = (
    0x11 => "HW = 0F, FW = 5601 (Cosmo V8.0 R2)",
    0x21 => "HW = 30, FW = 5F01 (Cosmo V8.1 R1)",
    0x31 => "HW = 40, FW = 5F01 (Cosmo V8.1 R1)",
    0x41 => "HW = 30, FW = 5F02 (Cosmo V8.1 R2)",
    0x51 => "HW = 30, FW = 6F01 (Cosmo V8.2 R1)",
    0xcb => "HW = B0, FW = FC10 (Cosmo V7.0)"
  );

  if ( defined $configs{$hw} ) {
    print "Hardware Stock Description: " . $configs{$hw} . "\n";
  }
  else {
    printf "Unknown Hardware Stock Description: %02x\n", $hw;
  }

  my $index = ( $hw == 0xcb ) ? 14 : 15;

  my $fw  = $chars[$index] & 0xff;
  my $aid = ( $fw & 0xf0 ) >> 4;

  my %aids = (
    0x01 => "NIST AID (PIV or Derived Credentials)",
    0x10 => "TWIC AND (LEGACY or NEXGEN)",
    0x11 => "IDEMIA AID",
    0x0c => "NIST PIV AID"
  );

  if ( defined $aids{$aid} ) {
    print "AID: " . $aids{$aid} . "\n";
  }
  else {
    print "Unkonwn AID: " . $aid . "\n";
  }

  my $appconf = $hw & 0x06;

  my %appconfs = (
    0x00 => "CIV Configuration FIPS 140-2 Level 2 Validated",
    0x01 => "SPE and SPE-EP Configurations FIPS 140-2 level 3 Validated",
    0x02 => "NPIVP (PIV/PIV-I) Configuration FIPS 140-2 Level 2 Validated",
    0x04 => "NPIVP (PIV/PIV-I) Configuration FIPS 140-2 Level 2 Validated",
    0x0B => "NPIVP (PIV/PIV-I) Configuration FIPS 140-2 Level 2 Validated",
    0x10 => "NPIVP (PIV/PIV-I) Configuration FIPS 140-2 Level 2 Validated"
  );

  if ( defined $appconfs{$appconf} ) {
    print "Application Configuration: " . $appconfs{$appconf} . "\n";
  }
  else {
    print "Unkonwn Applicaton Configuration: " . $appconf . "\n";
  }

  my $applet = $hw & 0x03;

  $applet = 0x99 if ( $index == 14 );

  my %applets = (
    0x00 => "ID-One PIV applet version 2.3.5",
    0x01 => "ID-One PIV applet version 2.4.0",
    0x10 => "ID-One PIV applet version 2.4.1",
    0x99 => "ID-One PIV applet version 2.3.2"
  );

  if ( defined $applets{$applet} ) {
    printf "PIV Applet: " . $applets{$applet} . "\n";
  }
  else {
    print "Unkonwn PIV applet version: " . $applet . "\n";
  }
}

sub displayChars($) {

  my $cref  = shift;
  my @c     = @$cref;
  my $count = 0;
  my $len   = scalar @c;

  # Some cards include the S1/S2 bytes

  if ( $chars[ $len - 2 ] == 0x90 && $chars[ $len - 1 ] == 0x00 ) {
    pop @chars;
    pop @chars;
  }

  map {
    my $val = $_ & 0xff;
    if ( $count++ < scalar @c ) {
      printf( "  %-5d: (0x%02x) ", $count, $val );
    }
    print " ";
    print byte2bitstring($val) . "\n";
  } @c;
}

my $atrfound = 0;
my $line     = "";
my $last     = undef;

while (<STDIN>) {
  chomp();
  $last = $_;
  if (/SCARD_ATTR_ATR_STRING/) {
    $atrfound = 1;
    my $ts = m/(^.*) .DEBUG*/;
    print "********** $1 ******************\n";
    while (<STDIN>) {
      chomp();
      if (/Value.*x. /) {
        s/^.* : (.*)$/$1/g;
        $line = pack( "H*", clean($_) );
        @chars = unpack( "C*", $line );
        displayChars( \@chars );
        main();
        goto cont;
      }
    }
  cont:
  }
}

if ( defined $last && $atrfound == 0 ) {
  $_ = $last;
  s/^.* : (.*)$/$1/g;
  $line = pack( "H*", clean($_) );
  @chars = unpack( "C*", $line );
  displayChars( \@chars );
  main();
}
