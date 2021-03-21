package Authenticate::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Try::Tiny;
use Data::UUID;
use Data::Dumper;
use Digest::SHA qw{sha512_base64};
use Mojo::JSON qw { decode_json };


sub login_check ($self) {

    $self->render_later;
    my $data = decode_json($self->req->body);

    my $result = $self->user->login_check_p (
        $data->{userid}, $data->{password}, $data->{system}
    )->then(sub ($result) {
        $self->render(
            json => {result => $result}
        );
    })->catch(sub ($err) {
        $self->render(
            json => {
                result => 0,
                error => $err
            }
        );
    })->wait;
}

1;