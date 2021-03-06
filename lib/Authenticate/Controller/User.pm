package Authenticate::Controller::User;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw {decode_json};

sub save_user ($self) {
    #https://haveibeenpwned.com/API/v2#PwnedPasswords

    my $token = $self->req->headers->header('X-Token-Check');

    $self->render_later;
    my $validator = $self->validation;

    my $body = $self->req->body;
    my $data = decode_json($body);
    delete $data->{header_data} if exists $data->{header_data};

    my $user_response = $self->user->save_user_p($data)->then(sub ($response) {
        my $user = shift;
        my $users_pkey = 0;
        $users_pkey = $user->hash if $user->rows > 0;

        $self->render(json => {result => $users_pkey});
    })->catch(sub ($err) {

        $self->render(json => {result => $err});
    });
}


1;