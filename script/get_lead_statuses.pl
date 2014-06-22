#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Config::General;
use Const::Fast;
use Data::Dumper;
use DateTime;
use TKS::Schema;
use TKS::API::Tracker;
use Vicidial::Schema;

const my $DEFAULT_FROM => '1401566399';

my %conf = Config::General->new("$Bin/../reports.conf")
                          ->getall;
						  
my $key = $conf{Model}->{ApiTracker}->{args}->{key};

my $schema = TKS::Schema->connect($conf{'Model'}->{'TksDB'}->{connect_info});

my $db_items = $schema->resultset('Items');

my $last_event_time = $events->last_event_time;
my $date_from = ($last_event_time) ? $last_event_time->epoch : $DEFAULT_FROM;

my $date_to = DateTime->now(time_zone => 'local')->epoch;

my $tracker = TKS::API::Tracker->new(key => $key);

my $items = $tracker->get_lead_statuses(
	date_from => $date_from + 1,
	date_to => $date_to
);

if (@$items>= 1 && ref $items->[0]) {
	foreach (@$items) {
		$db_items->create({
			uuid   => $_->{uuid},
			sid    => $_->{sid}
			wm     => $_->{wm},
			date   => $_->{date},
			status => $_->{status},
			reason => $_->{reason},
		});
	};
	print STDERR "GetLeadStatuses: ", scalar @$items, " new events received\n";
}
else {
	print STDERR "GetLeadStatuses: no new events received\n";
}



