use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Authenticate');

my $data;
$data->{userid} = 'test3@test.com';
$data->{username} = 'Test Test';
$data->{passwd} = '1234rfert6';
$data->{active} = '1';
$data->{support} = '1';

$t->post_ok('/api/v1/save_user' => {
    'X-Token-Check' => '5210cc3e-8653-44ab-8498-99dd6b12921b'
} => json => $data)->status_is(200)->content_like(qr/1/i);

done_testing();
