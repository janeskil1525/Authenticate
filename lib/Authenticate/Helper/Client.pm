package Authenticate::Helper::Client;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use Mojo::UserAgent;
use Mojo::JSON qw {to_json decode_json};
use Data::Dumper;

has 'endpoint_address';
has 'key';

async sub save_user ($self, $userid, $username, $active, $passwd) {

    my $user->{userid} = $userid;
    $user->{username} = $username;
    $user->{active} = $active;
    $user->{passwd} = $passwd;

    my $ua = Mojo::UserAgent->new();

    my $res = $ua->post(
        $self->endpoint_address() . '/api/v1/save_user' =>
            {'X-Token-Check' => $self->key()} =>
            json => $user
    )->result;
    my $body;
    if($res->is_error){
        $self->capture_message(
            'Authenticate', 'Authenticate::Helper::Client::save_user', 'Authenticate::Helper::Client',
            (caller(0))[3], $res->message
        );
        say $res->message;
    } else {
        $body = $res->body;
    }

    my $result = decode_json($body);
    return $result->{result};
}

async sub register ($self, $userid, $token) {

    my $user->{userid} = $userid;
    $user->{token} = $token;

    my $ua = Mojo::UserAgent->new();

    my $res = $ua->post(
        $self->endpoint_address() . '/api/v1/register' =>
            {'X-Token-Check' => $self->key()} =>
            json => $user
    )->result;
    my $body;
    if($res->is_error){
        $self->capture_message(
            'Authenticate', 'Authenticate::Helper::Client::register', 'Authenticate::Helper::Client',
            (caller(0))[3], $res->message
        );
        say $res->message;
    } else {
        $body = $res->body;
    }

    my $result = decode_json($body);
    return $result->{result};
}

async sub authenticate ($self, $userid, $token) {

    my $user->{userid} = $userid;
    $user->{token} = $token;

    my $ua = Mojo::UserAgent->new();

    my $res = $ua->post(
        $self->endpoint_address() . '/api/v1/authenticate' =>
            {'X-Token-Check' => $self->key()} =>
            json => $user
    )->result;
    my $body;
    if($res->is_error){
        $self->capture_message(
            'Authenticate', 'Authenticate::Helper::Client::register', 'Authenticate::Helper::Client',
            (caller(0))[3], $res->message
        );
        say $res->message;
    } else {
        $body = $res->body;
    }

    my $result = decode_json($body);
    return $result->{result};
}
1;