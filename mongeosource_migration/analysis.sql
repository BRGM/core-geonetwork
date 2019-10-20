-- Check source = 93+1 = 94
SELECT count(*) FROM sources;
-- = 95
SELECT count(*) FROM groups;
-- = 93
SELECT count(*) FROM users WHERE username LIKE 'admin_%';

-- Node with records after migration = 39 node
SELECT groupOwner, count(*) FROM metadata GROUP BY 1

-- Number of records per node = 73 node with data
SELECT node, count(*) FROM mgs_tmp_uuids GROUP BY 1 ORDER BY 1;


SELECT node, count(*) AS total,
    count(*) FILTER (WHERE isHarvested = 'y') AS harvested,
    count(*) FILTER (WHERE isTemplate = 'y') AS template
     FROM mgs_tmp_uuids GROUP BY 1 ORDER BY 1;


-- Number of node with only harvested records = 35 (93 - 35 = 58)
SELECT node FROM (
    SELECT node, count(*) AS total,
        count(*) FILTER (WHERE isHarvested = 'y') AS harvested,
        count(*) FILTER (WHERE isTemplate = 'y') AS template
         FROM mgs_tmp_uuids GROUP BY 1
         ) AS stat WHERE total - template = harvested ORDER BY 1;


-- Number of node with only template records = 24 (93 - 35 - 24 = 34)
SELECT node FROM (
    SELECT node, count(*) AS total,
        count(*) FILTER (WHERE isHarvested = 'y') AS harvested,
        count(*) FILTER (WHERE isTemplate = 'y') AS template
         FROM mgs_tmp_uuids GROUP BY 1
         ) AS stat WHERE total = template ORDER BY 1;


-- Number of duplicates = 970
SELECT uuid, count(*) FROM mgs_tmp_uuids GROUP BY 1 HAVING count(*) > 1 ORDER BY 1;


-- Number of duplicates which are not harvested nor templates = 13
SELECT uuid, count(*), string_agg(node::text, ', ') FROM mgs_tmp_uuids WHERE isharvested = 'n' AND istemplate = 'n' GROUP BY 1 HAVING count(*) > 1 ORDER BY 1;

"462139af-c66c-49b7-89ae-0338429b597d";3
"47caa33a-192d-4823-8289-765a4d145637";3
"64b16942-ac3b-4301-aaa2-ee913ff3bd9c";2
"705547";8
"a7a156ff-53da-47a3-b8b5-5c329d949539";2
"FR-2016-8jJPkiGwr4vt_101812H10M55S";24
"FR-2018-4OBsFNzvykH9_121016H42M29S";3
"GPU_INSPIRE_DOWNLOAD_SERVICE.xml";3
"gputest_PREPACKAGEDOWNLOAD_EXTERNAL.xml";5
"gputest_WMSVECTOR_EXTERNAL.xml";6
"IGNF_BDORTHOr_2-0.xml";2
"IGNF_BDPARCELLAIREr_1-2.xml";2
"N_ENJEU_PPRN_AAAANNNN_S_ddd";2


-- Duplicates in non regular template
SELECT uuid, count(*) FROM mgs_tmp_uuids WHERE istemplate = 'y' uuid NOT IN ('6988a57c-6f34-4f07-8041-a0107f8a5194',
'df70e860-107d-4ad4-9ce2-c31de8dbf898',
'4eb383bc-2726-4888-bc32-71680f2a315b',
'dd2c2542-b860-4fbb-91fe-a45e345a8d1c',
'ce1a7445-d6fe-4148-8e6b-190e4c63cf71',
'892dcf76-b83e-4179-a031-0311d7f0f9f5',
'927fa081-fec0-4c24-9eb6-fa87a54fbc3a',
'af616d57-4907-4969-9ba0-6596530fa5a9',
'a6b792c6-d694-4c0e-9aad-cb408f1c773d',
'ed999990-8109-47e1-9687-07363b6bd00a') GROUP BY 1 HAVING count(*) > 1;


SELECT * FROM mgs_tmp_uuids WHERE uuid IN (
'462139af-c66c-49b7-89ae-0338429b597d',
'47caa33a-192d-4823-8289-765a4d145637',
'64b16942-ac3b-4301-aaa2-ee913ff3bd9c',
'705547',
'a7a156ff-53da-47a3-b8b5-5c329d949539',
'FR-2016-8jJPkiGwr4vt_101812H10M55S',
'FR-2018-4OBsFNzvykH9_121016H42M29S',
'GPU_INSPIRE_DOWNLOAD_SERVICE.xml',
'gputest_PREPACKAGEDOWNLOAD_EXTERNAL.xml',
'gputest_WMSVECTOR_EXTERNAL.xml',
'IGNF_BDORTHOr_2-0.xml',
'IGNF_BDPARCELLAIREr_1-2.xml',
'N_ENJEU_PPRN_AAAANNNN_S_ddd');

-- Number of non harvested records per node
SELECT node, count(*) FROM mgs_tmp_uuids WHERE isHarvested='n' GROUP BY 1;


-- List of harvester
SELECT * FROM mgs_tmp_harvesters WHERE value LIKE 'http%' ORDER BY value

1047;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESBRE"
1042;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN"
1045;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN"
1050;"http://api.isogeo.com/services/ows/g/assad_personalis/c/donnees-iau/uYjokwZ7LdXP-JvGbCM30bptrJoc0?service=CSW&version=2.0.2&request=GetCapabilities"
1002;"http://cartorisque.prim.net/wms/france?"
1002;"http://cartorisque.prim.net/wms/france?service=WMS&request=GetCapabilities"
1139;"http://geocatalogue.siglr.org/geonetwork/srv/fr/csw?"
1042;"http://ids.pigma.org/geonetwork/srv/fre/csw?CONSTRAINTLANGUAGE=FILTER"
1001;"http://metadata.carmencarto.fr/geosource/114/fre/csw"
1145;"http://oai.brgm.fr/entries/littorallro"
1001;"http://oai.brgm.fr/entries/oca/"
1066;"http://oai.brgm.fr/entries/sigesals/"
1044;"http://oai.brgm.fr/entries/sigesaqi/"
1047;"http://oai.brgm.fr/entries/sigesbre/"
1045;"http://oai.brgm.fr/entries/sigescen/"
1046;"http://oai.brgm.fr/entries/sigesmpy/"
1043;"http://oai.brgm.fr/entries/sigesnpc/"
1049;"http://oai.brgm.fr/entries/sigespal/"
1048;"http://oai.brgm.fr/entries/sigespoc/"
1184;"http://oai.brgm.fr/entries/sigesrm/"
1183;"http://oai.brgm.fr/entries/sigessn/"
1001;"https://www.pigma.org/geonetwork/srv/fre/csw-littoral_oca"
1139;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"
1139;"http://www.geocatalogue.fr/api-public/view/servicesRest?SERVICE=CSW&VERSION=2.0.2"
1263;"http://www.sigogne.org/geosource/srv/fre/csw?"
1006;"http://www.web.isogeo.fr/services/ows/EKVIPA9XTsn4wviP2MYGHslkfXpsxkaXS8I0C9iTfJxjfcrkRuYVLE?service=CSW&version=2.0.2&request=GetCapabilities"






-- 404 / Supprimer le 13 février 2019
1047;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESBRE"
1042;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN"
1045;"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN"
1145;"http://oai.brgm.fr/entries/littorallro"
1001;"http://oai.brgm.fr/entries/oca/"
1066;"http://oai.brgm.fr/entries/sigesals/"
1044;"http://oai.brgm.fr/entries/sigesaqi/"
1047;"http://oai.brgm.fr/entries/sigesbre/"
1045;"http://oai.brgm.fr/entries/sigescen/"
1046;"http://oai.brgm.fr/entries/sigesmpy/"
1043;"http://oai.brgm.fr/entries/sigesnpc/"
1049;"http://oai.brgm.fr/entries/sigespal/"
1048;"http://oai.brgm.fr/entries/sigespoc/"
1184;"http://oai.brgm.fr/entries/sigesrm/"
1183;"http://oai.brgm.fr/entries/sigessn/"

-- 404
1002;"http://cartorisque.prim.net/wms/france?"
1002;"http://cartorisque.prim.net/wms/france?service=WMS&request=GetCapabilities"
1042;"http://ids.pigma.org/geonetwork/srv/fre/csw?CONSTRAINTLANGUAGE=FILTER"
1001;"http://metadata.carmencarto.fr/geosource/114/fre/csw"
1006;"http://www.web.isogeo.fr/services/ows/EKVIPA9XTsn4wviP2MYGHslkfXpsxkaXS8I0C9iTfJxjfcrkRuYVLE?service=CSW&version=2.0.2&request=GetCapabilities"

-- 200 = ok
1050;"http://api.isogeo.com/services/ows/g/assad_personalis/c/donnees-iau/uYjokwZ7LdXP-JvGbCM30bptrJoc0?service=CSW&version=2.0.2&request=GetCapabilities"
1139;"http://geocatalogue.siglr.org/geonetwork/srv/fr/csw?"
1001;"https://www.pigma.org/geonetwork/srv/fre/csw-littoral_oca"
1263;"http://www.sigogne.org/geosource/srv/fre/csw?"

-- 200 GéoCatalogue
1139;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"





SELECT node, count(*) FROM mgs_tmp_uuids GROUP BY 1;
NOT IN ('6988a57c-6f34-4f07-8041-a0107f8a5194',
'df70e860-107d-4ad4-9ce2-c31de8dbf898',
'4eb383bc-2726-4888-bc32-71680f2a315b',
'dd2c2542-b860-4fbb-91fe-a45e345a8d1c',
'ce1a7445-d6fe-4148-8e6b-190e4c63cf71',
'892dcf76-b83e-4179-a031-0311d7f0f9f5',
'927fa081-fec0-4c24-9eb6-fa87a54fbc3a',
'af616d57-4907-4969-9ba0-6596530fa5a9',
'a6b792c6-d694-4c0e-9aad-cb408f1c773d',
'ed999990-8109-47e1-9687-07363b6bd00a')



-- Get list of harvester settings
WITH RECURSIVE harvesterSettingsHierarchy AS
(
  SELECT
    id              AS id,
    0               AS number_of_ancestors,
    ARRAY [id]      AS ancestry,
    ARRAY [name]::character varying     AS name,
    ARRAY [value]::character varying     AS value,
    NULL :: INTEGER AS parent,
    id              AS start_of_ancestry
  FROM harvesterSettings
  WHERE
    parentId IS NULL
  UNION
  SELECT
    s.id                                    AS id,
    p.number_of_ancestors + 1                   AS ancestry_size,
    array_append(p.ancestry, s.id)          AS ancestry,
    concat(p.name, '/', s.name::character varying)          AS name,
    s.value::character varying          AS value,
    s.parentId                                AS parent,
    coalesce(p.start_of_ancestry, s.parentId) AS start_of_ancestry
  FROM harvesterSettings s
    INNER JOIN harvesterSettingsHierarchy p ON p.id = s.parentId
)
SELECT
  id,
  number_of_ancestors,
  ancestry,
  name,
  value,
  parent,
  start_of_ancestry
FROM harvesterSettingsHierarchy;





SELECT a.node,
  a.value AS protocol,
  b.value AS url,
  c.value AS name
FROM mgs_tmp_harvesters a, mgs_tmp_harvesters b, mgs_tmp_harvesters c
WHERE
  a.node = b.node AND a.node = c.node
  AND a.name = '{harvesting}node'
  AND b.name in ('{harvesting}nodesiteurl', '{harvesting}nodesitecapabUrl')
  AND replace(b.path, '}', '') LIKE concat(replace(a.path, '}', ''), '%')
  AND c.name = '{harvesting}nodesitename'
  AND replace(c.path, '}', '') LIKE concat(replace(a.path, '}', ''), '%')
ORDER BY protocol, url, node


1050;"csw";"http://api.isogeo.com/services/ows/g/assad_personalis/c/donnees-iau/uYjokwZ7LdXP-JvGbCM30bptrJoc0?service=CSW&version=2.0.2&request=GetCapabilities";"Isogeo"
1260;"csw";"http://ids.pigma.org/geonetwork/srv/fre/csw?";"Test PIGMA"
1042;"csw";"http://ids.pigma.org/geonetwork/srv/fre/csw?CONSTRAINTLANGUAGE=FILTER";"PIGMA"
1001;"csw";"http://metadata.carmencarto.fr/geosource/114/fre/csw";"OCA CARMEN"
1001;"csw";"https://www.pigma.org/geonetwork/srv/fre/csw-littoral_oca";"PIGMA2016"
1260;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?";"géocat"
1139;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW";"geocat"
1040;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities";"DREAL LR - Géocatalogue National"
1040;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities";"IGN - GeoCatalogue National"
1040;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities";"Géocatalogue National - Hérault"
1040;"csw";"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities";"SIG L-R - Géocatalogue National"
1139;"csw";"http://www.geocatalogue.fr/api-public/view/servicesRest?SERVICE=CSW&VERSION=2.0.2";"geoportail"
1260;"csw";"http://www.mongeosource.fr/geosource/1270/fre/csw?";"test geoportail urbanisme"
1263;"csw";"http://www.sigogne.org/geosource/srv/fre/csw?";"sigogne"
1006;"csw";"http://www.web.isogeo.fr/services/ows/EKVIPA9XTsn4wviP2MYGHslkfXpsxkaXS8I0C9iTfJxjfcrkRuYVLE?service=CSW&version=2.0.2&request=GetCapabilities";"Isogeo"
1047;"oaipmh";"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESBRE";"SIGES BRE AELB"
1042;"oaipmh";"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN";"AELB_sigesref"
1045;"oaipmh";"http://administrateur:IamRoot16@proxyoai.brgm.fr/output/OAIDC/DocAELBpourSIGESCEN";"AELB"
1145;"oaipmh";"http://oai.brgm.fr/entries/littorallro";"OAI BRGM"
1001;"oaipmh";"http://oai.brgm.fr/entries/oca/";"OCA BRGM"
1066;"oaipmh";"http://oai.brgm.fr/entries/sigesals/";"SIGES AR"
1044;"oaipmh";"http://oai.brgm.fr/entries/sigesaqi/";"SIGES AQI"
1047;"oaipmh";"http://oai.brgm.fr/entries/sigesbre/";"SIGES BRE BRGM"
1045;"oaipmh";"http://oai.brgm.fr/entries/sigescen/";"SIGES CEN BRGM"
1046;"oaipmh";"http://oai.brgm.fr/entries/sigesmpy/";"SIGES MPY BRGM"
1043;"oaipmh";"http://oai.brgm.fr/entries/sigesnpc/";"SIGES NPC"
1049;"oaipmh";"http://oai.brgm.fr/entries/sigespal/";"SIGES PAL BRGM"
1048;"oaipmh";"http://oai.brgm.fr/entries/sigespoc/";"SIGES POC BRGM"
1184;"oaipmh";"http://oai.brgm.fr/entries/sigesrm/";"SIGESRM"
1183;"oaipmh";"http://oai.brgm.fr/entries/sigessn/";"SIGES SN BRGM"
1002;"ogcwxs";"http://cartorisque.prim.net/wms/france?";"cartorisque"
1002;"ogcwxs";"http://cartorisque.prim.net/wms/france?service=WMS&request=GetCapabilities";"cartorisques"

-- Duplicate UUIDs
SELECT distinct(uuid), isHarvested, isTemplate, schemaId, count(*)
FROM mgs_tmp_uuids
GROUP by 1, 2, 3, 4
HAVING count(*) > 1
ORDER BY 5 desc;

-- Duplicate UUIDs
SELECT distinct(uuid), isHarvested, isTemplate, schemaId, count(*)
FROM mgs_tmp_uuids
WHERE schemaid != 'dublin-core'
  AND isTemplate = 'n'
GROUP by 1, 2, 3, 4
HAVING count(*) > 1
ORDER BY 5 desc;



SELECT *
FROM mgs_tmp_uuids
WHERE uuid = '462139af-c66c-49b7-89ae-0338429b597d';


SELECT dblink_connect('host=localhost user=www-data password=www-data dbname=mongn_db_1001');


SELECT *
FROM dblink(
             'host=localhost user=www-data password=www-data dbname=mongn_db_1001',
             'SELECT uuid FROM metadata') AS t1(uuid text)


WITH ns AS (
select ARRAY[ARRAY['xlink', 'http://www.w3.org/1999/xlink'],
       ARRAY['gmd', 'http://www.isotc211.org/2005/gmd'],
       ARRAY['xsi', 'http://www.w3.org/2001/XMLSchema-instance'],
       ARRAY['gco', 'http://www.isotc211.org/2005/gco']] AS n
)

SELECT distinct(unnest(xpath('//@xsi:schemaLocation',
 XMLPARSE(DOCUMENT data), n)))::text  AS node
FROM metadata, ns
WHERE data LIKE '%%'

"http://www.isotc211.org/2005/gmd http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd http://www.isotc211.org/2005/gmx http://schemas.opengis.net/iso/19139/20060504/gmx/gmx.xsd"
"http://www.isotc211.org/2005/gfc http://www.isotc211.org/2005/gfc/gfc.xsd"
" http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd"
"http://www.isotc211.org/2005/gmd ../schemas/iso19139fra/gmd/gmd.xsd"
"http://www.isotc211.org/2005/gmx http://schemas.opengis.net/iso/19139/20060504/gmx/gmx.xsd"
"http://www.isotc211.org/2005/gfc ../../../../web/geonetwork/xml/schemas/iso19110/schema.xsd"
"http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd"
"http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd"
"http://www.isotc211.org/2005/gmd http://www.isotc211.org/2005/gmd/gmd.xsd http://www.isotc211.org/2005/srv http://schemas.opengis.net/iso/19139/20060504/srv/srv.xsd"
"http://www.isotc211.org/2005/gmd http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd"






WITH ns AS (
select ARRAY[ARRAY['xlink', 'http://www.w3.org/1999/xlink'],
       ARRAY['gmd', 'http://www.isotc211.org/2005/gmd'],
       ARRAY['xsi', 'http://www.w3.org/2001/XMLSchema-instance'],
       ARRAY['gco', 'http://www.isotc211.org/2005/gco']] AS n
)

SELECT uuid,
       xpath('@xsi:schemaLocation', node, n) as schemaLocation
FROM (
SELECT uuid, unnest(xpath('/',  XMLPARSE(DOCUMENT data), n))  AS node
FROM metadata, ns
WHERE data LIKE '%%'
  ) sub, ns
