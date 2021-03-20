#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use Authenticate::Helper::Client;
use feature 'signatures';
use feature 'say';

sub save_user {

    my $test = 1;

    Authenticate::Helper::Client->new(
        key              => '5210cc3e-8653-44ab-8498-99dd6b12921b',
        endpoint_address => 'http://127.0.0.1:3024'
    )->save_user(
        'kalle4@test', 'Kalle Test', 1, 'Fenix Norr:q81k', 1
    )->then(sub($result){

        return $result;
    })->catch(sub($err) {
        say $err;
    })->wait;

}

sub register {

    my $test = 1;

    Authenticate::Helper::Client->new(
        key              => '5210cc3e-8653-44ab-8498-99dd6b12921b',
        endpoint_address => 'http://127.0.0.1:3024'
    )->register(
        'kalle£test', '6194d075-1580-455a-bc67-1e381d38cdc6'
    )->then(sub($result){

        say "result " . $result;
        return $result->{result};
    })->catch(sub($err) {
        say $err;
        return $err;
    })->wait;
}

sub authenticate {

    my $test = 1;

    Authenticate::Helper::Client->new(
        key              => '5210cc3e-8653-44ab-8498-99dd6b12921b',
        endpoint_address => 'http://127.0.0.1:3024'
    )->authenticate (
        'kalle£test', '6194d075-1580-455a-bc67-1e381d38cdc6', 'WebShop'
    )->then(sub($result){

        say "result " . $result;
        return $result->{userid};
    })->catch(sub($err) {
        say $err;
        return $err;
    })->wait;
}

#ok(authenticate() > 1);
#ok(register() > 1);
ok(save_user() > 1);


done_testing();

