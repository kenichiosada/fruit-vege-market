package Myapp::Crop;

use strict;
use warnings;

use Dancer qw( :syntax );
use Dancer::Plugin::DBIC qw( schema resultset );

use Plugin::Template;

use Data::Dumper;

prefix '/crop';

get '/' => sub {
  my $page = vars->{page};   

  my $crops = resultset('Crop')->select_all(); 

  $page->{crops} = $crops;

  goTemplate;
};

1;
