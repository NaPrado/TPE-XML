<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="page"
                                       page-width="21cm" page-height="29.7cm"
                                       margin-left="1.5cm" margin-right="1.5cm"
                                       margin-top="1cm" margin-bottom="2cm">
                    <fo:region-body/>
                    <fo:region-before extent="1cm"/>
                    <fo:region-after extent="1cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="page">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block font-size="10pt" text-align="center">
                        TPE 2024 1Q Grupo 08
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="14pt" text-align="left" margin-bottom="10pt">
                        <xsl:text>Drivers for </xsl:text>
                        <xsl:value-of select="/nascar_data/serie_type"/>
                        <xsl:text> for </xsl:text>
                        <xsl:value-of select="/nascar_data/year"/>
                        <xsl:text> season</xsl:text>
                    </fo:block>

                    <fo:table table-layout="fixed" width="100%" border="1pt solid black" font-size="8pt">
                        <fo:table-column column-width="14%"/>
                        <fo:table-column column-width="10%"/>
                        <fo:table-column column-width="10%"/>
                        <fo:table-column column-width="14%"/>
                        <fo:table-column column-width="9%"/>
                        <fo:table-column column-width="8%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="7%"/>
                        <fo:table-column column-width="8%"/>
                        <fo:table-column column-width="8%"/>

                        <fo:table-header>
                            <fo:table-row background-color="rgb(215,245,250)">
                                <fo:table-cell><fo:block>Name</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Country</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Birth date</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Birth place</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Car manufacturer</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Rank</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Season points</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Wins</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Poles</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Unfinished races</fo:block></fo:table-cell>
                                <fo:table-cell><fo:block>Completed laps</fo:block></fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>

                        <fo:table-body>
                            <xsl:for-each select="/nascar_data/drivers/driver[rank != '']">
                                <xsl:sort select="rank" data-type="number" order="ascending"/>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="full_name"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:value-of select="concat(translate(substring(country, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), translate(substring(country, 2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="birth_date"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="birth_place"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:choose>
                                                <xsl:when test="car">
                                                    <xsl:value-of select="car"/>
                                                </xsl:when>
                                                <xsl:otherwise>-</xsl:otherwise>
                                            </xsl:choose>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block color="{if (rank &lt;= 3) then 'green' else 'black'}"><xsl:value-of select="rank"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="statistics/season_points"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="statistics/wins"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="statistics/poles"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="statistics/races_not_finished"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block><xsl:value-of select="statistics/laps_completed"/></fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>
