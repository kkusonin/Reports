package Reports::Controller::TKS::Report;
use utf8;
use Moose;
use namespace::autoclean;
use DateTime::Format::Strptime;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

WebTKS::Controller::Report - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


sub tks_base : Chained('/') PathPart('tks') CaptureArgs(0) {
    my ($self, $c) = @_;
    $c->stash( bootstrap => 1 );
}

sub report_form : GET Chained('tks_base') PathPart('perf') Args(0) {
    my ($self, $c) = @_;
    
    $c->stash(
        action   => $c->uri_for($c->controller->action_for('create')),
        template => 'tks/index.tt',
    );
}

sub create : POST Chained('tks_base') PathPart('') Args(0) {
    my ($self, $c) = @_;
    
    my $date_parser = DateTime::Format::Strptime->new(pattern => "%d/%m/%Y %H:%M");
      
    eval {
        my $start = $date_parser->parse_datetime($c->req->params->{start});
        my $end = $date_parser->parse_datetime($c->req->params->{end});
    
        my @report_rows = ($c->req->params->{selection_type} == 1) ?
                            map { order_to_report($_) } $c->model('DB::TKS::Order')->entry_interval($start, $end)
                          : map { order_to_report($_) } $c->model('DB::TKS::Order')->update_interval($start, $end);
    
        $c->stash(
            report_data => \@report_rows,
            template => 'report.tt',
        );
    };
    if ($@) {
        $c->detach('report_form');
    }
    $c->res->header('Content-Disposition', qq[attachment; filename="report.xls"]);
    $c->forward('Reports::View::Excel');
}

sub order_to_report {
{
        entry_date => (defined $_[0]->entry_time) ? $_[0]->entry_time->strftime("%Y-%m-%d") : '',
        entry_time => (defined $_[0]->entry_time) ? $_[0]->entry_time->strftime("%H:%M:%S") : '',
        phone_number => $_[0]->phone_number,
		sid => $_[0]->sid,
        user => $_[0]->user,
        full_name => $_[0]->full_name,
        lead_id => $_[0]->lead_id,
        status => $_[0]->status,
        update_date => (defined $_[0]->update_time) ? $_[0]->update_time->strftime("%Y-%m-%d") : '',
        update_time => (defined $_[0]->update_time) ? $_[0]->update_time->strftime("%H:%M:%S") : '',
    }
}



=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
