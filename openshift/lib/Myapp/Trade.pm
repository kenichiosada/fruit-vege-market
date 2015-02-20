package Myapp::Trade;

use strict;
use warnings;

use Dancer qw( :syntax );
use Dancer::Plugin::DBIC qw( schema resultset );

use Plugin::Template;

use Encode qw( encode decode );

use Data::Dumper;

prefix '/trade';

get '/' => sub {
  my $page = vars->{page};   
  my $crop_id = params->{crop_id};

  my $trade_rs = resultset('Trade');
  $trade_rs->{crop_id} = $crop_id;

  $page->{trades} = $trade_rs->select_by_crop_id();

debug Dumper $page->{trades};

  my $crop_rs = resultset('Crop');
  $crop_rs->{crop_id} = $crop_id;

  $page->{crop} = $crop_rs->select_by_crop_id();

debug Dumper $page->{crop};

  goTemplate;
};

1;

