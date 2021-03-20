package Authenticate::Helper::Access;
use Mojo::Base 'Daje::Utils::Sentinelsender', -signatures, -async_await;

has 'pg';

async sub set_access ($self, $users_fkey, $support) {

    $support = 0 unless $support;

    my $systems = $self->pg->db->select('system',
        ['system_pkey'],
        {
            support => [$support, 0]
        }
    )->hashes;

    foreach my $system (@{$systems}) {
        $self->pg->db->insert(
            'access',
            {
                system_fkey => $system->{system_pkey},
                users_fkey  => $users_fkey,
                can_login   => $support,
            },
            {
                on_conflict => undef
            }
        )
    }
};
1;