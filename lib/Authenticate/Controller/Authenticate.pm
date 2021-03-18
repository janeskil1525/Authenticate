package Authenticate::Controller::Authenticate;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw { decode_json };

# This action will render a template
sub authenticate ($self) {

    my $body = $self->req->body;
    my $data = decode_json($body);

    my $stmt = qq {
        SELECT userid FROM users
            JOIN users_token
        ON users_token.users_fkey = users_pkey
            JOIN access
        ON access.users_fkey = users_pkey
            JOIN system
        ON system_fkey = system_pkey
            WHERE userid = ? AND token = ? AND system = ?
    };
    $self->app->pg->db->query_p(
        $stmt, ($data->{userid}, $data->{token}, $data->{system})
    )->then(sub ($result) {

        my $data = '';
        $data = $result->hash if $result->rows > 0;

        $self->render(json => {result => $data});
    })->catch(sub ($err) {

        $self->render(json => {result => $err})
    })->wait;

}

1;
