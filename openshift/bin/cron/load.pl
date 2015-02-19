#!/usr/bin/env perl

use strict;
use warnings;

#use lib ("$ENV{'PERL5LIB'}");

# CPAN modules
use Text::CSV_XS;
use Encode;
use DateTime;
use LWP::Simple qw/$ua head getstore/;
use Data::Dumper;

# My modules
use Conf::Settings qw( $DEBUG $CONFIG $DB_CONFIG );
use DB::Schema;

# Set settings for dev
if ( !$ENV{'OPENSHIFT_APP_NAME'} ) {
    $ENV{'OPENSHIFT_MYSQL_DB_HOST'} = $DB_CONFIG->{HOST};
    $ENV{'OPENSHIFT_MYSQL_DB_USERNAME'} = $DB_CONFIG->{USERNAME};
    $ENV{'OPENSHIFT_MYSQL_DB_PASSWORD'} = $DB_CONFIG->{PASSWORD};
};

# Connect to database
my $dsn = 'dbi:mysql:dbname=' . $DB_CONFIG->{DB_NAME} . ';host=' . $ENV{'OPENSHIFT_MYSQL_DB_HOST'};
$dsn .= ':' . $ENV{'OPENSHIFT_MYSQL_DB_PORT'} if $ENV{'OPENSHIFT_MYSQL_DB_PORT'}; 
$dsn .= ';';
my $schema = DB::Schema->connect($dsn, $ENV{'OPENSHIFT_MYSQL_DB_USERNAME'}, $ENV{'OPENSHIFT_MYSQL_DB_PASSWORD'}, { mysql_enable_utf8 => 1 }) or die 'Could not connect';

# Get date in JST
my ( $today, $d1, $d2 );
$today = DateTime->now(time_zone=>'Asia/Tokyo'); #yyyy-mm-ddTHH:MM::SS
if ( scalar @ARGV == 1 ) {
  if ( $ARGV[0] =~ /^\d{4}-\d{2}-\d{2}$/ ) {
    $today = $ARGV[0];
  } else {
    warn "Invalid date format: $ARGV[0]\n";
    exit;
  }
}
$today =~ s/(.*)T.*/$1/g; #yyyy-mm-dd
$d1 = $today;
$d1 =~ s/-//g; #yyyymmdd
$d2 = substr $d1, 0, 6; #yyyymm

&set_log("Start load.pl $today");

if ( $DEBUG == 1 ) {
  print "\nToday is $today\n";
}

# Set location of market
# Right now only 1 market is supported
my $location = '大田';

# Check if data source file exits 
my ( $data_file, $filename, $is_processed );
$data_file = "http://www.shijou-nippo.metro.tokyo.jp/SN/$d2/$d1/Sei/Sei_K2.csv";
$ua->timeout(25);

$filename = "$ENV{'OPENSHIFT_TMP_DIR'}/$d1.csv";
if (head($data_file)) {
  if ( -e $filename ) {
    $is_processed = 1;
  } else {
    getstore($data_file, $filename);
    $is_processed = 0;
  } 
}

if ( $DEBUG == 1) {
  print "Getting data from $data_file\n";
}

# Process data source file if it exists
my ( $data, $result );
if ( -e $filename && !$is_processed ) {
  $data = &parse_data($filename); 

  if ( ref($data) eq 'ARRAY' && scalar @{$data} > 0 ) {
    foreach ( @{$data} ) {
      $result = &get_data($_);
    }
  } else {
    $result = { 
      has_error => 1,
      error => 'Not valid data source',
    };
  }
} else {
  unless ( -e $filename ) {
    $result = {
      has_error => 1,
      error => 'Could not find data source',
    };
  }
}

if ( ref($result) eq 'HASH' && $result->{has_error} ) {
  if ( $DEBUG ) {
    print 'Error: ' . $result->{error} . "\n";
  }
  &set_log($result);
} else {
  &set_log("End load.pl");
}

# Parse CSV data and store data in array of hashref. 
# Sicne CSV is in shift_jis, decode it first to process
# text matching correctly. 
# It needs to be encoded to utf-8 when storing it to DB. 
sub parse_data {
  my $filename = shift;

  # Prepare to read csv file
  my $csv = Text::CSV_XS->new({binary => 1});
  open my $fh, "<:encoding(shiftjis)", $filename or die "$filename: $!";

  # Start reading
  my @parsed_data;
  my %crop;
  my $count = 0;
  my $row;

  while ($row = $csv->getline($fh)) {
    if ( ref($row) eq 'ARRAY') {
      if ( scalar(@{$row}) == 10 ) {
        # get crop name and total amount sold
        if ( $row->[0] ne '' && $row->[1] ne '' ) {
          $crop{'name'} = $row->[0];
          $crop{'total'} = $row->[1];
        }
        # get sales methods and amount sold by each method
        if ( $row->[2] ne '' && $row->[3] ne '' ) {
          $crop{'method'} = $row->[2];
          $crop{'subtotal'} = $row->[3] eq '-' ? 0 : $row->[3];
        }
        # get remaining data
        $crop{'breed'} = &sanitize_empty_value($row->[4]);
        $crop{'breed'} = '' if !$crop{'breed'};
        $crop{'from'} = &sanitize_empty_value($row->[5]);
        $crop{'from'} = '' if !$crop{'from'};
        $crop{'unit'} = &sanitize_empty_value($row->[6]);
        $crop{'high'} = &sanitize_empty_value($row->[7]);
        $crop{'mid'} = &sanitize_empty_value($row->[8]);
        $crop{'low'} = &sanitize_empty_value($row->[9]);

        if ( encode('utf-8', $crop{'name'}) !~ /品名|その他|小計/ ) {
          # add data to array
          # Pass hash wrapped in {} rather than passing hash reference. 
          # Contents of @parsed_data get overwritten when %crop is modified
          # if hashref is used because it's just a reference. Not values of 
          # %crop hash. Wrapping %crop in {} will pass actual values. 
          push @parsed_data, {%crop}; 
        }
      }

      if ( $row->[0] =~ /全分類合計/ ) {
        last;
      }
    }
    $count++;
  }

  close $fh;

  return \@parsed_data;
}

# Sanitize empty values
sub sanitize_empty_value {
  my $value = shift;
  if ( encode('utf-8', $value) =~ /^−$/ ) {
    return 0;
  } else {
    return $value;
  }
}

# Go through parsed data
sub get_data {
  my $data = shift;

  my ( $crop_id, $trade_id );
  my $result = { has_error => 0, error => '' };

  if ( ref $data eq 'HASH' ) {
    # get crop data
    if ( $data->{name} ) {
      $crop_id = &check_crop_name($data->{name});
    } else {
      $result = {
        has_error => 1,
        error => 'Crop name not found',
      };
    }

    if ( !$result->{has_error} && $crop_id ) {
      $result = &insert_trade_data($data, $crop_id);
    }

    if ( !$result ) {
      $result = {
        has_error => 1,
        error => 'Failed to insert trade data',
      };
    }

  } else {
    $result = {
      has_error => 1,
      error => 'Invalid data row',
    }; 
  }

  if ( ref($result) eq 'HASH' && $result->{has_error} ) {
    &set_log($data);
    &set_log($result); 
  }
  
  return $result;
}

# Check if crop name exists in crop table.
# If not, save the crop name to crop table.
# Returns crop_id
sub check_crop_name {
  my $crop_name = shift; 
  my $crop = $schema->resultset('Crop')->find_or_new( {crop_name => $crop_name})->insert;
  return $crop->crop_id;
}

# Insert trade data w/ transaction
sub insert_trade_data {
  my $data = shift;
  my $crop_id = shift;

  my ( $dataset, $trade_rs, $trade_detail_rs );

  my $guard = $schema->txn_scope_guard;
  
  $dataset = {
    trade_date     => $today,
    crop_id        => $crop_id,
    trade_method   => $data->{method},
    subtotal       => $data->{subtotal},
    market         => $data->{from}, 
  };
  $trade_rs = $schema->resultset('Trade')->create($dataset); 

  if ( $trade_rs->in_storage() ) {
    $dataset = {
      trade_id    => $trade_rs->trade_id,
      breed       => $data->{breed},
      location    => $location,
      trade_unit  => $data->{unit},
      high_price  => $data->{high},
      mid_price   => $data->{mid},
      low_price   => $data->{low},
    };

    $trade_detail_rs = $schema->resultset('TradeDetail')->create($dataset);

    if ( $trade_detail_rs->in_storage() ) {
      $guard->commit;
    }
  }

  if ( $trade_rs->in_storage() && $trade_detail_rs->in_storage() ) {
    return 1;
  } else {
    return 0;
    &set_log("Insert trade failed");
  }
}

# Set log
sub set_log {
  my $data = shift;
  my $now = DateTime->now(time_zone=>'America/Los_Angeles');
  my $fh = "$ENV{'OPENSHIFT_LOG_DIR'}/load.log";
  open (LOG, ">>", $fh);  
  print LOG $now . " PST\t";
  if ( ref($data) eq 'HASH' ) {
    print LOG Dumper $data;
  } else {
    print LOG $data;
  }
  print LOG "\n";
  close(LOG);
}

