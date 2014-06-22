package TKS::API::Tracker;
use strict;
use warnings;
use Moose;
use Const::Fast;
use LWP::UserAgent;
use HTTP::Request::Common;
use XML::Simple;

const my $UA_TIMEOUT => 60;
const my $USER_AGENT => 'TestAgent';
const my $API_URL => 'http://api-tracker.tcsbank.ru';
const my $API_FUNC_PATH => 'PartnerApi.rest/GetLeadStatuses';

has 'key' => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has 'user_agent' => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    lazy => 1,
    builder => '_init_ua',
);

has 'url' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    builder => '_build_url',
);

=index2 _init_ua

=cut

sub _init_ua {
    LWP::UserAgent->new(
        agent => $USER_AGENT,
        ssl_opts => { verify_hostname => 1 },
        timeout => $UA_TIMEOUT,
    );
}

=index2 _init_url

=cut

sub _build_url {
	join('/', ($API_URL, $_[0]->key, $API_FUNC_PATH));
			
}

=index2 get_lead_statuses;

=cut

sub get_lead_statuses {
	my $self = shift;
	my $args = (@_ == 1 && ref $_[0]) ? $_[0] : {@_};
	
	my $query_string = join('&', map { join '=', ($_, $args->{$_}) } qw(date_from date_to));
	my $url = $self->url . '?' . $query_string;

	my $res = $self->user_agent->request(
        GET $url,
        Content_Type => 'text/xml',
    );
	
	die "Error while opening url: " . $res->code unless $res->is_success;
	
	my $xml_data = XMLin(
        $res->decoded_content, 
        KeepRoot => 1,  
        GroupTags => { items => 'item' }, 
        SuppressEmpty => '',
    );

	( ref($xml_data->{items}) eq 'ARRAY') ? $xml_data->{items} : [$xml_data->{items}];
}
1;