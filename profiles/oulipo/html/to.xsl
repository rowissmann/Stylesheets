<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html"
    version="2.0">
    <!-- import base conversion style -->

    <xsl:import href="../../../html/html.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p> This library is free software; you can redistribute it and/or
      modify it under the terms of the GNU Lesser General Public License as
      published by the Free Software Foundation; either version 2.1 of the
      License, or (at your option) any later version. This library is
      distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
      without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
      PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
      details. You should have received a copy of the GNU Lesser General Public
      License along with this library; if not, write to the Free Software
      Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id: to.xsl 12482 2013-07-28 18:39:41Z louburnard $</p>
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

   <xsl:output method="xhtml" omit-xml-declaration="yes"/>

<!-- set stylesheet parameters -->
<xsl:param name="numberHeadings">false</xsl:param>
<xsl:param name="numberFigures">false</xsl:param>
<xsl:param name="numberTables">false</xsl:param>
<xsl:param name="numberParagraphs">false</xsl:param>
<xsl:param name="lang">fr</xsl:param>

<xsl:param name="cssInlineFile">../profiles/oulipo/html/oulipo.css</xsl:param>
<xsl:param name="cssFile"/>
<xsl:param name="institution">OuLiPo</xsl:param>
<xsl:param name="bottomNavigationPanel">false</xsl:param>
<xsl:param name="linkPanel">false</xsl:param>
<xsl:param name="footnoteBackLink">true</xsl:param>
<xsl:param name="homeURL"></xsl:param>
<xsl:param name="feedbackURL"></xsl:param>
<xsl:param name="homeWords">OuLiPo</xsl:param>
<xsl:param name="pagebreakStyle">display</xsl:param>


<xsl:template name="copyrightStatement">
This page is made available under the Creative Commons General Public License "Attribution, Non-Commercial, Share-Alike", version 3.0 (CCPL BY-NC-SA) 
</xsl:template>

<xsl:template match="tei:front">
  <table>
    <tr class="label"><td>Nom</td><td>Occurrences</td></tr>
    <xsl:for-each-group select="//tei:persName" group-by=".">
      <xsl:sort select="."/>
      <tr>
	<td><xsl:value-of select="."/></td>
	<td><xsl:value-of select="count(current-group())"/></td>
      </tr>
    </xsl:for-each-group>
  </table>
  <div class="front">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="tei:back">
  <div class="back">
    <xsl:apply-templates/>
  </div>
</xsl:template>

</xsl:stylesheet>