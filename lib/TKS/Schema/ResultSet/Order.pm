package TKS::Schema::ResultSet::Order;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub search_by_lead {
	$_[0]->single({lead_id => $_[1] });
}

sub format_datetime {
	$_[0]->result_source
	     ->schema
		 ->storage
         ->datetime_parser
		 ->format_datetime($_[1]);
}

sub entry_interval {
	my ($self, $start, $end) = @_;
	
	$self->search({
		entry_time => { -between => [$self->format_datetime($start), $self->format_datetime($end)]},	
	});
}

sub update_interval {
	my ($self, $start, $end) = @_;
	
	$self->search({
		update_time => { -between => [$self->format_datetime($start), $self->format_datetime($end)]},	
	});
}

1;