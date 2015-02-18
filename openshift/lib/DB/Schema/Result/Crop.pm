use utf8;
package DB::Schema::Result::Crop;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::Crop

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<crop>

=cut

__PACKAGE__->table("crop");

=head1 ACCESSORS

=head2 crop_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 crop_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "crop_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "crop_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</crop_id>

=back

=cut

__PACKAGE__->set_primary_key("crop_id");

=head1 RELATIONS

=head2 trades

Type: has_many

Related object: L<DB::Schema::Result::Trade>

=cut

__PACKAGE__->has_many(
  "trades",
  "DB::Schema::Result::Trade",
  { "foreign.crop_id" => "self.crop_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-28 08:54:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/o2UZNDPtegfVAg1YrM8Dw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
