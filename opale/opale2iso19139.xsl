<?xml version="1.0" encoding="UTF-8"?>
<!--
  Convert Opale metadata record to an ISO19139 one.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2012-08-27T11:13:39"
                version="2.0"
                exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml"/>

  <xsl:variable name="data"
                select="/my:Root/my:Data/my:BRGM-DATA"/>

  <!-- CHECKME:
  * INSPIRE conformity ?
  * BRGM template ?
  -->
  <xsl:template match="/">
    <gmd:MD_Metadata xmlns:gml="http://www.opengis.net/gml"
                     xmlns:gmd="http://www.isotc211.org/2005/gmd"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xmlns:gco="http://www.isotc211.org/2005/gco">


      <!-- Nom du fichier si unique ? Opale id ? sinon random UUID ? -->
      <gmd:fileIdentifier>
        <gco:CharacterString>
          <xsl:value-of select="replace(my:Root/my:Proprietes/my:NomFichier, '.xml', '')"/>
        </gco:CharacterString>
      </gmd:fileIdentifier>


      <!-- Francais par défaut. -->
      <gmd:language>
        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre"/>
      </gmd:language>


      <!-- UTF-8 par défaut -->
      <gmd:characterSet>
        <gmd:MD_CharacterSetCode codeListValue="utf8"
                                 codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"/>
      </gmd:characterSet>


      <gmd:hierarchyLevel>
        <gmd:MD_ScopeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode"
                          codeListValue="dataset"/>
      </gmd:hierarchyLevel>


      <!--
      Informations non récupérées:
            <my:Matricule/>
            <my:DateDemande/>

      On a aussi des infos dans my:IdentiteDonnee/my:fiche_createur. C'est toujours la même chose ?
      -->
      <xsl:for-each select="my:Root/my:Data/my:Demandeur">
        <gmd:contact>
          <gmd:CI_ResponsibleParty>
            <gmd:individualName>
              <gco:CharacterString>
                <xsl:value-of select="my:NomPrenom"/>
              </gco:CharacterString>
            </gmd:individualName>
            <gmd:organisationName>
              <gco:CharacterString>
                <!-- Préfixer par 'BRGM/DISN/ASU' ?
                Toujours le BRGM ? -->
                <xsl:value-of select="concat('BRGM/', my:Affectation)"/>
              </gco:CharacterString>
            </gmd:organisationName>
            <!--<gmd:positionName gco:nilReason="missing">
              <gco:CharacterString/>
            </gmd:positionName>-->
            <gmd:contactInfo>
              <gmd:CI_Contact>
                <!-- Pas de téléphone ?
                <gmd:phone>
                  <gmd:CI_Telephone>
                    <gmd:voice gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:voice>
                    <gmd:facsimile gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:facsimile>
                  </gmd:CI_Telephone>
                </gmd:phone>-->
                <gmd:address>
                  <gmd:CI_Address>
                    <!-- Pas d'adresse ?
                    <gmd:deliveryPoint gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:deliveryPoint>
                    <gmd:city gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:city>
                    <gmd:administrativeArea gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:administrativeArea>
                    <gmd:postalCode gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:postalCode>
                    <gmd:country gco:nilReason="missing">
                      <gco:CharacterString/>
                    </gmd:country>-->
                    <gmd:electronicMailAddress>
                      <gco:CharacterString>
                        <xsl:value-of select="my:Courriel"/>
                      </gco:CharacterString>
                    </gmd:electronicMailAddress>
                  </gmd:CI_Address>
                </gmd:address>
              </gmd:CI_Contact>
            </gmd:contactInfo>
            <gmd:role>
              <gmd:CI_RoleCode codeListValue="pointOfContact"
                               codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"/>
            </gmd:role>
          </gmd:CI_ResponsibleParty>
        </gmd:contact>
      </xsl:for-each>


      <!-- Le catalogue va mettre un dateTime et non une date seule.
      On ajoute 9h du matin ?-->
      <gmd:dateStamp>
        <gco:DateTime>
          <xsl:value-of select="concat($data/my:IdentiteDonnee/my:fiche_dateCreationFiche, 'T09:00:00')"/>
        </gco:DateTime>
      </gmd:dateStamp>



      <gmd:metadataStandardName>
        <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
      </gmd:metadataStandardName>
      <gmd:metadataStandardVersion>
        <gco:CharacterString>1.0</gco:CharacterString>
      </gmd:metadataStandardVersion>


      <!-- CRS ou pas ?-->
      <gmd:referenceSystemInfo>
        <gmd:MD_ReferenceSystem>
          <gmd:referenceSystemIdentifier>
            <gmd:RS_Identifier>
              <gmd:code>
                <gmx:Anchor xlink:href="http://www.opengis.net/def/crs/EPSG/0/4326">EPSG:4326</gmx:Anchor>
              </gmd:code>
            </gmd:RS_Identifier>
          </gmd:referenceSystemIdentifier>
        </gmd:MD_ReferenceSystem>
      </gmd:referenceSystemInfo>


      <gmd:identificationInfo>
        <gmd:MD_DataIdentification>
          <gmd:citation>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>
                  <xsl:value-of select="$data/my:TitreDonnee"/>
                </gco:CharacterString>
              </gmd:title>


              <gmd:date>
                <gmd:CI_Date>
                  <gmd:date>
                    <gco:Date>
                      <xsl:value-of select="$data/my:IdentiteDonnee/my:fiche_dateCreationDonnee"/>
                    </gco:Date>
                  </gmd:date>
                  <gmd:dateType>
                    <gmd:CI_DateTypeCode codeListValue="creation"
                                         codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"/>
                  </gmd:dateType>
                </gmd:CI_Date>
              </gmd:date>


              <!-- Si accès à la donnée est différé, alors on ajoute une date de publication ?-->
              <xsl:if test="$data/my:AccesDonnee/my:difere = 'true'">
                <gmd:date>
                  <gmd:CI_Date>
                    <gmd:date>
                      <gco:Date>
                        <xsl:value-of select="$data/my:AccesDonnee/my:difere/my:infos/my:date"/>
                      </gco:Date>
                    </gmd:date>
                    <gmd:dateType>
                      <gmd:CI_DateTypeCode codeListValue="publication"
                                           codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"/>
                    </gmd:dateType>
                  </gmd:CI_Date>
                </gmd:date>
              </xsl:if>

              <!-- Dans le modèle
              <gmd:edition gco:nilReason="missing">
                  <gco:CharacterString/>
               </gmd:edition>
               <gmd:identifier>
                  <gmd:MD_Identifier>
                     <gmd:code>
                        <gco:CharacterString>https://data.geoscience.fr/id/dataset/borehole</gco:CharacterString>
                     </gmd:code>
                  </gmd:MD_Identifier>
               </gmd:identifier>
               <gmd:presentationForm>
                  <gmd:CI_PresentationFormCode codeListValue="mapDigital"
                                               codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_PresentationFormCode"/>
               </gmd:presentationForm>
               -->

            </gmd:CI_Citation>
          </gmd:citation>
          <gmd:abstract>
            <gco:CharacterString>
              <xsl:value-of select="$data/my:LblRapport"/>
            </gco:CharacterString>
          </gmd:abstract>

          <xsl:for-each select="$data/my:LienDonnee/my:Publication/my:attributionPublication/my:publication[. != '']">
            <gmd:credit>
              <gco:CharacterString>
                <xsl:value-of select="."/>
              </gco:CharacterString>
            </gmd:credit>
          </xsl:for-each>


          <gmd:status>
            <gmd:MD_ProgressCode codeListValue="onGoing"
                                 codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ProgressCode"/>
          </gmd:status>


          <xsl:for-each select="$data/my:IdentiteDonnee/my:Producteur">
            <gmd:pointOfContact>
              <gmd:CI_ResponsibleParty>
                <gmd:organisationName>
                  <gco:CharacterString>
                    <xsl:value-of select="my:producteur_nom"/>
                  </gco:CharacterString>
                </gmd:organisationName>
                <gmd:contactInfo>
                  <gmd:CI_Contact>
                    <gmd:address>
                      <gmd:CI_Address>
                        <gmd:electronicMailAddress>
                          <gco:CharacterString>
                            <xsl:value-of select="my:producteur_mail"/>
                          </gco:CharacterString>
                        </gmd:electronicMailAddress>
                      </gmd:CI_Address>
                    </gmd:address>
                  </gmd:CI_Contact>
                </gmd:contactInfo>
                <gmd:role>
                  <gmd:CI_RoleCode codeListValue="custodian"
                                   codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"/>
                </gmd:role>
              </gmd:CI_ResponsibleParty>
            </gmd:pointOfContact>
          </xsl:for-each>


          <xsl:for-each select="$data/my:Contacts">
            <gmd:pointOfContact>
              <gmd:CI_ResponsibleParty>
                <gmd:organisationName>
                  <gco:CharacterString>
                    <xsl:value-of select="my:contact_identite"/><!-- Organisme ou individu ?-->
                  </gco:CharacterString>
                </gmd:organisationName>
                <gmd:contactInfo>
                  <gmd:CI_Contact>
                    <gmd:address>
                      <gmd:CI_Address>
                        <gmd:electronicMailAddress>
                          <gco:CharacterString>
                            <xsl:value-of select="my:contact_mail"/>
                          </gco:CharacterString>
                        </gmd:electronicMailAddress>
                      </gmd:CI_Address>
                    </gmd:address>
                  </gmd:CI_Contact>
                </gmd:contactInfo>
                <gmd:role>
                  <gmd:CI_RoleCode codeListValue="pointOfContact"
                                   codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"/>
                </gmd:role>
              </gmd:CI_ResponsibleParty>
            </gmd:pointOfContact>
          </xsl:for-each>


         <!-- <gmd:resourceMaintenance>
            <gmd:MD_MaintenanceInformation>
              <gmd:maintenanceAndUpdateFrequency>
                <gmd:MD_MaintenanceFrequencyCode codeListValue="asNeeded"
                                                 codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode"/>
              </gmd:maintenanceAndUpdateFrequency>
            </gmd:MD_MaintenanceInformation>
          </gmd:resourceMaintenance>
-->


          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <xsl:for-each select="$data/my:ListeMotCles">
                <gmd:keyword>
                  <gco:CharacterString>
                    <xsl:value-of select="my:LibelleMotCle"/>
                  </gco:CharacterString>
                </gmd:keyword>
              </xsl:for-each>
              <gmd:type>
                <gmd:MD_KeywordTypeCode codeListValue="theme"
                                        codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"/>
              </gmd:type>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>




          <!-- attributionProjet devient un mot clé.
          On attend que projet_code ne soit pas vide
          On concaténe libellé et code projet.
          -->
          <xsl:if test="count($data/my:LienDonnee/my:Projet/my:attributionProjet/my:projet_code[. != '']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="$data/my:LienDonnee/my:Projet/my:attributionProjet[my:projet_code != '']">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="concat(my:projet_libelle, ' (', my:projet_code, ')')"/>
                    </gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeListValue="theme"
                                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>Projet BRGM</gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2018-11-11</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode codeList="" codeListValue="creation"/>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>




          <!--
            motCleRapport_code devient un mot clé
            On attend un code non vide.
            On concaténe libellé et code des mots clés du rapport.
            On pourrait utiliser des Anchors pour les codes ? avec lien vers un registre ?

            <my:ListeMotsCles>
                <my:motCleRapport_code>4004</my:motCleRapport_code>
                <my:motCleRapport_libelle>AFFAISSEMENT</my:motCleRapport_libelle>
                -->
          <xsl:if test="count($data/my:ListeMotsCles/my:motCleRapport_code[. != '']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="$data/my:ListeMotsCles/my:motCleRapport_code[. != '']">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="concat(../my:motCleRapport_libelle, ' (', ., ')')"/>
                    </gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeListValue="theme"
                                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>Mots clés des rapports BRGM</gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2018-11-11</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode codeList="" codeListValue="creation"/>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>


          <!--
            attributionMotsCles devient un mot clé
            On attend un code non vide.
            On concaténe libellé et code des mots clés

            <my:ListeMotsCles>
                ...
                <my:attributionMotsCles>
                    <my:motCle_code>ALIMENTATION EAU</my:motCle_code>
                    <my:motCle_libelle>ALIMENTATION EAU</my:motCle_libelle>
                </my:attributionMotsCles>
                -->
          <xsl:if test="count($data/my:ListeMotsCles/my:attributionMotsCles[my:motCle_code != '']) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="$data/my:ListeMotsCles/my:attributionMotsCles[my:motCle_code != '']">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="concat(../my:motCle_libelle, ' (', my:motCle_code, ')')"/>
                    </gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeListValue="theme"
                                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>Mots clés BRGM</gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2018-11-11</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode codeList="" codeListValue="creation"/>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>

          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:keyword>
                <gco:CharacterString>Géologie</gco:CharacterString>
              </gmd:keyword>
              <gmd:type>
                <gmd:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                        codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2008-06-01</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                                             codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xlink:href="http://ressource.brgm.fr/catalogue/srv/fre/thesaurus.download?ref=external.theme.httpinspireeceuropaeutheme-theme">geonetwork.thesaurus.external.theme.httpinspireeceuropaeutheme-theme</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>




          <gmd:resourceConstraints>
            <gmd:MD_LegalConstraints>
              <xsl:if test="$data/my:Licence[. != '']">
                <!-- Manque justification, quelles étaient les raisons ? -->
                <gmd:useLimitation>
                  <!-- eg <gmx:Anchor xlink:href="http://www.data.gouv.fr/Licence-Ouverte-Open-Licence">Licence Ouverte Etalab</gmx:Anchor>-->
                  <gmx:Anchor xlink:href="http://www.data.gouv.fr/Licence-Ouverte-Open-Licence">Licence Ouverte Etalab</gmx:Anchor>
                </gmd:useLimitation>
              </xsl:if>


              <gmd:accessConstraints>
                <gmd:MD_RestrictionCode codeListValue="{
                if ($data/my:AccesDonnee/my:confidential = 'true'
                    or $data/my:AccesDonnee/my:reserve = 'true')
                then 'restricted'
                else 'otherRestrictions'}"
                                        codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode"/>
              </gmd:accessConstraints>


              <gmd:useConstraints>
                <gmd:MD_RestrictionCode codeListValue="otherRestictions"
                                        codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode"/>
              </gmd:useConstraints>


              <gmd:otherConstraints>
                <gco:CharacterString>
                  <xsl:if test="$data/my:AccesDonnee/my:difere = 'true'">
                    Accès à la donnée prévue <xsl:value-of select="$data/my:AccesDonnee/my:infos/my:date"/>.
                    <xsl:value-of select="$data/my:AccesDonnee/my:infos/my:commentaire"/>
                  </xsl:if>

                  <xsl:if test="$data/my:AccesDonnee/my:confidential = 'true'">
                    Données confidentielles.
                  </xsl:if>

                  <xsl:if test="$data/my:AccesDonnee/my:reserve = 'true'">
                    Données réservées ?
                  </xsl:if>

                  <xsl:if test="$data/my:AccesDonnee/my:immediat = 'true'">
                    Pas de contraintes ?
                  </xsl:if>
                </gco:CharacterString>
              </gmd:otherConstraints>
            </gmd:MD_LegalConstraints>
          </gmd:resourceConstraints>


          <gmd:spatialRepresentationType>
            <gmd:MD_SpatialRepresentationTypeCode codeListValue="vector"
                                                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_SpatialRepresentationTypeCode"/>
          </gmd:spatialRepresentationType>
          <gmd:spatialResolution>
            <gmd:MD_Resolution>
              <gmd:equivalentScale>
                <gmd:MD_RepresentativeFraction>
                  <gmd:denominator>
                    <gco:Integer/>
                  </gmd:denominator>
                </gmd:MD_RepresentativeFraction>
              </gmd:equivalentScale>
            </gmd:MD_Resolution>
          </gmd:spatialResolution>


          <gmd:language>
            <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre"/>
          </gmd:language>

          <gmd:characterSet>
            <gmd:MD_CharacterSetCode codeListValue="utf8"
                                     codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"/>
          </gmd:characterSet>


          <gmd:topicCategory>
            <gmd:MD_TopicCategoryCode>geoscientificInformation</gmd:MD_TopicCategoryCode>
          </gmd:topicCategory>


          <!-- Est-ce qu'il y a une date de fin ou de début, si oui, on ajoute une étendue.
          La description est considérée comme optionelle. ie. ajoutée si non vide.
          -->
          <xsl:for-each select="$data/my:EtendueTemporelle/my:Etendue[my:dateDebut != '' or my:dateFin != '']">
            <gmd:extent>
              <gmd:EX_Extent>
                <xsl:if test="my:description != ''">
                  <gmd:description>
                    <gco:CharacterString>
                      <xsl:value-of select="my:description"/>
                    </gco:CharacterString>
                  </gmd:description>
                </xsl:if>
                <gmd:temporalElement>
                  <gmd:EX_TemporalExtent>
                    <gmd:extent>
                      <gml:TimePeriod gml:id="d{generate-id()}">
                        <gml:beginPosition>
                          <xsl:value-of select="my:dateDebut"/>
                        </gml:beginPosition>
                        <gml:endPosition>
                          <xsl:value-of select="my:dateFin"/>
                        </gml:endPosition>
                      </gml:TimePeriod>
                    </gmd:extent>
                  </gmd:EX_TemporalExtent>
                </gmd:temporalElement>
              </gmd:EX_Extent>
            </gmd:extent>
          </xsl:for-each>


          <!-- TODO: my:Map c'est du JSON et quel type de géométries ?
          point, rectangle, polygone
          si pas d'emprise, une par defaut.
          -->
          <gmd:extent>
            <gmd:EX_Extent>
              <gmd:geographicElement>
                <gmd:EX_GeographicBoundingBox>
                  <gmd:westBoundLongitude>
                    <gco:Decimal>-180</gco:Decimal>
                  </gmd:westBoundLongitude>
                  <gmd:eastBoundLongitude>
                    <gco:Decimal>180</gco:Decimal>
                  </gmd:eastBoundLongitude>
                  <gmd:southBoundLatitude>
                    <gco:Decimal>-90</gco:Decimal>
                  </gmd:southBoundLatitude>
                  <gmd:northBoundLatitude>
                    <gco:Decimal>90</gco:Decimal>
                  </gmd:northBoundLatitude>
                </gmd:EX_GeographicBoundingBox>
              </gmd:geographicElement>
            </gmd:EX_Extent>
          </gmd:extent>

          <xsl:for-each select="$data/my:CapitalisationDonnee[my:estCapitalisable = 'Oui']">
            <gmd:supplementalInformation>
              <gco:CharacterString>
                La donnée peut venir enrichir l'une des banques de données hébergée par le BRGM.
                <xsl:value-of select="$data/my:CapitalisationDonnee/my:ajouterDonneeAuSI/my:donneeSI_commentaire"/>
              </gco:CharacterString>
            </gmd:supplementalInformation>
          </xsl:for-each>

        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>
      <gmd:distributionInfo>
        <gmd:MD_Distribution>
          <gmd:distributionFormat>
            <gmd:MD_Format>
              <gmd:name></gmd:name>
              <gmd:version></gmd:version>
            </gmd:MD_Format>
          </gmd:distributionFormat>

          <gmd:distributor>
            <gmd:MD_Distributor>
              <xsl:for-each select="$data/my:Fournisseur">
                <gmd:distributorContact>
                  <gmd:CI_ResponsibleParty>
                    <gmd:organisationName>
                      <gco:CharacterString>
                        <xsl:value-of select="my:fournisseur_nom"/><!-- Organisme ou individu ?-->
                      </gco:CharacterString>
                    </gmd:organisationName>
                    <gmd:contactInfo>
                      <gmd:CI_Contact>
                        <gmd:address>
                          <gmd:CI_Address>
                            <gmd:electronicMailAddress>
                              <gco:CharacterString>
                                <xsl:value-of select="my:fournisseur_mail"/>
                              </gco:CharacterString>
                            </gmd:electronicMailAddress>
                          </gmd:CI_Address>
                        </gmd:address>
                      </gmd:CI_Contact>
                    </gmd:contactInfo>
                    <gmd:role>
                      <gmd:CI_RoleCode codeListValue="resourceProvider"
                                       codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"/>
                    </gmd:role>
                  </gmd:CI_ResponsibleParty>
                </gmd:distributorContact>
              </xsl:for-each>
            </gmd:MD_Distributor>
          </gmd:distributor>


          <gmd:transferOptions>
            <gmd:MD_DigitalTransferOptions>
              <!-- Un DOI est ajouté comme un lien -->
              <xsl:for-each select="$data/my:LienDonnee/my:attributionDOI/my:DOI[. != '']">
                <gmd:onLine>
                  <gmd:CI_OnlineResource>
                    <gmd:linkage>
                      <gmd:URL>
                        <xsl:value-of select="."/>
                      </gmd:URL>
                    </gmd:linkage>
                    <gmd:protocol>
                      <gco:CharacterString>DOI</gco:CharacterString>
                    </gmd:protocol>
                    <gmd:name>
                      <gco:CharacterString>Digital Object Identifier (DOI)</gco:CharacterString>
                    </gmd:name>
                  </gmd:CI_OnlineResource>
                </gmd:onLine>
              </xsl:for-each>

              <xsl:for-each select="$data/my:LienDonnee/my:Rapports/my:attributionRapport[my:rapport_code != '']">
                <gmd:onLine>
                  <gmd:CI_OnlineResource>
                    <gmd:linkage>
                      <gmd:URL>
                        <!-- Un lien vers le rapport ? -->
                        <xsl:value-of select="concat('https://doc.brgm.fr/rapports/', my:rapport_code)"/>
                      </gmd:URL>
                    </gmd:linkage>
                    <gmd:protocol>
                      <gco:CharacterString>WWW:LINK</gco:CharacterString>
                    </gmd:protocol>
                    <gmd:name>
                      <gco:CharacterString>
                        <xsl:value-of select="my:rapport_libelle"/>
                      </gco:CharacterString>
                    </gmd:name>
                  </gmd:CI_OnlineResource>
                </gmd:onLine>
              </xsl:for-each>
            </gmd:MD_DigitalTransferOptions>
          </gmd:transferOptions>
        </gmd:MD_Distribution>
      </gmd:distributionInfo>
      <gmd:dataQualityInfo>
        <gmd:DQ_DataQuality>
          <gmd:scope>
            <gmd:DQ_Scope>
              <gmd:level>
                <gmd:MD_ScopeCode codeListValue="dataset"
                                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode"/>
              </gmd:level>
            </gmd:DQ_Scope>
          </gmd:scope>
          <gmd:lineage>
            <gmd:LI_Lineage>
              <gmd:statement gco:nilReason="missing">
                <gco:CharacterString/>
              </gmd:statement>
            </gmd:LI_Lineage>
          </gmd:lineage>
        </gmd:DQ_DataQuality>
      </gmd:dataQualityInfo>
    </gmd:MD_Metadata>


  </xsl:template>

</xsl:stylesheet>
