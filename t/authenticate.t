use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Authenticate');

my $data;
$data->{userid} = 'kalleÂ£test';
$data->{token} = '6194d075-1580-455a-bc67-1e381d38cdc6';

$t->post_ok('/api/v1/authenticate' => {
    'X-Token-Check' => '5210cc3e-8653-44ab-8498-99dd6b12921b'
} => json => $data)->status_is(200)->content_like(qr/1/i);


done_testing();
