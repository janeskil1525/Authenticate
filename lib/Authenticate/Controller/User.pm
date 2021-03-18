package Authenticate::Controller::User;
use Mojo::Base 'Mojolicious::Controller', -signatures, -async_await;

use Mojo::JSON qw {decode_json};
use Authenticate::Helper::Access;;

async sub save_user ($self) {
    #https://haveibeenpwned.com/API/v2#PwnedPasswords

    my $token = $self->req->headers->header('X-Token-Check');

    $self->render_later;
    my $validator = $self->validation;

    my $body = $self->req->body;
    my $data = decode_json($body);
    delete $data->{header_data} if exists $data->{header_data};
    my $users_pkey = 0;
    await $self->user->save_user_p($data)->then(sub ($user) {

        $users_pkey = $user->hash->{users_pkey} if $user->rows > 0;
        return $users_pkey;
    })->catch(sub ($err) {

        $self->render(json => {result => $err});
    });

    my $temp = 1;
    await Authenticate::Helper::Access->new(
        pg => $self->app->pg
    )->set_access(
        $users_pkey, $data->{support}
    )->catch(sub ($err) {
        say $err;
    });

    $self->render(json => {result => $users_pkey});
}


1;