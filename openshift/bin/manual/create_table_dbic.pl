#!/usr/bin/env perl

BEGIN {
  if ( !$ENV{'OPENSHIFT_APP_NAME'} ) {
    $ENV{'OPENSHIFT_TMP_DIR'} = './';
    $ENV{'OPENSHIFT_MYSQL_DB_HOST'} = 'localhost';
    $ENV{'OPENSHIFT_MYSQL_DB_USERNAME'} = 'root';
    $ENV{'OPENSHIFT_MYSQL_DB_PASSWORD'} = 'test123';
    $ENV{'OPENSHIFT_APP_NAME'} = 'market';
  }
};

use strict;
use warnings;

use lib ("../lib/");

use DB::Schema;

# Connect to database
#my $dsn = 'dbi:mysql:dbname=' . $ENV{'OPENSHIFT_APP_NAME'} . ';host=' . $ENV{'OPENSHIFT_MYSQL_DB_HOST'};
my $dsn = 'dbi:mysql:dbname=market;host=' . $ENV{'OPENSHIFT_MYSQL_DB_HOST'};
$dsn .= ':' . $ENV{'OPENSHIFT_MYSQL_DB_PORT'} if $ENV{'OPENSHIFT_MYSQL_DB_PORT'}; 
$dsn .= ';';
my $schema = DB::Schema->connect($dsn, $ENV{'OPENSHIFT_MYSQL_DB_USERNAME'}, $ENV{'OPENSHIFT_MYSQL_DB_PASSWORD'}, { mysql_enable_utf8 => 1 }) or die 'Could not connect';

$schema->deploy;
