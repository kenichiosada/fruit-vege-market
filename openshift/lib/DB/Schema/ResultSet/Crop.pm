package DB::Schema::ResultSet::Crop;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
use MooseX::NonMoose;

extends 'DBIx::Class::ResultSet';

use DBIx::Class::ResultClass::HashRefInflator;

has 'crop_id' => (
  is  => 'rw',
  isa => 'Int',
);

sub select_all {
  my $self    = shift;

  my @rs = $self->all(); 
 
  return \@rs;
}

sub select_by_crop_id {
  my $self = shift;

  my @rs = $self->search(
    { 
      'crop_id' => $self->{crop_id} 
    },
    {
      result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    }
  );

  if ( scalar @rs > 0 ) {
    return \@rs;
  } else {
    return 0;
  }
}

__PACKAGE__->meta->make_immutable;

1;
