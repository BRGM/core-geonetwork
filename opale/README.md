# Opale

## Conversion format Opale vers ISO19139

cf. [schemas/iso19139/src/main/plugin/iso19139/convert/opale2iso19139.xsl](schemas/iso19139/src/main/plugin/iso19139/convert/opale2iso19139.xsl)

## Transfert d'une fiche dans le catalogue

Exemple de script CURL pour l'ajout d'une fiche et le déclenchement du workflow dans le catalogue :

```
export CATALOG=http://localhost:8080/geonetwork
export CATALOGUSER=admin
export CATALOGPASS=admin


# S’authentifier vers le catalogue avec (un compte générique Opale)
rm -f /tmp/cookie; 
curl -s -c /tmp/cookie -o /dev/null -X POST "$CATALOG/srv/eng/info?type=me"; 
export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`; 
curl -X POST -H "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie \
  "$CATALOG/srv/eng/info?type=me" 

# MUST return @authenticated = true




# Insérer le document XML généré pour l’importer dans le catalogue (a priori via l’API d’import ou via CSW-T)
# L'import s'occupe de convertir le format opale vers ISO19139
# group ? 
curl -X POST "$CATALOG/srv/api/records" \
    -F file=@test.xml -F metadataType=METADATA -F uuidProcessing=NOTHING -F transformWith=opale \
    -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' \
    -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS 


# Associer la fiche à un groupe en fonction de la thématique - a priori group à l'import. 


# Déclencher le workflow pour la validation
## Option 1: automatique via l'admin
## Option 2: à la main via l'API

curl -X PUT "$CATALOG/srv/api/records/DISN_ASU_Hidalgo_Lea_Depot_donnee_2018-10-24T08-48-32_481Z/status?status=4&comment=Ceci+est+à+approuver" \
    -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' \
    -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS 
    

```
