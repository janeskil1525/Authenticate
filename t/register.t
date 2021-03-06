use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Authenticate');

my $data;
$data->{userid} = 'test@test.com';
$data->{token} = 'd7c3783a-503d-4a6c-9b9d-ba0beb87edec';

$t->post_ok('/api/v1/register' => {
    'X-Token-Check' => '5210cc3e-8653-44ab-8498-99dd6b12921b'
} => json => $data)->status_is(200)->content_like(qr/1/i);


done_testing();

