package Myapp;

use strict;
use warnings;

use Dancer;
use Plugin::Template;
use Myapp::Crop;
use Myapp::Trade;

use DB::Schema;

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

};

get '/' => sub {
  goTemplate;
};

1;
