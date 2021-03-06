package Authenticate::Controller::Authenticate;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw { decode_json };

# This action will render a template
sub authenticate ($self) {

    my $body = $self->req->body;
    my $data = decode_json($body);

    $self->app->pg->db->select_p(
        [
            'users', ['users_token', users_fkey => 'users_pkey']
        ],
            [
                'userid'
            ],
            {
                userid => $data->{userid},
                token  => $data->{token}
            }
    )->then(sub ($result) {

        my $date = 0;
        $date = $result->hash if $result->rows > 0;

        $self->render(json => {result => $date});
    })->catch(sub ($err) {

        $self->render(json => {result => $err})
    })->wait;

}

1;
