BEGIN {
  $ENV{'DANCER_ENVIRONMENT'} = "sandbox";
}

use Test::More tests => 3;
use strict;
use warnings;

use Plack::Test;
$Plack::Test::Impl = 'Server';
use HTTP::Request::Common;
#use Plack::Loader;
use Plack::Util;

my $app = Plack::Util::load_psgi('/data/www/tokyo/myapp/bin/app.pl');

test_psgi $app, sub {
  my $cb = shift;

  my $res;

  $res = $cb->(GET '/');
  is ( $res->code, '200', 'Expecting 200 from /' );

  $res = $cb->(GET '/crop');
  is ( $res->code, '200', 'Expecting 200 from /crop' );

  $res = $cb->(GET '/trade');
  is ( $res->code, '200', 'Expecting 200 from /trade' );
};

done_testing();
