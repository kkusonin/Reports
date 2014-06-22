package TKS::Schema::ResultSet::Item;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub last_event_time {
	require DateTime::Format::MySQL;
	if (my $date = $_[0]->search(undef)->get_column('date')->max) {
		DateTime::Format::MySQL->parse_datetime($date);
	}
	else {
		undef;
	}
}	

1;