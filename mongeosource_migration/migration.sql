
CREATE OR REPLACE FUNCTION mgs_empty()
    RETURNS VOID AS
$$
DECLARE
BEGIN
    RAISE NOTICE 'Emptying db';
    DELETE FROM operationallowed;
    DELETE FROM metadata;
    DELETE FROM sources WHERE type = 'subportal';
    DELETE FROM usergroups WHERE userid > 1;
    DELETE FROM users WHERE id > 1;
    DELETE FROM groupsdes WHERE iddes > 2;
    DELETE FROM groups WHERE id > 2;
    DELETE FROM mgs_uuid_map;
    DELETE FROM mgs_tmp_siteids;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION mgs_migrate(character varying,integer,character varying,character varying,character varying,character varying);

CREATE OR REPLACE FUNCTION mgs_migrate(
    dbhost varchar DEFAULT 'localhost',
    dbport int DEFAULT 5432,
    dbusername varchar DEFAULT 'www-data',
    dbpassword varchar DEFAULT 'www-data',
    dbname varchar DEFAULT 'mongn_db_',
    systemPath varchar DEFAULT '/tmp'
)
    RETURNS VOID AS
$$
DECLARE
    rec    RECORD;
    usersRec    RECORD;
    recordsRec    RECORD;
    dblinkstatus    RECORD;
    usersList varchar[];
    usersInMoreThanOneNodeList varchar[];
    userId int;
    userAdminId int;
    ownerId int;
    userIdSeq int;
    recordId int;
    recordIdSeq int;
    recordPublishedCount int;
    userIdMap int[][];
    dbfullname varchar;
    dblink varchar;
    userAdminProfile int;
    reviewerProfile int;
    editorProfile int;
BEGIN
    userAdminProfile := 1;
    reviewerProfile := 2;
    editorProfile := 3;
    PERFORM mgs_empty();
    FOR rec IN SELECT id, name, path, username, password
               FROM nodes
               ORDER BY id
        LOOP
            userIdSeq := 0;
            recordIdSeq := 0;
            RAISE NOTICE 'Migrating node #%', rec.id;
            -- DBLink is used to connect to remote database
            -- It requires read only access.
            dbfullname := dbname || rec.id;
            dblink := 'host=' || dbhost ||
                      ' port=' || dbport ||
                      ' user=' || dbusername ||
                      ' password=' || dbpassword || ' dbname=' || dbfullname;

            SELECT dblink_connect(dblink) INTO dblinkstatus;
            RAISE NOTICE 'Dblink status: %', dblinkstatus.dblink_connect;
            CONTINUE WHEN dblinkstatus.dblink_connect != 'OK';
            CONTINUE WHEN rec.id >= 1373; -- Skip due to missing setting table
            -- TODO: Check db link is valid

            -- Transfer all UUIDs to identify duplicates
            RAISE NOTICE '#% Transfer all UUIDs to identify duplicates ...', rec.id;
            EXECUTE format(
                    'INSERT INTO mgs_tmp_uuids (SELECT * FROM dblink(''%s'', ''SELECT uuid, id, %s, isHarvested, isTemplate, schemaid  FROM metadata WHERE isTemplate in (''''y'''', ''''n'''')'') AS t1(uuid varchar, id int, node int, isHarvested varchar, isTemplate varchar, schemaid varchar))',
                    dblink, rec.id);

            -- Get list of harvester settings (type/url/name) to identify duplicates
            RAISE NOTICE '#% Get list of harvester settings (type/url/name) to identify duplicates ...', rec.id;
            EXECUTE format(
                    'INSERT INTO mgs_tmp_harvesters (SELECT * FROM dblink(''%s'', ''WITH RECURSIVE harvesterSettingsHierarchy AS'
                        '('
                        '  SELECT'
                        '    id              AS id,'
                        '    0               AS number_of_ancestors,'
                        '    ARRAY [id]      AS ancestry,'
                        '    ARRAY [name]::character varying     AS name,'
                        '    ARRAY [value]::character varying     AS value,'
                        '    NULL :: INTEGER AS parent,'
                        '    id              AS start_of_ancestry'
                        '  FROM harvesterSettings'
                        '  WHERE'
                        '    parentId IS NULL'
                        '  UNION'
                        '  SELECT'
                        '    s.id                                    AS id,'
                        '    p.number_of_ancestors + 1                   AS ancestry_size,'
                        '    array_append(p.ancestry, s.id)          AS ancestry,'
                        '    concat(p.name, s.name::character varying)          AS name,'
                        '    s.value::character varying          AS value,'
                        '    s.parentId                                AS parent,'
                        '    coalesce(p.start_of_ancestry, s.parentId) AS start_of_ancestry'
                        '  FROM harvesterSettings s'
                        '    INNER JOIN harvesterSettingsHierarchy p ON p.id = s.parentId'
                        ') '
                        'SELECT %s,'
                        '  ancestry,'
                        '  name,'
                        '  value '
                        'FROM harvesterSettingsHierarchy'') AS t1(node int, path text, name text, value text))', dblink,
                    rec.id);


            -- Create one group per node
            -- Group id is node id eg. 1001
            RAISE NOTICE '#% Create one group per node ...', rec.id;
            EXECUTE format(
                    'INSERT INTO mgs_tmp_siteids (node, uuid) SELECT * FROM dblink(''%s'', '''
                        'SELECT ''''%s'''', value '
                        ' FROM settings '
                        'WHERE name = ''''system/site/siteId'''''''
                        ') AS t1(node int, uuid varchar)',
                    dblink, rec.id);
            INSERT INTO groups (id, name, logo) VALUES (rec.id, rec.id, rec.id || '.gif');
            RAISE NOTICE '#% Set group label ...', rec.id;
            EXECUTE format(
                    'INSERT INTO groupsdes (iddes, label, langid) VALUES (%s, ''%s'', ''fre'')',
                    rec.id, REPLACE(rec.name, '''', ''''''));
            EXECUTE format(
                    'INSERT INTO groupsdes (iddes, label, langid) VALUES (%s, ''%s'', ''eng'')',
                    rec.id, REPLACE(rec.name, '''', ''''''));


            -- Create one user admin per node
            -- User id is node id + one numeric eg. 100100
            userAdminId := replace(format('%s%2s', rec.id, userIdSeq), ' ', '0')::int;
            ownerId := userAdminId;
            RAISE NOTICE '#% Create one user admin (%) per node ...', rec.id, userId;
            EXECUTE format(
                    'INSERT INTO users (id, name, profile, password, surname, username) VALUES (%s, ''%s'', %s, ''%s'', ''%s'', ''%s'')',
                    userAdminId, rec.username, userAdminProfile, '', '', rec.username);

            usersList := array_prepend(rec.username, usersList);

            -- Assign portal group to user admin with profiles
            RAISE NOTICE '#% Assign portal group to user admin with profiles ...', rec.id;
            INSERT INTO usergroups (groupid, profile, userid) VALUES (rec.id, userAdminProfile, userAdminId);
            INSERT INTO usergroups (groupid, profile, userid) VALUES (rec.id, reviewerProfile, userAdminId);
            INSERT INTO usergroups (groupid, profile, userid) VALUES (rec.id, editorProfile, userAdminId);


            -- Update user properties from source node info
            RAISE NOTICE '#% Copy users ...', rec.id;
            FOR usersRec IN EXECUTE format(
                    'SELECT * FROM dblink(''%s'', ''SELECT id, password, username, profile, surname, name, organisation, security FROM users'') AS t1(id int, password varchar, username varchar, profile varchar, surname varchar, name varchar, organisation varchar, security varchar)',
                    dblink)
                LOOP
                    RAISE NOTICE ' - % ...', usersRec.username;
                    IF usersRec.username = rec.username THEN
                        RAISE NOTICE '  Updating % with node info ...', usersRec.username;
                        UPDATE users
                        SET (password, security, surname, name, organisation)
                                = (usersRec.password, usersRec.security, usersRec.surname, usersRec.name, usersRec.organisation)
                        WHERE users.username = usersRec.username;
                        userIdMap := array_cat(ARRAY[usersRec.id, userAdminId], userIdMap);
                    ELSE
                        -- New user
                        IF usersRec.username = ANY(usersList) THEN
                            RAISE WARNING '  User already created %. TODO: Manually assign user', usersRec.username;
                            usersInMoreThanOneNodeList := array_prepend(usersRec.username, usersInMoreThanOneNodeList);
                        ELSEIF usersRec.username = 'admin' THEN
                            RAISE WARNING '  User admin already exist';
                        ELSE
                            -- User id is node id + one numeric eg. 100101, 100102
                            userIdSeq := userIdSeq + 1;
                            IF userIdSeq > 99 THEN
                                RAISE EXCEPTION '  User id too big! More than 10 in a node ?';
                            END IF;
                            userId := replace(format('%s%2s', rec.id, userIdSeq), ' ', '0')::int;
                            RAISE NOTICE '  Creating %[profile: %] (%=>%) with node info ...', usersRec.username, usersRec.profile, usersRec.id, userId;

                            -- All users are now reviewer
                            INSERT INTO users (id, username, password, surname, name, organisation, security, profile) VALUES (userId, usersRec.username, usersRec.password, usersRec.surname, usersRec.name, usersRec.organisation, usersRec.security, reviewerProfile);

                            -- TODO: An editor should remain an editor ?
                            INSERT INTO usergroups (groupid, profile, userid) VALUES (rec.id, reviewerProfile, userId);
                            INSERT INTO usergroups (groupid, profile, userid) VALUES (rec.id, editorProfile, userId);

                            userIdMap := array_cat(ARRAY[usersRec.id, userId], userIdMap);
                        END IF;
                        usersList := array_prepend(usersRec.username, usersList);
                    END IF;
                END LOOP;




            -- Create one portal
            RAISE NOTICE '#% Create one space per node ...', rec.id;
            -- TODO: Logo
            INSERT INTO sources (uuid, creationdate, filter, logo, name, type, uiconfig)
            VALUES (rec.id, '2019-10-01T11:11:30', concat('+_groupPublished:', rec.id), concat(rec.id, '.png'), rec.name, 'subportal', null);

            -- TODO: Create one UI configuration

            -- Transfer records
            RAISE NOTICE '#% Copy records ...', rec.id;
            FOR recordsRec IN EXECUTE format(
                    'SELECT * FROM dblink(''%s'', ''SELECT id, data, changedate, createdate, popularity, rating, schemaid, isTemplate, isHarvested, groupowner, owner, source, uuid FROM metadata WHERE schemaId not in (''''fgdc-std'''', ''''iso19115'''') ORDER BY id'') AS t1(id int, data text, changedate varchar, createdate varchar, popularity int, rating int, schemaid varchar, isTemplate varchar, isHarvested varchar, groupowner int, owner int, source varchar, uuid varchar)',
                    dblink)
                LOOP
                    recordPublishedCount := 0;
                    RAISE NOTICE '  - Record % | harvested: % ...', recordsRec.uuid, recordsRec.isHarvested;
                    IF recordsRec.isHarvested = 'y' THEN
                    ELSE
                        -- Record id are rebased on node id + 4 numerics 10010001
                        IF recordIdSeq > 9999 THEN
                            RAISE EXCEPTION '  Record id too big! More than 9999 in a node ?';
                        END IF;
                        recordId := replace(format('%s%4s', rec.id, recordIdSeq), ' ', '0')::int;
                        -- TODO: ownerId should be the original user
                        BEGIN
                            INSERT INTO metadata (id, data, changedate, createdate, popularity, rating, schemaid, isTemplate, isHarvested, groupowner, owner, source, uuid)
                            VALUES (recordId, recordsRec.data, recordsRec.changedate, recordsRec.createdate, recordsRec.popularity, recordsRec.rating, recordsRec.schemaid, recordsRec.isTemplate, recordsRec.isHarvested, rec.id, ownerId, rec.id, recordsRec.uuid);

                            INSERT INTO mgs_uuid_map VALUES (rec.id, recordsRec.id, recordId, recordsRec.uuid);

                            -- Add privileges
                            -- Record is always published in its space
                            INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (rec.id, recordId, 0);
                            INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (rec.id, recordId, 1);
                            INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (rec.id, recordId, 5);
                            INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (rec.id, recordId, 2);
                            INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (rec.id, recordId, 3);

                            -- A public record remains public
                            EXECUTE format(
                                    'SELECT * FROM dblink(''%s'', ''SELECT count(*) AS count FROM operationallowed WHERE metadataId = %s AND groupid = 1 AND operationid = 0'') AS t1(count int)',
                                    dblink, recordsRec.id) INTO recordPublishedCount;
                            IF recordPublishedCount = 1 THEN
                                INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (1, recordId, 0);
                                INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (1, recordId, 1);
                                INSERT INTO operationallowed (groupid, metadataid, operationid) VALUES (1, recordId, 5);
                            END IF;

                        EXCEPTION WHEN unique_violation THEN
                            RAISE WARNING '  Record already exist %. This is a duplicate.', recordsRec.uuid;
                            RAISE WARNING '  %', SQLERRM;
                        END;

                        recordIdSeq := recordIdSeq + 1;
                    END IF;
                END LOOP;
            -- Transfer record privileges
            -- Migrating records

        END LOOP;

    -- Some record are still using iso19139.fra
    -- SELECT count(*) FROM metadata WHERE schemaid = 'iso19139.fra'
    UPDATE metadata SET schemaId = 'iso19139' WHERE schemaid = 'iso19139.fra';
    -- An XSL conversion is required
    -- xsltproc toiso19139.xslt test.xml

    -- Update GML namespace for moving from ISO19139:2005 to ISO19139:2007
    UPDATE Metadata SET data = replace(data, '"http://www.opengis.net/gml"', '"http://www.opengis.net/gml/3.2"') WHERE data LIKE '%"http://www.opengis.net/gml"%' AND schemaid = 'iso19139';

    UPDATE metadata SET data = replace(data, '<gmd:version gco:nilReason="missing">', '<gmd:version gco:nilReason="unknown">') WHERE  data LIKE '%<gmd:version gco:nilReason="missing">%';

    UPDATE Metadata SET data = replace(data, 'http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml', 'http://standards.iso.org/iso/19139/resources/gmxCodelists.xml') WHERE data LIKE '%http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml%' AND schemaid = 'iso19139';

    -- Unset 2005 schemaLocation
    UPDATE Metadata SET data = regexp_replace(data, ' xsi:schemaLocation="[A-Za-z0-9 \/:\.]*"', '') WHERE data LIKE '%xsi:schemaLocation=%';


    -- Invalid date
    -- SELECT * FROM metadata WHERE data LIKE '%>--<%'
    UPDATE metadata SET data = replace(data, '>--<', '><')
    WHERE data LIKE '%>--<%';
    -- SELECT * FROM metadata WHERE data LIKE '%>2014-31-12<%'
    UPDATE metadata SET data = replace(data, '2014-31-12', '2014-12-31')
    WHERE data LIKE '%>2014-31-12<%';
    -- SELECT * FROM metadata WHERE data LIKE '%>25/02/2016<%'
    UPDATE metadata SET data = replace(data, '25/02/2016', '2016-02-25')
    WHERE data LIKE '%>25/02/2016<%';
    UPDATE metadata SET data = replace(data, '29/02/2016', '2016-02-29')
    WHERE data LIKE '%>29/02/2016<%';

    DELETE FROM mgs_tmp_harvesters WHERE value = '';
    DELETE FROM mgs_tmp_harvesters WHERE value = '{NULL}';
    DELETE FROM mgs_tmp_harvesters WHERE node = 1260;

    -- Set sequence to highest id
    PERFORM setval('hibernate_sequence', (SELECT max(id) FROM metadata), true);

    RAISE NOTICE '#% usersList: ', usersList;
    RAISE NOTICE '#% userIdMap: ', userIdMap;
    RAISE NOTICE '#% usersInMoreThanOneNodeList: ', usersInMoreThanOneNodeList;
    EXECUTE 'COPY (SELECT * FROM mgs_uuid_map) TO ''' || systemPath || '/mgs_uuid_map.csv' || ''' WITH CSV';
    EXECUTE 'COPY (SELECT * FROM mgs_tmp_siteids) TO ''' || systemPath || '/mgs_siteids.csv' || ''' WITH CSV';

END;
$$ LANGUAGE plpgsql;


