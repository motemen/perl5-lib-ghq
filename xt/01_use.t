use strict;
use warnings;
use Test::More;
use Config;
use FindBin;
use File::Spec;
use Cwd qw(realpath);

my $root = realpath(File::Spec->catdir($FindBin::Bin, File::Spec->updir));

my @saved_INC = @INC;

use_ok 'lib::ghq', 'github.com/motemen/perl5-lib-ghq', 'local/lib/perl5';

my @added_INC = @INC[0..$#INC-$#saved_INC+1];

ok @added_INC;
ok grep { $_ eq "$root/local/lib/perl5" } @added_INC;
ok grep { $_ eq "$root/local/lib/perl5/$Config{archname}" } @added_INC;

done_testing;
