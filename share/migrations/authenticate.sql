
-- 1 up

create table if not exists users
(
    users_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    userid varchar(100) not null,
    username varchar(100),
    passwd varchar(100) not null,
    active BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT users_pkey PRIMARY KEY (users_pkey)
);

CREATE UNIQUE INDEX  idx_users_userid
    ON users USING btree
        (userid);

create table if not exists users_token
(
    users_token_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    token varchar(100),
    expiers timestamp without time zone NOT NULL DEFAULT NOW() + interval '8 hour',
    users_fkey bigint not null UNIQUE,
    CONSTRAINT users_token_pkey PRIMARY KEY (users_token_pkey)
        USING INDEX TABLESPACE "webshop",
    CONSTRAINT users_token FOREIGN KEY (users_fkey)
        REFERENCES public.users (users_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

-- 1 down