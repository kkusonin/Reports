package Reports::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    ENCODING => 'utf-8',
    TEMPLATE_EXTENSION => '.tt',
    INCLUDE_PATH => [
        Reports->path_to('root'),
    ],
    WRAPPER => 'wrapper.tt',
    render_die => 1,
);

=head1 NAME

Reports::View::HTML - TT View for Reports

=head1 DESCRIPTION

TT View for Reports.

=head1 SEE ALSO

L<Reports>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
