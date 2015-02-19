package Myapp;

use strict;
use warnings;

use Dancer;
use Plugin::Template;
use Myapp::Crop;
use Myapp::Trade;

use DB::Schema;
use Conf::Settings qw( $DB_CONFIG );

our $VERSION = '0.1';

prefix undef;

hook 'before' => sub {
  my $page = {};
  var 'page' => $page;  

  # parse request URI
  my @uri = split('/', request->{path});
  $page->{location}   = $uri[1];
  $page->{section}    = $uri[2];
  $page->{subSection} = $uri[3];
  $page->{navSection} = $uri[4];

  # set config
  if ( $ENV{'OPENSHIFT_APP_NAME'} ) {
    config->{log_path} = "$ENV{'OPENSHIFT_LOG_DIR'}"; 
    config->{plugins}->{DBIC}->{default}->{dsn} = "dbi:mysql:dbname=$DB_CONFIG{'DB_NAME'};host=$ENV{'OPENSHIFT_MYSQL_DB_HOST'}:$ENV{'OPENSHIFT_MYSQL_DB_PORT'}";
    config->{plugins}->{DBIC}->{default}->{user} = "$ENV{'OPENSHIFT_MYSQL_DB_USERNAME'}";
    config->{plugins}->{DBIC}->{default}->{password} = "$ENV{'OPENSHIFT_MYSQL_DB_PASSWORD'}";
  }
};

get '/' => sub {
  goTemplate;
};

1;
