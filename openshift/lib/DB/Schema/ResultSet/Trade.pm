package DB::Schema::ResultSet::Trade;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

use DBIx::Class::ResultClass::HashRefInflator;

has 'crop_id' => (
  is  => 'rw',
  isa => 'Int',
);

sub select_by_crop_id {
  my $self    = shift;

  my $interval = "> now() - interval '5 days'";
 
  my @rs = $self->search(
    { 
      'crop_id' => $self->{crop_id} 
    },
    { 
      join     => 'trade_details',
      prefetch => 'trade_details',
      trade_date => \$interval,
      order_by => [ 
                    { -desc => 'trade_date' },
                    { -asc  => 'trade_method' },
                    { -asc  => 'breed' },
                    { -desc => 'market' },
                  ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    }
  );

  return \@rs;
}

__PACKAGE__->meta->make_immutable;

1;
