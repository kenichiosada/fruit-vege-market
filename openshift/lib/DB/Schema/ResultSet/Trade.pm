package DB::Schema::ResultSet::Trade;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

has 'crop_id' => (
  is  => 'rw',
  isa => 'Int',
);

sub select_by_crop_id {
  my $self    = shift;
 
  my @rs = $self->search(
    { 
      'crop_id' => $self->{crop_id} 
    },
    { 
      join     => 'trade_details',
      prefetch => 'trade_details',
      order_by => [ 
                    { -desc => 'trade_date' },
                    { -asc  => 'trade_method' },
                    { -asc  => 'breed' },
                    { -desc => 'market' },
                  ],
    }
  );

  return \@rs;
}

__PACKAGE__->meta->make_immutable;

1;
