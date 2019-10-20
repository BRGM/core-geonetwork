
-- Store list of UUIDS
DROP TABLE IF EXISTS mgs_tmp_uuids;
CREATE TABLE mgs_tmp_uuids
(
    uuid        character varying(250),
    id          int,
    node        character varying(128),
    isHarvested character varying(1),
    isTemplate  character varying(1),
    schemaId    character varying(50)
);
DROP TABLE IF EXISTS mgs_tmp_siteids;
CREATE TABLE mgs_tmp_siteids
(
    uuid        character varying(250),
    node        character varying(128)
);

-- Store harvester main props
DROP TABLE IF EXISTS mgs_tmp_harvesters;
CREATE TABLE mgs_tmp_harvesters
(
    node  character varying(128),
    path  text,
    name  text,
    value text
);

DROP TABLE IF EXISTS mgs_uuid_map;
CREATE TABLE mgs_uuid_map
(
    node        character varying(128),
    oldid       integer NOT NULL,
    newid       integer NOT NULL,
    uuid        character varying(128)
);


DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes
(
    id       character varying(128),
    name     text,
    path     character varying(128),
    username character varying(128),
    password character varying(128)
);

INSERT INTO nodes VALUES ('fcb', 'FCB', 'mongnafb_catalogue_fcb', 'admin_fcb', '');
INSERT INTO nodes VALUES ('pag', 'PAG', 'mongnafb_catalogue_pag', 'admin_pag', '');
INSERT INTO nodes VALUES ('pnc', 'PNC', 'mongnafb_catalogue_pnc', 'admin_pnc', '');
INSERT INTO nodes VALUES ('pncal', 'PNCAL', 'mongnafb_catalogue_pncal', 'admin_pncal', '');
INSERT INTO nodes VALUES ('pne', 'PNE', 'mongnafb_catalogue_pne', 'admin_pne', '');
INSERT INTO nodes VALUES ('pnf', 'PNF', 'mongnafb_catalogue_pnf', 'admin_pnf', '');
INSERT INTO nodes VALUES ('png', 'PNG', 'mongnafb_catalogue_png', 'admin_png', '');
INSERT INTO nodes VALUES ('pnm', 'PNM', 'mongnafb_catalogue_pnm', 'admin_pnm', '');
INSERT INTO nodes VALUES ('pnp', 'PNP', 'mongnafb_catalogue_pnp', 'admin_pnp', '');
INSERT INTO nodes VALUES ('pnpc', 'PNPC', 'mongnafb_catalogue_pnpc', 'admin_pnpc', '');
INSERT INTO nodes VALUES ('pnrun', 'PNRUN', 'mongnafb_catalogue_pnrun', 'admin_pnrun', '');
INSERT INTO nodes VALUES ('pnv', 'PNV', 'mongnafb_catalogue_pnv', 'admin_pnv', '');
-- INSERT INTO nodes VALUES ('pnx', 'PNX', 'mongnafb_catalogue_pnx', 'admin_pnx', '');
