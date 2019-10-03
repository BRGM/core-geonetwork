
-- Store list of UUIDS
DROP TABLE IF EXISTS mgs_tmp_uuids;
CREATE TABLE mgs_tmp_uuids
(
    uuid        character varying(250),
    id          int,
    node        int,
    isHarvested character varying(1),
    isTemplate  character varying(1),
    schemaId    character varying(50)
);
DROP TABLE IF EXISTS mgs_tmp_siteids;
CREATE TABLE mgs_tmp_siteids
(
    uuid        character varying(250),
    node        int
);

-- Store harvester main props
DROP TABLE IF EXISTS mgs_tmp_harvesters;
CREATE TABLE mgs_tmp_harvesters
(
    node  int,
    path  text,
    name  text,
    value text
);

DROP TABLE IF EXISTS mgs_uuid_map;
CREATE TABLE mgs_uuid_map
(
    node        integer NOT NULL,
    oldid       integer NOT NULL,
    newid       integer NOT NULL,
    uuid        character varying(128)
);


DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes
(
    id       integer NOT NULL,
    name     text,
    path     character varying(128),
    username character varying(128),
    password character varying(128)
);

INSERT INTO nodes
VALUES (1001, 'OCA', 'db_1001', 'admin_1001', '');
INSERT INTO nodes
VALUES (1002, 'MIG (Clément Jaquemet)', 'db_1002', 'admin_1002', '');
INSERT INTO nodes
VALUES (1006, 'Communauté d’Agglomération de Marne et Gondoire', 'db_1006', 'admin_1006', '');
INSERT INTO nodes
VALUES (1009, 'ANGERS LOIRE METROPOLE', 'db_1009', 'admin_1009', '');
INSERT INTO nodes
VALUES (1014, 'MAIRIE DE SAVAS', 'db_1014', 'admin_1014', '');
INSERT INTO nodes
VALUES (1017, 'Département du bas-Rhin ', 'db_1017', 'admin_1017', '');
INSERT INTO nodes
VALUES (1023, 'UMR 6012 - ESPACE - Université de Nice Sophia Antipolis', 'db_1023', 'admin_1023', '');
INSERT INTO nodes
VALUES (1040, 'CG34', 'db_1040', 'admin_1040', '');
INSERT INTO nodes
VALUES (1042, 'SIGES Ref', 'db_1042', 'admin_1042', '');
INSERT INTO nodes
VALUES (1043, 'SIGES NPC', 'db_1043', 'admin_1043', '');
INSERT INTO nodes
VALUES (1044, 'SIGES AQI', 'db_1044', 'admin_1044', '');
INSERT INTO nodes
VALUES (1045, 'SIGES CEN', 'db_1045', 'admin_1045', '');
INSERT INTO nodes
VALUES (1046, 'SIGES MPY', 'db_1046', 'admin_1046', '');
INSERT INTO nodes
VALUES (1047, 'SIGES BRE', 'db_1047', 'admin_1047', '');
INSERT INTO nodes
VALUES (1048, 'SIGES POC', 'db_1048', 'admin_1048', '');
INSERT INTO nodes
VALUES (1049, 'SIGES PAL', 'db_1049', 'admin_1049', '');
INSERT INTO nodes
VALUES (1050, 'IAU IDF', 'db_1050', 'admin_1050', '');
INSERT INTO nodes
VALUES (1051, 'DDT 95', 'db_1051', 'admin_1051', '');
INSERT INTO nodes
VALUES (1062, 'DREAL Nord - Pas de Calais ', 'db_1062', 'admin_1062', '');
INSERT INTO nodes
VALUES (1066, 'SIGES Alsace', 'db_1066', 'admin_1066', '');
INSERT INTO nodes
VALUES (1068, 'Commune de Villerbanne', 'db_1068', 'admin_1068', '');
INSERT INTO nodes
VALUES (1080, 'INERIS ', 'db_1080', 'admin_1080', '');
INSERT INTO nodes
VALUES (1088, 'Parc naturel régional des Grands Causses', 'db_1088', 'admin_1088', '');
INSERT INTO nodes
VALUES (1092, 'Le service départemental d''incendie et de secours du Bas-Rhin - SDIS 67', 'db_1092', 'admin_1092',
        '67sdis67082');
INSERT INTO nodes
VALUES (1101, 'SIGES Poitou Charentes (alias sigespoc) ', 'db_1101', 'admin_1101', '');
INSERT INTO nodes
VALUES (1110, 'DREAL Picardie', 'db_1110', 'admin_1110', '');
INSERT INTO nodes
VALUES (1119, 'Observatoire de l’économie et des territoires de Loir-et-Cher', 'db_1119', 'admin_1119', '');
INSERT INTO nodes
VALUES (1129, 'ANSES ', 'db_1129', 'admin_1129', '');
INSERT INTO nodes
VALUES (1139, 'Association SIG L-R', 'db_1139', 'admin_1139', '');
INSERT INTO nodes
VALUES (1145, 'Littoral Languedoc-Roussillon', 'db_1145', 'admin_1145', '');
INSERT INTO nodes
VALUES (1146, 'Asso Coeur emeraude', 'db_1146', 'admin_1146', '');
INSERT INTO nodes
VALUES (1168, 'Service Départemental d’Incendie et de Secours de l’Allier ', 'db_1168', 'admin_1168', '');
INSERT INTO nodes
VALUES (1178, 'Ville de Saint-Brieuc', 'db_1178', 'admin_1178', '');
INSERT INTO nodes
VALUES (1183, 'SIGES SEINE NORMANDIE', 'db_1183', 'admin_1183', '');
INSERT INTO nodes
VALUES (1184, 'SIGES Rhin Meuse', 'db_1184', 'admin_1184', '');
INSERT INTO nodes
VALUES (1191, 'Parc national des Pyrénées', 'db_1191', 'admin_1191', '');
INSERT INTO nodes
VALUES (1192, 'Communauté d’Agglomération Portes de France Thionville ', 'db_1192', 'admin_1192', '');
INSERT INTO nodes
VALUES (1202, 'Bayeux Intercom', 'db_1202', 'admin_1202', '');
INSERT INTO nodes
VALUES (1213, 'Conseil Général de la Haute-Garonne', 'db_1213', 'admin_1213', '');
INSERT INTO nodes
VALUES (1219, 'SDIS08 ', 'db_1219', 'admin_1219', '');
INSERT INTO nodes
VALUES (1225, 'Laboratoire EDYTEM UMR CNRS 5204', 'db_1225', 'admin_1225', '');
INSERT INTO nodes
VALUES (1230, 'MAAF - DGER', 'db_1230', 'admin_1230', '');
INSERT INTO nodes
VALUES (1231, 'SIGosphère', 'db_1231', 'admin_1231', '');
INSERT INTO nodes
VALUES (1237, 'Indre Nature', 'db_1237', 'admin_1237', '');
INSERT INTO nodes
VALUES (1239, 'INRA Dynafor / INP ', 'db_1239', 'admin_1239', '');
INSERT INTO nodes
VALUES (1242, 'Syndicat Mixte d’Etudes et d’Aménagement de la Garonne', 'db_1242', 'admin_1242', '');
INSERT INTO nodes
VALUES (1251, 'CEREMA - DterOuest ', 'db_1251', 'admin_1251', 'D3q49Fxd / nouveau : kfbq50bi');
INSERT INTO nodes
VALUES (1255, 'Conseil régional de la Réunion', 'db_1255', 'admin_1255', 'M6Eils1i / nouveau : 9h4ctbsl');
INSERT INTO nodes
VALUES (1260, 'compte test brgm', 'db_1260', 'admin_1260', '');
INSERT INTO nodes
VALUES (1263, 'SIGOGNE', 'db_1263', 'admin_1263', '');
INSERT INTO nodes
VALUES (1265, 'COMMUNAUTE D''AGGLOMERATION DRACENOISE', 'db_1265', 'admin_1265', '');
INSERT INTO nodes
VALUES (1266, 'Conseil départemental de Meurthe-et-Moselle', 'db_1266', 'admin_1266', '');
INSERT INTO nodes
VALUES (1267, 'Risque et Territoire ', 'db_1267', 'admin_1267', '');
INSERT INTO nodes
VALUES (1271, 'Parc naturel régional des Boucles de la Seine Normande', 'db_1271', 'admin_1271', '');
INSERT INTO nodes
VALUES (1274, 'i-Sea ', 'db_1274', 'admin_1274', '');
INSERT INTO nodes
VALUES (1276, 'Communauté d''agglomération Lens Liévin', 'db_1276', 'admin_1276', '');
INSERT INTO nodes
VALUES (1286, 'Air Normand ', 'db_1286', 'admin_1286', '');
INSERT INTO nodes
VALUES (1287, 'Région PACA', 'db_1287', 'admin_1287', '');
INSERT INTO nodes
VALUES (1289, 'Agrosylva', 'db_1289', 'admin_1289', '');
INSERT INTO nodes
VALUES (1302, 'DDT Indre et Loire', 'db_1302', 'admin_1302', '');
INSERT INTO nodes
VALUES (1304, 'Service National d''Ingénierie Aéroportuaire (SNIA)', 'db_1304', 'admin_1304', '');
INSERT INTO nodes
VALUES (1317, 'Ministère de la Culture / Centre National de Préhistoire', 'db_1317', 'admin_1317', '');
INSERT INTO nodes
VALUES (1319, 'Conservatoire botanique national du Bassin parisien', 'db_1319', 'admin_1319', '');
INSERT INTO nodes
VALUES (1321, 'LEGTA Louis Pasteur', 'db_1321', 'admin_1321', '');
INSERT INTO nodes
VALUES (1324, 'Communauté de Communes du Canton de Rumilly', 'db_1324', 'admin_1324', '');
INSERT INTO nodes
VALUES (1325, 'Communauté d''agglomération d''Haguenau', 'db_1325', 'admin_1325', '');
INSERT INTO nodes
VALUES (1328, 'Lig''Air', 'db_1328', 'admin_1328', '');
INSERT INTO nodes
VALUES (1330, 'SDIS 78', 'db_1330', 'admin_1330', '');
INSERT INTO nodes
VALUES (1331, 'Parc naturel régional du Marais poitevin', 'db_1331', 'admin_1331', '');
INSERT INTO nodes
VALUES (1333, 'Geospatial Strategy', 'db_1333', 'admin_1333', '');
INSERT INTO nodes
VALUES (1334, 'VILLE de LA SEYNE SUR MER', 'db_1334', 'admin_1334', '');
INSERT INTO nodes
VALUES (1340, 'Données et Cie', 'db_1340', 'admin_1340', '');
INSERT INTO nodes
VALUES (1341, 'Hawa Mayotte (Observatoire de la Qualité de l''Air à Mayotte)', 'db_1341', 'admin_1341', '');
INSERT INTO nodes
VALUES (1342, 'AFEPTB', 'db_1342', 'admin_1342', '');
INSERT INTO nodes
VALUES (1345, 'CEREMA - Centre Est  ', 'db_1345', 'admin_1345', '');
INSERT INTO nodes
VALUES (1347, 'Star Ingénierie', 'db_1347', 'admin_1347', '');
INSERT INTO nodes
VALUES (1349, 'Institution Adour', 'db_1349', 'admin_1349', '');
INSERT INTO nodes
VALUES (1351, 'Commune de Saint-Pierre', 'db_1351', 'admin_1351', '');
INSERT INTO nodes
VALUES (1352, 'Atmo Réunion', 'db_1352', 'admin_1352', '');
INSERT INTO nodes
VALUES (1360, 'EPTB Charente', 'db_1360', 'admin_1360', '');
INSERT INTO nodes
VALUES (1364, 'Communauté de Communes Le Grésivaudan', 'db_1364', 'admin_1364', '');
INSERT INTO nodes
VALUES (1367, 'TiGéo', 'db_1367', 'admin_1367', '');
INSERT INTO nodes
VALUES (1369, 'Ville d''Anglet', 'db_1369', 'admin_1369', '');
INSERT INTO nodes
VALUES (1370, 'Département du Rhône', 'db_1370', 'admin_1370', '');
INSERT INTO nodes
VALUES (1373, 'ArScAn_ArcheoFab', 'db_1373', 'admin_1373', 'U0sEmJnm -> hud4410pag%');
INSERT INTO nodes
VALUES (1375, 'GCI CONSTRUCTION', 'db_1375', 'admin_1375', '');
INSERT INTO nodes
VALUES (1376, 'Département du Gard', 'db_1376', 'admin_1376', '');
INSERT INTO nodes
VALUES (1378, 'CACG', 'db_1378', 'admin_1378', '');
INSERT INTO nodes
VALUES (1379, 'Conservtoire du Littoral', 'db_1379', 'admin_1379', '');
INSERT INTO nodes
VALUES (1380, 'Agglomération de Pau', 'db_1380', 'admin_1380', '');
INSERT INTO nodes
VALUES (1381, 'MAIRIE HEROUVILLETTE', 'db_1381', 'admin_1381', '');
INSERT INTO nodes
VALUES (1382, 'Union Régionale des Communes Forestières PACA', 'db_1382', 'admin_1382', '');
INSERT INTO nodes
VALUES (1383, 'Ville d''Ajaccio', 'db_1383', 'admin_1383', '');
