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
                    <fo:block line-height="14pt" font-size="10pt" text-align="end" >
                        TPE 2024 1Q Grupo 06
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="14pt" text-align="left" margin-bottom="10pt">
                        <xsl:value-of select="/nascar_data/error"/>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>