package Authenticate::Controller::Register;
use Mojo::Base 'Mojolicious::Controller', -signatures;


sub register ($self) {

    if($self->req->headers->header('X-Token-Check') eq $self->config->{key}){
        my $body = $self->req->body;
        my $data = decode_json($body);

        my $stmt = qq{
            INSERT INTO users_token (token, users_fkey)
            VALUES(?,
            (SELECT users_pkey FROM users WHERE userid = ?))
            ON CONFLICT(users_fkey)
            DO UPDATE SET token = ?,
                users_token.moddatetime = now(),
                users_token.editnum = users_token.editnum + 1
        };
        $self->app->pg->query_p(
            [
                'users', 'users_token', users_fkey => 'users_pkey'
            ],
            [
                'userid'
            ],
            {
                userid => $data->{userid},
                token  => $data->{token}
            }
        )->then(sub ($result) {

        })->catch(sub ($err) {

        })->wait;

    } else {
        $self->render(json => {result => 'error'});
    }
}
1;