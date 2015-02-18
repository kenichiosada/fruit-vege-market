BEGIN {
  $ENV{'DANCER_ENVIRONMENT'} = "sandbox";
}

use strict;
use warnings;

use Test::More tests => 2, import => ['!pass'];  

use Dancer qw( :syntax );
use Dancer::Plugin::DBIC qw(schema resultset);

use Plack::Test;
$Plack::Test::Impl = 'Server';
use Plack::Util;

use Data::Dumper;

my $app = Plack::Util::load_psgi('/data/www/tokyo/myapp/bin/app.pl');

test_psgi $app, sub {
  my $cb = shift;

  # Drop existing tables and Create new ones for test
  schema->deploy({ add_drop_table => 1 });
  diag( 'Preparing empty tables for test' );

  my $crops;

  # Get all results
  $crops = resultset('Crop')->select_all();
  ok ( ref($crops) eq 'ARRAY', 'Expected array for return value of all()' );
  is ( scalar @{$crops}, 0, 'Expected 0 rows in crop table' );

  # Insert sample crop data
  my @crop_names = qw( crop1 crop2 crop3 );
  my $rv;
  foreach ( @crop_names ) {
    resultset('Crop')->create({ crop_name => $_ });
  }
  diag( 'Inserting sample data' );

  # Get all results
  $crops = resultset('Crop')->select_all();

  ok( ref($crops) eq 'ARRAY', 'Expected array for return value of all()' );

  is( scalar @{$crops}, 3, 'Expected 3 rows in crop table' );

};

