# Opale

## Conversion format Opale vers ISO19139

cf. [schemas/iso19139/src/main/plugin/iso19139/convert/opale2iso19139.xsl](schemas/iso19139/src/main/plugin/iso19139/convert/opale2iso19139.xsl)

## Transfert d'une fiche dans le catalogue

Exemple de script CURL pour l'ajout d'une fiche et le déclenchement du workflow dans le catalogue :

```
export CATALOG=http://localhost:8080/geonetwork
export CATALOGUSER=admin
export CATALOGPASS=admin
export UUID=DISN_ASU_Hidalgo_Lea_Depot_donnee_2018-10-24T08-48-32_481Z
declare -a THEMATIQUE_GROUP=("3" "4" "5")


# S’authentifier vers le catalogue avec (un compte générique Opale)
rm -f /tmp/cookie; 
curl -s -c /tmp/cookie -o /dev/null -X POST "$CATALOG/srv/eng/info?type=me"; 
export TOKEN=`grep XSRF-TOKEN /tmp/cookie | cut -f 7`; 
curl -X POST -H "X-XSRF-TOKEN: $TOKEN" --user $CATALOGUSER:$CATALOGPASS -b /tmp/cookie \
  "$CATALOG/srv/eng/info?type=me" 

# MUST return @authenticated = true




# Insérer le document XML généré pour l’importer dans le catalogue (a priori via l’API d’import ou via CSW-T)
# L'import s'occupe de convertir le format opale vers ISO19139
# La fiche est dans le gourpe Données projets
curl -X POST "$CATALOG/srv/api/records" \
    -F file=@sample.xml -F metadataType=METADATA -F uuidProcessing=OVERWRITE -F transformWith=opale -F group=2 \
    -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' \
    -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS 


curl -X POST "$CATALOG/srv/api/records/" \
    -F file=@sample.xml -F metadataType=METADATA -F uuidProcessing=OVERWRITE -F transformWith=opale -F group=2 \
    -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' \
    -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS 


# Associer la fiche à un groupe en fonction de la thématique 
for t in "${THEMATIQUE_GROUP[@]}"
do
  PRIVILEGE="{\"clear\":false,\"privileges\":[{\"group\":$t,\"operations\":{\"view\":true,\"editing\":true}}]}"
  echo "$PRIVILEGE"
  curl -X PUT "$CATALOG/srv/api/records/$UUID/sharing" \
      --data "$PRIVILEGE" \
      -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' -H 'Content-type: application/json' \
      -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS  
done


# Déclencher le workflow pour la validation. La notification est envoyé à tous les utilisateurs reviewers 
# des groupes dans lesquels la fiche est publiée.
curl -X PUT "$CATALOG/srv/api/records/$UUID/status?status=4&comment=Nouvelle+fiche+insérée+par+Opale+à+valider" \
    -H 'Accept-Language: fr-FR,fr' -H 'Accept: application/json' \
    -H "X-XSRF-TOKEN: $TOKEN" -c /tmp/cookie -b /tmp/cookie --user $CATALOGUSER:$CATALOGPASS 
    

```
