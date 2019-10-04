/*
 * =============================================================================
 * ===	Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * ===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * ===	and United Nations Environment Programme (UNEP)
 * ===
 * ===	This program is free software; you can redistribute it and/or modify
 * ===	it under the terms of the GNU General Public License as published by
 * ===	the Free Software Foundation; either version 2 of the License, or (at
 * ===	your option) any later version.
 * ===
 * ===	This program is distributed in the hope that it will be useful, but
 * ===	WITHOUT ANY WARRANTY; without even the implied warranty of
 * ===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * ===	General Public License for more details.
 * ===
 * ===	You should have received a copy of the GNU General Public License
 * ===	along with this program; if not, write to the Free Software
 * ===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 * ===
 * ===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * ===	Rome - Italy. email: geonetwork@osgeo.org
 * ==============================================================================
 */

package org.fao.geonet;

import com.google.common.collect.Lists;
import org.apache.commons.lang.StringUtils;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.kernel.GeonetworkDataDirectory;
import org.fao.geonet.kernel.setting.SettingManager;
import org.fao.geonet.schema.iso19139.ISO19139Namespaces;
import org.fao.geonet.utils.Log;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.fao.geonet.MetadataResourceDatabaseMigration.updateMetadataResourcesLink;

/**
 * Run a query matching a specific set of records and
 * apply an XSL transformation to those records.
 */
public class ISO19139FraXslDatabaseMigration extends DatabaseMigrationTask {

    private String filter = "%http://www.cnig.gouv.fr/2005/fra%";
    private String xsl = "iso19139/convert/ISO19139-fra-TO-ISO19139.xsl";

    public String getFilter() {
        return filter;
    }

    public void setFilter(String filter) {
        this.filter = filter;
    }

    public String getXsl() {
        return xsl;
    }

    public void setXsl(String xsl) {
        this.xsl = xsl;
    }


    @Override
    public void update(Connection connection) throws SQLException {
        Log.debug(Geonet.DB, "XslDatabaseMigration");
        final GeonetworkDataDirectory dataDirectory = applicationContext.getBean(GeonetworkDataDirectory.class);

        Path xslFile = dataDirectory.getSchemaPluginsDir().resolve(xsl);

        try (PreparedStatement update = connection.prepareStatement(
            "UPDATE metadata SET data=? WHERE id=?")
        ) {
            try {
                PreparedStatement statement = connection.prepareStatement(
                    "SELECT data,id,uuid FROM metadata WHERE data LIKE ?");
                statement.setString(1, filter);
                ResultSet resultSet = statement.executeQuery();

                int numInBatch = 0;
                final SettingManager settingManager = applicationContext.getBean(SettingManager.class);

                while (resultSet.next()) {
                    final Element xml = Xml.loadString(resultSet.getString(1), false);
                    final int id = resultSet.getInt(2);
                    final String uuid = resultSet.getString(3);
                    Element updatedXml = Xml.transform(xml, xslFile);

                    String updatedData = Xml.getString(xml);
                    update.setString(1,  Xml.getString(updatedXml));
                    update.setInt(2, id);
                    update.addBatch();
                    numInBatch++;
                    if (numInBatch > 200) {
                        update.executeBatch();
                        numInBatch = 0;
                    }
                }
                update.executeBatch();
            } catch (java.sql.BatchUpdateException e) {
                Log.error(Geonet.GEONETWORK,
                    "Error occurred while running XSL migration task. Error is: " + e.getMessage(), e);
                SQLException next = e.getNextException();
                while (next != null) {
                    Log.error(Geonet.GEONETWORK, "Next error: " + next.getMessage(), next);
                    next = e.getNextException();
                }

                throw new RuntimeException(e);
            } catch (Exception e) {
                throw new Error(e);
            } finally {
                connection.close();
            }
        }
    }
}
