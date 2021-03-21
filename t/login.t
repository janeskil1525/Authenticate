use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Authenticate');

my $data;
$data->{userid} = 'test@test.com';
$data->{password} = '12345';
$data->{system} = 'Basket';

$t->post_ok('/api/v1/login_check' => {
    'X-Token-Check' => '5210cc3e-8653-44ab-8498-99dd6b12921b'
} => json => $data)->status_is(200)->json_has('/result', '0');


done_testing();

