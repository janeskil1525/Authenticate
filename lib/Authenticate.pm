package Authenticate;
use Mojo::Base 'Mojolicious', -signatures;

use Mojo::Pg;
use Data::Dumper;
use File::Share;
use Mojo::File;

use Authenticate::Model::User;

$ENV{AUTHENTICATE_HOME} = '/home/jan/Project/Authenticate/'
    unless $ENV{AUTHENTICATE_HOME};

has dist_dir => sub {
  return Mojo::File->new(
      File::Share::dist_dir('Authenticate')
  );
};

has home => sub {
  Mojo::Home->new($ENV{AUTHENTICATE_HOME});
};

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('Config');

  # Configure the application
  $self->secrets($config->{secrets});
  $self->helper(pg => sub {state $pg = Mojo::Pg->new->dsn(shift->config('pg'))});

  say "Authenticate " . $self->pg->db->query('select version() as version')->hash->{version};

  $self->log->path($self->home() . $self->config('log'));

  $self->renderer->paths([
      $self->dist_dir->child('templates'),
  ]);
  $self->static->paths([
      $self->dist_dir->child('public'),
  ]);

  $self->pg->migrations->name('authenticate')->from_file(
      $self->dist_dir->child('migrations/authenticate.sql')
  )->migrate(2);

  $self->helper(
      user => sub {
        state $user = Authenticate::Model::User->new(pg => shift->pg)
      }
  );

  my $auth_route = $self->routes->under( '/app', sub {
    my ( $c ) = @_;

    return 1 if ($c->session('auth') // '') eq '1';
    $c->redirect_to('/');
    return undef;
  } );

  my $auth =  $self->routes->under('/api' => sub {
    my $c = shift;
    #say "authentichate " . $c->req->headers->header('X-Token-Check');
    # Authenticated
    return 1 if $c->user->authenticate($c->req->headers->header('X-Token-Check'));
    return 1 if $c->config->{key} eq $c->req->headers->header('X-Token-Check');
    # Not authenticated
    $c->render(json => '{"error":"unknown error"}');
    return undef;
  });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $auth->post('/v1/authenticate')->to('authenticate#authenticate');
  $auth->post('/v1/save_user')->to('user#save_user');
  $auth->post('/v1/register')->to('register#register');
  $auth->post('/v1/login_check')->to('login#login_check');

}

1;
