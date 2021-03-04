package Authenticate::Controller::Authenticator;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::JSON qw { decode_json };

# This action will render a template
sub authenticate ($self) {

  # Render template "example/welcome.html.ep" with message
  if($self->req->headers->header('X-Token-Check') eq $self->config->{key}){
    my $body = $self->req->body;
    my $data = decode_json($body);

    $self->app->pg->select_p(
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
