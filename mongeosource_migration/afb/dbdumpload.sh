source dbprops.sh

for f in dump/$DUMP_PREFIX.backup; do
  echo "Loading dump $f"
  DB_OLD_NAME=$(basename $f .backup)
  DB_NAME=$DB_PREFIX$DB_OLD_NAME
  echo "  Creating db $DB_NAME"
  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_OLD_NAME;" postgres
  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "DROP DATABASE IF EXISTS $DB_NAME;" postgres
  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "CREATE DATABASE $DB_NAME WITH ENCODING 'UTF8' OWNER '$DB_USER';" postgres
  #PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $f
#  gunzip < $f | PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres
  PGPASSWORD=$DB_PASSWORD pg_restore -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -v $f
  #PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c "ALTER DATABASE $DB_OLD_NAME RENAME TO $DB_NAME;" postgres
  echo "  Dump restored."
done

