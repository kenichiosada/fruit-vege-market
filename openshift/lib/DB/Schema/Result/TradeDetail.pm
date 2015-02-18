use utf8;
package DB::Schema::Result::TradeDetail;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DB::Schema::Result::TradeDetail

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

=head1 TABLE: C<trade_detail>

=cut

__PACKAGE__->table("trade_detail");

=head1 ACCESSORS

=head2 trade_detail_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 trade_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 breed

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 location

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 trade_unit

  data_type: 'decimal'
  is_nullable: 1
  size: [13,2]

=head2 high_price

  data_type: 'integer'
  is_nullable: 1

=head2 mid_price

  data_type: 'integer'
  is_nullable: 1

=head2 low_price

  data_type: 'integer'
  is_nullable: 1

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "trade_detail_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "trade_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "breed",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "location",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "trade_unit",
  { data_type => "decimal", is_nullable => 1, size => [13, 2] },
  "high_price",
  { data_type => "integer", is_nullable => 1 },
  "mid_price",
  { data_type => "integer", is_nullable => 1 },
  "low_price",
  { data_type => "integer", is_nullable => 1 },
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

=item * L</trade_detail_id>

=back

=cut

__PACKAGE__->set_primary_key("trade_detail_id");

=head1 RELATIONS

=head2 trade

Type: belongs_to

Related object: L<DB::Schema::Result::Trade>

=cut

__PACKAGE__->belongs_to(
  "trade",
  "DB::Schema::Result::Trade",
  { trade_id => "trade_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-01-28 08:54:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CKuDct9tVdSw0WfYowZsFw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
