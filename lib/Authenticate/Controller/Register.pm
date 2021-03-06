package Authenticate::Controller::Register;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw {decode_json};

sub register ($self) {

    my $body = $self->req->body;
    my $data = decode_json($body);

    $self->render_later();

    my $stmt = qq{
        INSERT INTO users_token (token, users_fkey)
        VALUES(?,
        (SELECT users_pkey FROM users WHERE userid = ?))
        ON CONFLICT(users_fkey)
        DO UPDATE SET token = ?,
            moddatetime = now(),
            editnum = users_token.editnum + 1
        RETURNING users_token_pkey;
    };

    my $result = $self->app->pg->db->query_p(
        $stmt,
        ($data->{token}, $data->{userid}, $data->{token})
    )->then(sub($result) {
        my $data;
        $data = $result->hash if $result->rows > 0;

        $self->render(json => { result => $data });
    })->catch(sub ($err) {

        $self->render(json => { result => $err });
    })->wait;
}
1;