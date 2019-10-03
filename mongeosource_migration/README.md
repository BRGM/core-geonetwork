
## Requirements

* Tomcat 8
* Java 8
* PostgreSQL
 * One database for the new mongeosource
 * One read only user allowed to connect to all old nodes to migrate. A db link is used to migrate data from the old databases to the new one.  
 
 

## DB migration

* Connect to the database
```shell script
cd mongeosource_migration
psql -h localhost -p 5432 -U www-data -W -d mongn380
```

* Create initial database and run SQL migration

```sql
\i setup.sql
\i nodelist.sql
\i migration.sql


-- We have 3 db server to migrate from.
SELECT mgs_migrate('localhost', 5432,
   'www-data', 'www-data', 'mongn_db_');


```

## Data directory migration

* Copy data directory from old VM to the new one using scp
* Then combine all old data directories in one remapping based on new record ids.

```shell script
cd mongeosource_migration
./datadirectory.sh
```


## Catalogue configuration



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
   `org.fao.geonet.XslDatabaseMigration`
  
![](image/migration-iso19139-fra.png)


* INSPIRE TG2 migration


* Rebuild index


## Contribution to GeoNetwork

* https://github.com/geonetwork/core-geonetwork/pull/4073
