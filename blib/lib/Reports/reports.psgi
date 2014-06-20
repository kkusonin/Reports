use strict;
use warnings;

use Reports;

my $app = Reports->apply_default_middlewares(Reports->psgi_app);
$app;

