# MonGeoSource migration


## Requirements

* Tomcat 9
* Java OpenJDK 8
* PostgreSQL 10+ (extensions: postgis + dblink)
 * One database for the new mongeosource
 * One read only user allowed to connect to all old nodes databases to migrate. A db link is used to migrate data from the old databases to the new one.  


## DB analysis

### Records in node

```shell script
-- Number of nodes = 93
-- Number of records per node = 73 nodes with data
-- Number of nodes with only harvested records = 35 (93 - 35 = 58)
-- Number of nodes with only template records = 24 (93 - 35 - 24 = 34)
-- Node with records after migration = 39 node >= 34 (Good)
-- Number of duplicates = 970
-- Number of duplicates which are not harvested nor templates = 13

"462139af-c66c-49b7-89ae-0338429b597d";3;"1267"
http://www.mongeosource.fr/geosource/1267/fre/find?east_collapsed=true&s_search=&s_E_any=462139af-c66c-49b7-89ae-0338429b597d&s_timeType=true&s_scaleOn=false&s_E_hitsperpage=20
2 records removed

"47caa33a-192d-4823-8289-765a4d145637";3;"1325"
http://www.mongeosource.fr/geosource/1325/fre/find?east_collapsed=true&s_search=&s_E_any=47caa33a-192d-4823-8289-765a4d145637&s_timeType=true&s_scaleOn=false&s_E_hitsperpage=20
2 records removed

"64b16942-ac3b-4301-aaa2-ee913ff3bd9c";2;"1325"
1 record removed

"705547";8;"1001, 1251, 1325, 1352, 1370"
Update UUID
1251: > eb187163-b08f-41fd-8726-c0065d7d3956
1325: > 85d31be0-fe26-4e8f-9159-f453adfd5e56
1352: > 8791ccde-2d42-4003-a2be-4570e824ca65
1370: > ffc025bd-7be1-4553-a8f3-0898389ab139

"a7a156ff-53da-47a3-b8b5-5c329d949539";2;"1251"
1 record removed
"gputest_PREPACKAGEDOWNLOAD_EXTERNAL.xml";5;"1251"
4 records removed
"gputest_WMSVECTOR_EXTERNAL.xml";6;"1251"
5 records removed
"GPU_INSPIRE_DOWNLOAD_SERVICE.xml";3;"1251"
2 records removed


"FR-2018-4OBsFNzvykH9_121016H42M29S";3;"1360"
Zones prioritaires du Projet Agro-Environnemental et Climatique (PAEC) de Coulonge et St Hippolyte 
> bf9f0387-e5c9-49d6-8898-6a09d8fd17ad
Délimitation du Projet Agro-Environnemental et Climatique (PAEC) enjeu quantité de Coulonge et St Hippolyte<
> aaf37dad-7d02-45f5-b051-317ba7639931
TODO: A vérifier


"IGNF_BDORTHOr_2-0.xml";2;"1271"
1 record removed

"IGNF_BDPARCELLAIREr_1-2.xml";2;"1271"
1 record removed

"N_ENJEU_PPRN_AAAANNNN_S_ddd";2;"1267"
1 record removed

"FR-2016-8jJPkiGwr4vt_101812H10M55S";24;"1331"




```

### Harvesters

```shell script
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
1139;"http://geocatalogue.siglr.org/geonetwork/srv/fr/csw?" ok
1001;"https://www.pigma.org/geonetwork/srv/fre/csw-littoral_oca"
1263;"http://www.sigogne.org/geosource/srv/fre/csw?"

-- 200 GéoCatalogue
1139;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW"
1040;"http://www.geocatalogue.fr/api-public/servicesRest?service=CSW&version=2.0.2&request=GetCapabilities"
```

So 6 harvesters config to migrate. To be done manually?



## Installation

In `${catalina.base}/properties` copy `WEB-INF/config-db/jdbc.properties`.


In the webapp, update `WEB-INF/config-db/defaultJdbcDatasource.xml` to point to the proper jdbc.properties:

```xml
<context:property-placeholder location="file://${catalina.base}/properties/jdbc.properties" file-encoding="UTF-8"
                                ignore-unresolvable="true" order="1"/>
  
```

Update build to set the property:
```
-Ddb.properties=file://${catalina.base}/properties/jdbc.properties
```

Update `/applications/projets/mongeosource.brgm-rec.fr/start.sh` to set the data directory:

```shell script
export GN_DATADIR=/applications/geosource/data
export GN_SCHEMADIR=/applications/tomcat-instances/mongeosource.brgm-rec.fr/webapps/geosource/WEB-INF/data/config/schema_plugins
export JAVA_OPTS="$JAVA_OPTS -Dgeonetwork.dir=$GN_DATADIR -Dgeonetwork.schema.dir=$GN_SCHEMADIR" CHECKME
export JAVA_OPTS="$JAVA_OPTS -Dhttp.proxyHost=XYZ -Dhttp.proxyPort=3128"
```


Move production database to new server.
* Create database
* Load db dump (eg. script in dumpload/dbdumpload.sh)

Warn user that all changes will not be take into account from now.

Start the application. It will create the new DB structure and default data.

In admin console > Settings, configure host/port and save.

Copy logo

```shell script
cp -rp web/src/main/webapp/WEB-INF/data/data/resources/images/harvesting/* /applications/geosource/data/data/resources/images/harvesting/.
```


## DB migration

* Connect to the database

```shell script
cd mongeosource_migration
psql -h localhost -p 5432 -U www-data -W -d mongn380
```

* The initial database is created when the application was started and run SQL migration

```sql
\i setup.sql
\i nodelist.sql
\i migration.sql
\i emailupdate.sql


SELECT mgs_migrate('localhost', 5432,
   'www-data', 'www-data', 'mongn_db_');

SELECT mgs_migrate('localhost', 5432,
   'mongeosource_admin', 'password', 'db_');

SELECT mgs_migrate('localhost', 5432,
   'www-data', 'www-data', 'mongnafb_catalogue_');
```

Save 2 files (mgs_siteids.csv, mgs_uuid_map.csv) created in /tmp directory to run the next step.

## Data directory migration

* Copy data directory from old VM to the new one using scp
* Then combine all old data directories in one remapping based on new record ids.

```shell script
cd mongeosource_migration
./datadirectory.sh
```


## Catalogue configuration

The catalogue is configured with:

* INSPIRE configuration

![](image/config-inspire.png)

* Logo from old nodes are available

![](image/config-logo.png)

* All portals are listed on http://localhost:8080/geonetwork/srv/api/sources

![](image/portal-list.png)


## Portal configuration

* One portal per node (with a filter set to a publication group)

![](image/config-portal.png)

* One group per portal

![](image/config-group.png)

* One user admin per portal + other existing users

![](image/config-user.png)

* All records from a node are now created in a group and published in that group





## XML content migration

Start the application

Sign in as admin.

From the API page http://localhost:8080/geonetwork/doc/api/index.html#/tools/callStep

Call the following db migration task:
* Thumbnails / URL API changes
  * Exectute with
   `org.fao.geonet.MetadataResourceDatabaseMigration`
    
* Migrate ISO19139.fra which is deprecated
  * Exectute with
   `org.fao.geonet.ISO19139FraXslDatabaseMigration`
  
![](image/migration-iso19139-fra.png)


* INSPIRE TG2 migration / TODO


* Rebuild index



## Protect main catalogue


Add an apache rule to avoid connexion outside of BRGM network to:

```
http://localhost:8080/geonetwork/srv/eng/*
http://localhost:8080/geonetwork/srv/fre/*
```

## Contribution to GeoNetwork

* Admin / Logo / Improve styling https://github.com/geonetwork/core-geonetwork/pull/4073
* Portal list / Force content type to text/html https://github.com/geonetwork/core-geonetwork/pull/4069
* Portal / Add message when a portal is empty https://github.com/geonetwork/core-geonetwork/pull/4067
* Portal list https://github.com/geonetwork/core-geonetwork/pull/4042
* Portal / Set name depending on language in header and CSW capabilities https://github.com/geonetwork/core-geonetwork/pull/4029
* Doc / INSPIRE TG2 https://github.com/geonetwork/doc/pull/68
* Logo filter and order by name https://github.com/geonetwork/core-geonetwork/pull/4117
* Harvester / Add option to append privileges in case of override https://github.com/geonetwork/core-geonetwork/pull/4070
* Warn user if harvester or userid is already taken https://github.com/geonetwork/core-geonetwork/pull/4038
* Portal / Add link to group https://github.com/geonetwork/core-geonetwork/pull/4098
* New metadata / Force to set groupOwner when user is not an administrator https://github.com/geonetwork/core-geonetwork/pull/4118
* Admin / Link analysis / Hide for user admin https://github.com/geonetwork/core-geonetwork/pull/4119
* Admin / Alpha order for group list in group managment and multiselect. https://github.com/geonetwork/core-geonetwork/pull/4129
* CSS / Fix timeline missing dependency https://github.com/geonetwork/core-geonetwork/pull/4128
* i18n / Invalid key https://github.com/geonetwork/core-geonetwork/pull/4127
* Portal id / Exclude webapp root folders https://github.com/geonetwork/core-geonetwork/pull/4140
