
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
    CONSTRAINT users_token_pkey PRIMARY KEY (users_token_pkey),
    CONSTRAINT users_token FOREIGN KEY (users_fkey)
        REFERENCES public.users (users_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

-- 1 down

-- 2 up

create table if not exists system
(
    system_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    system varchar not null UNIQUE,
    support integer default 0,
    CONSTRAINT system_pkey PRIMARY KEY (system_pkey)
);

create table if not exists access
(
    access_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    system_fkey bigint not null,
    users_fkey bigint not null,
    CONSTRAINT access_pkey PRIMARY KEY (access_pkey),
    CONSTRAINT idx_access_users_fkey FOREIGN KEY (users_fkey)
        REFERENCES users (users_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT idx_access_system_fkey FOREIGN KEY (system_fkey)
        REFERENCES system (system_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX idx_access_system_fkey_users_fkey
    ON access(system_fkey, users_fkey);

INSERT INTO system (system, support)
VALUES ('WebShop', 0),
       ('Admin', 1),
       ('Matorit', 1),
       ('Authenticate', 1),
       ('OrionCom', 1),
       ('Parameters', 0),
       ('Order', 0),
       ('Messenger', 1),
       ('Translations', 0),
       ('Sentinel', 1),
       ('Importer', 1),
       ('OrionSync', 1),
       ('DMS', 1),
       ('Mailer', 1),
       ('Statistics', 0),
       ('Basket', 0);



-- 2 down