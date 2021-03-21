package Authenticate::Model::User;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

use Try::Tiny;
use Data::UUID;
use Data::Dumper;
use Digest::SHA qw{sha512_base64};

has 'pg';

sub authenticate ($self, $token) {

    return $self->pg->db->query(
        qq{SELECT count(*) loggedin FROM users
            JOIN users_token  ON users_fkey = users_pkey
                    WHERE token = ? },$token
    )->hash->{loggedin};
}

sub login ($self, $user, $password) {

    my $user_obj;
    $password = '' unless $password;

    my $passwd = sha512_base64($password);
    my $result = $self->pg->db->query("select * from users where userid = ? and passwd= ?",($user,$passwd));
    if($result->rows() > 0){
        $user_obj = $result->hash;
        my $ug = Data::UUID->new;
        my $token = $ug->create();
        $token = $ug->to_string($token);

        my $users_pkey = $user_obj->{users_pkey};

        $result = $self->pg->db->query(qq{INSERT INTO users_token (users_fkey, token) VALUES (?,?)
                                    ON CONFLICT (users_fkey) DO UPDATE SET token = ?,
                                        moddatetime = now()},
            ($users_pkey, $token, $token));
        $user_obj->{token} = $token;
    }else{
        $user_obj->{token} = '';
        $user_obj->{error} = 'Username or password is incorrect';
    }

    return $user_obj ;
}

async sub login_check_p ($self, $user, $password, $system) {

    my $user_obj;
    $password = '' unless $password;

    my $stmt = qq {
        SELECT COUNT(*) as login FROM users
        JOIN access
            ON users_fkey = users_pkey
        JOIN system
            ON system_fkey = system_pkey
        WHERE userid = ? AND passwd= ? AND system = ? AND can_login = 1

    };
    my $passwd = sha512_base64($password);
    my $result = $self->pg->db->query(
        $stmt, ($user, $passwd, $system)
    )->hash->{login};

    return $result ;
}

async sub save_user_p ($self, $user) {

    my $stmt;
    my $result;
    delete $user->{passwd} unless $user->{passwd};

    if (exists $user->{passwd}){
        $user->{passwd} = sha512_base64($user->{passwd});
        $stmt = qq{INSERT INTO users (username, userid, active, passwd) VALUES (?,?,?,?)
                    ON CONFLICT (userid) DO UPDATE SET username = ?,
                    passwd = ?, moddatetime = now(), active = ?
                        RETURNING users_pkey};

        return $self->pg->db->query_p($stmt,(
            $user->{username},
            $user->{userid},
            $user->{active},
            $user->{passwd},
            $user->{username},
            $user->{passwd},
            $user->{active}
        ));
    }else{
        $stmt = qq{UPDATE users SET username = ?,
                        moddatetime = now(), active = ? WHERE userid = ?
                    RETURNING users_pkey};

        return $self->pg->db->query_p($stmt,(
            $user->{username},
            $user->{active},
            $user->{userid},
        ));
    }
}

1;