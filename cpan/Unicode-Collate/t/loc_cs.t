
BEGIN {
    unless ("A" eq pack('U', 0x41)) {
	print "1..0 # Unicode::Collate " .
	    "cannot stringify a Unicode code point\n";
	exit 0;
    }
    if ($ENV{PERL_CORE}) {
	chdir('t') if -d 't';
	@INC = $^O eq 'MacOS' ? qw(::lib) : qw(../lib);
    }
}

use Test;
BEGIN { plan tests => 34 };

use strict;
use warnings;
use Unicode::Collate::Locale;

ok(1);

#########################

my $objCs = Unicode::Collate::Locale->
    new(locale => 'CS', normalization => undef);

ok($objCs->getlocale, 'cs');

$objCs->change(level => 1);

ok($objCs->lt("c", "c\x{30C}"));
ok($objCs->gt("d", "c\x{30C}"));
ok($objCs->lt("h", "ch"));
ok($objCs->gt("i", "ch"));
ok($objCs->lt("r", "r\x{30C}"));
ok($objCs->gt("s", "r\x{30C}"));
ok($objCs->lt("s", "s\x{30C}"));
ok($objCs->gt("t", "s\x{30C}"));
ok($objCs->lt("z", "z\x{30C}"));
ok($objCs->lt("z\x{30C}", "\x{292}")); # U+0292 EZH

# 12

$objCs->change(level => 2);

ok($objCs->eq("c\x{30C}", "C\x{30C}"));
ok($objCs->eq("r\x{30C}", "R\x{30C}"));
ok($objCs->eq("s\x{30C}", "S\x{30C}"));
ok($objCs->eq("z\x{30C}", "Z\x{30C}"));
ok($objCs->eq("ch", "cH"));
ok($objCs->eq("cH", "Ch"));
ok($objCs->eq("Ch", "CH"));

# 19

$objCs->change(level => 3);

ok($objCs->lt("c\x{30C}", "C\x{30C}"));
ok($objCs->lt("r\x{30C}", "R\x{30C}"));
ok($objCs->lt("s\x{30C}", "S\x{30C}"));
ok($objCs->lt("z\x{30C}", "Z\x{30C}"));
ok($objCs->lt("ch", "cH"));
ok($objCs->lt("cH", "Ch"));
ok($objCs->lt("Ch", "CH"));

# 26

ok($objCs->eq("c\x{30C}", "\x{10D}"));
ok($objCs->eq("C\x{30C}", "\x{10C}"));
ok($objCs->eq("r\x{30C}", "\x{159}"));
ok($objCs->eq("R\x{30C}", "\x{158}"));
ok($objCs->eq("s\x{30C}", "\x{161}"));
ok($objCs->eq("S\x{30C}", "\x{160}"));
ok($objCs->eq("z\x{30C}", "\x{17E}"));
ok($objCs->eq("Z\x{30C}", "\x{17D}"));

# 34
