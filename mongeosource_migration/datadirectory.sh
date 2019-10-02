#!/bin/bash

LIST=/tmp/mgs_uuid_map.csv
NODELIST=/tmp/mgs_siteids.csv
DATA_DIR=/data/dev/gn/mongeosource/web/src/main/webapp/WEB-INF/data/data/metadata_data
LOGO_DIR=/data/dev/gn/mongeosource/web/src/main/webapp/WEB-INF/data/data/resources/images/harvesting
OLD_DATA_DIR=/data/dev/gn/mongeosource/mongeosource_migration/ddold/metadata_data
OLD_LOGO_DIR=/data/dev/gn/mongeosource/mongeosource_migration/ddold/20190925/images/logos
#DATA_DIR=/applications/geosource/data
#OLD_DATA_DIR=/applications/geosource/olddata
#OLD_LOGO_DIR=/applications/geosource/olddata

#mkdir $OLD_DATA_DIR
#for server in vmpa27 vmpa28 vmpa40
#do
#  echo "Copy data dir from server $server"
#  scp -r user@$server:/applications/geosource/data/*/data/metadata_data/* $DATA_DIR/.
#done;

#
#IFS=","
#while read node oldid newid uuid
#do
#        echo "$node > $uuid ($oldid > $newid)"
#        # GeoNetwork compute parent folder from id
#        # 1 will be stored in 00000-00099
#        # 112 in 00100-00199
#        # https://github.com/geonetwork/core-geonetwork/blob/master/core/src/main/java/org/fao/geonet/lib/ResourceLib.java#L102-L106
#        ID=$(($oldid/100))
#        OLD_PARENT_FOLDER=$(printf %03d00-%03d99 $ID $ID)
#        ID=$(($newid/100))
#        PARENT_FOLDER=$(printf %03d00-%03d99 $ID $ID)
#        echo "Moving data from $OLD_PARENT_FOLDER to $PARENT_FOLDER"
#        mkdir -p $DATA_DIR/$PARENT_FOLDER
#        cp -fr $OLD_DATA_DIR/data_$node/data/metadata_data/$OLD_PARENT_FOLDER/$oldid $DATA_DIR/$PARENT_FOLDER/$newid
#done < $LIST

IFS=","
while read uuid node
do
        echo "$node = $uuid"
        echo "Copy old logo to data folder"
        mkdir -p $DATA_DIR/$PARENT_FOLDER
        cp $OLD_LOGO_DIR/$uuid.gif $LOGO_DIR/$node.gif
done < $NODELIST


#
#for node in 1383 1382 1381 1380 1379 1378 1376 1375 1373 1370 1369 1367 1364 1360 1352 1351 1349 1347 1345 1342 1341 1340 1334 1333 1331 1330 1328 1325 1324 1321 1319 1317 1304 1302 1289 1287 1286 1276 1274 1271 1267 1266 1265 1263 1260 1255 1251 1242 1239 1237 1231 1230 1225 1219 1213 1202 1192 1191 1184 1183 1178 1168 1146 1145 1139 1129 1119 1110 1101 1092 1088 1080 1068 1066 1062 1051 1050 1049 1048 1047 1046 1045 1044 1043 1042 1040 1023 1017 1014 1009 1006 1002 1001
#do
#  # Data directory migration
#  NODE_DIR=$OLD_DATA_DIR/$node
#  echo "Migrating data dir for $node [$NODE_DIR]"
#
#done;
