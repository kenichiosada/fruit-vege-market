package Plugin::Template;

use strict;
use warnings;

use Dancer;
use Dancer::Plugin;

register 'goTemplate' => sub {
  my $page = vars->{page};

  Dancer::template 'index.html', $page;
};

register_plugin;

1;
