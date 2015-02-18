use Test::More tests => 9;
use strict;
use warnings;

use_ok 'Myapp';
use_ok 'Myapp::Crop';
use_ok 'Myapp::Trade';

use_ok 'Plugin::Template';

use_ok 'DB::Schema';
use_ok 'DB::Schema::Result::Crop';
use_ok 'DB::Schema::Result::Trade';
use_ok 'DB::Schema::Result::TradeDetail';

use_ok 'DB::Schema::ResultSet::Trade';
