#!/bin/bash

# Node list for logos and record list with new id / uuid mapping
NODELIST=/tmp/mgs_siteids.csv
LIST=/tmp/mgs_uuid_map.csv

OLD_DATA_DIR=/data/dev/gn/mongeosource/mongeosource_migration/ddold/metadata_data
DATA_DIR=/data/dev/gn/mongeosource/web/src/main/webapp/WEB-INF/data/data/metadata_data
OLD_LOGO_DIR=/data/dev/gn/mongeosource/mongeosource_migration/ddold/20190925/images/logos
LOGO_DIR=/data/dev/gn/mongeosource/web/src/main/webapp/WEB-INF/data/data/resources/images/harvesting
#OLD_DATA_DIR=/applications/geosource/olddata
#DATA_DIR=/applications/geosource/data
#OLD_LOGO_DIR=/applications/geosource/olddata/resources/images/harvesting
#LOGO_DIR=/application/geosource/data/resources/images/harvesting


# Copy old data dir to new server
mkdir $OLD_DATA_DIR
for server in vmpa27 vmpa28 vmpa40
do
  echo "Copy data dir from server $server"
  scp -r user@$server:/applications/geosource/data/*/data/metadata_data/* $OLD_DATA_DIR/.
  scp -r user@$server:/applications/geosource/data/resources $OLD_DATA_DIR/resources
done;


# Copy old logo to new installation
IFS=","
while read uuid node
do
        echo "$node = $uuid"
        echo "Copy old logo to data folder"
        cp $OLD_LOGO_DIR/$uuid.gif $LOGO_DIR/$node.gif
done < $NODELIST


# Copy old records attachement to new one
IFS=","
while read node oldid newid uuid
do
        echo "$node > $uuid ($oldid > $newid)"
        # GeoNetwork compute parent folder from id
        # 1 will be stored in 00000-00099
        # 112 in 00100-00199
        # https://github.com/geonetwork/core-geonetwork/blob/master/core/src/main/java/org/fao/geonet/lib/ResourceLib.java#L102-L106
        ID=$(($oldid/100))
        OLD_PARENT_FOLDER=$(printf %03d00-%03d99 $ID $ID)
        ID=$(($newid/100))
        PARENT_FOLDER=$(printf %03d00-%03d99 $ID $ID)
        echo "Moving data from $OLD_PARENT_FOLDER to $PARENT_FOLDER"
        mkdir -p $DATA_DIR/$PARENT_FOLDER
        cp -fr $OLD_DATA_DIR/data_$node/data/metadata_data/$OLD_PARENT_FOLDER/$oldid $DATA_DIR/$PARENT_FOLDER/$newid
done < $LIST
