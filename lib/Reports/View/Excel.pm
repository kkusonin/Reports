package Reports::View::Excel;
use Moose;
use namespace::autoclean;
use Catalyst::View::Excel::Template::Plus;
use base qw/Catalyst::View::Excel::Template::Plus/;

=head1 NAME

Reports::View::Excel - Catalyst View

=head1 DESCRIPTION

Catalyst View.


=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
