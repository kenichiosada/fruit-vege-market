use utf8;
package DB::Schema::Result::Trade;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::Trade

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

=head1 TABLE: C<trade>

=cut

__PACKAGE__->table("trade");

=head1 ACCESSORS

=head2 trade_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 trade_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 crop_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 trade_method

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 subtotal

  data_type: 'integer'
  is_nullable: 0

=head2 market

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "trade_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "trade_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "crop_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "trade_method",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "subtotal",
  { data_type => "integer", is_nullable => 0 },
  "market",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</trade_id>

=back

=cut

__PACKAGE__->set_primary_key("trade_id");

=head1 RELATIONS

=head2 crop

Type: belongs_to

Related object: L<DB::Schema::Result::Crop>

=cut

__PACKAGE__->belongs_to(
  "crop",
  "DB::Schema::Result::Crop",
  { crop_id => "crop_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 trade_details

Type: has_many

Related object: L<DB::Schema::Result::TradeDetail>

=cut

__PACKAGE__->has_many(
  "trade_details",
  "DB::Schema::Result::TradeDetail",
  { "foreign.trade_id" => "self.trade_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-28 08:54:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XTYo7HtvWdIUt+EuVmw8zw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
