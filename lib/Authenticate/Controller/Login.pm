package Authenticate::Controller::Login;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Try::Tiny;
use Data::UUID;
use Data::Dumper;
use Digest::SHA qw{sha512_base64};
use Mojo::JSON qw { decode_json };


sub login ($self) {

    say "login_api";
    say $self->req->body;
    my $data = decode_json($self->req->body);

    my $user = $self->user->login(
        $data->{username}, $data->{password}
    );

    $self->render(json => $user);
}

1;