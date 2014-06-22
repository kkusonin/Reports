use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Reports';
use Reports::Controller::TKS::Report;

ok( request('/tks/report')->is_success, 'Request should succeed' );
done_testing();
