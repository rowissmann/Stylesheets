<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.tei-c.org/ns/1.0" 
		xmlns:tei="http://www.tei-c.org/ns/1.0" 
		xmlns:m="http://www.w3.org/1998/Math/MathML"
		exclude-result-prefixes="tei xs m" version="2.0" 
		xmlns:html="http://www.w3.org/1999/xhtml"
		xpath-default-namespace="http://www.w3.org/1999/xhtml">
  <xsl:import href="../common/common_makeTEIStructure.xsl"/>
  <xsl:import href="../common/functions.xsl"/>
  <xsl:output method="xml" indent="no"/>
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="html">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:variable name="converted">
	  <xsl:apply-templates mode="addnamespace"/>
	</xsl:variable>
	<xsl:apply-templates select="$converted"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="html">
    <TEI>
      <xsl:apply-templates/>
    </TEI>
  </xsl:template>
  <xsl:template match="body">
    <xsl:call-template name="convertStructure"/>
  </xsl:template>
  <xsl:template match="head">
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <title>
            <xsl:value-of select="title"/>
          </title>
          <author>
            <xsl:value-of select="meta[@name='dc.Creator']/@content"/>
          </author>
        </titleStmt>
        <publicationStmt>
          <p/>
        </publicationStmt>
        <sourceDesc>
          <p>translated from HTML to TEI</p>
        </sourceDesc>
      </fileDesc>
    </teiHeader>
  </xsl:template>
  <xsl:template match="h1|h2|h3|h4|h5|h6|h7">
    <HEAD level="{substring(local-name(),2,1)}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </HEAD>
  </xsl:template>
  <xsl:template match="tei:p[not(node())]" mode="pass1"/>
  <xsl:template match="br">
    <lb/>
  </xsl:template>
  <xsl:template match="a">
    <xsl:choose>
      <xsl:when test="@href">
        <ref target="{@href}">
          <xsl:apply-templates/>
        </ref>
      </xsl:when>
      <xsl:when test="@name">
        <anchor>
          <xsl:attribute name="xml:id" select="@name"/>
        </anchor>
        <xsl:apply-templates/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="li">
    <item>
      <xsl:apply-templates/>
    </item>
  </xsl:template>
  <xsl:template match="div">
    <xsl:choose>
      <xsl:when test="text() and not(*)">
	<p>
	  <xsl:apply-templates/>
	</p>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="div[contains(@class,' autogenerated')]"/>
  <xsl:template match="link">
</xsl:template>
  <xsl:template match="meta">
</xsl:template>
  <xsl:template match="p">
    <p>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </p>
  </xsl:template>
  <xsl:template match="p[@class='note']">
    <note>
      <xsl:apply-templates select="*|@*|text()|comment()"/>
    </note>
  </xsl:template>
  <xsl:template match="title">
</xsl:template>
  <xsl:template match="ul">
    <list type="unordered">
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  <xsl:template match="ol">
    <list type="ordered">
      <xsl:apply-templates/>
    </list>
  </xsl:template>
  <xsl:template match="em">
    <hi rend="italic">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="img|video[@src]|audio[@src]|embed|source">
    <xsl:variable name="object">
      <xsl:element name="{if (self::img) then 'graphic' else 'media'}">
        <xsl:attribute name="url" select="@src"/>
        <xsl:attribute name="rend" select="(local-name(),@class)"/>
        <xsl:attribute name="mimeType" select="tei:generateMimeType(@src,@type)"/>
        <xsl:for-each select="@width">
          <xsl:attribute name="width">
            <xsl:value-of select="."/>
            <xsl:analyze-string select="." regex="^[0-9]+$">
              <xsl:matching-substring>
                <xsl:text>px</xsl:text>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:attribute>
        </xsl:for-each>
        <xsl:for-each select="@height">
          <xsl:attribute name="height">
            <xsl:value-of select="."/>
            <xsl:analyze-string select="." regex="^[0-9]+$">
              <xsl:matching-substring>
                <xsl:text>px</xsl:text>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:attribute>
        </xsl:for-each>
      </xsl:element>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="parent::body or parent::div or parent::article
		      or parent::audio or parent::video">
        <p>
          <xsl:copy-of select="$object"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$object"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="pre">
    <eg>
      <xsl:apply-templates/>
    </eg>
  </xsl:template>
  <xsl:template match="strong">
    <hi rend="bold">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="sup">
    <hi rend="sup">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template
      match="@align|table/@border|table/@cellpadding|table/@cellspacing|table/@width">
    <xsl:attribute name="html:{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@class">
    <xsl:attribute name="rend" select="."/>
  </xsl:template>
  <xsl:template match="@style">
    <xsl:choose>
      <xsl:when test="matches(.,'^font-weight:\s?bold;?$')">
        <xsl:attribute name="rend">bold</xsl:attribute>
      </xsl:when>
      <xsl:when test="matches(.,'^font-style:\s?italic;?$')">
        <xsl:attribute name="rend">italic</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="style" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@id">
    <xsl:attribute name="xml:id" select="."/>
  </xsl:template>
  <xsl:template match="@title"/>
  <xsl:template match="@*|comment()|text()">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template match="span">
    <hi>
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>
  <xsl:template match="b">
    <hi rend="bold">
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>
  <xsl:template match="i">
    <hi rend="italic">
      <xsl:apply-templates select="@*|*|text()"/>
    </hi>
  </xsl:template>
  <xsl:template match="font">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="blockquote">
    <quote>
      <xsl:apply-templates select="@*|*|text()"/>
    </quote>
  </xsl:template>
  <xsl:template match="tt">
    <code>
      <xsl:apply-templates select="@*|*|text()"/>
    </code>
  </xsl:template>
  <xsl:template match="code">
    <eg>
      <xsl:apply-templates select="@*|*|text()"/>
    </eg>
  </xsl:template>
  <xsl:template match="table">
    <table>
      <xsl:apply-templates select="@*|*|text()"/>
    </table>
  </xsl:template>
  <xsl:template match="td|th">
    <cell>
      <xsl:apply-templates select="@*|*|text()"/>
    </cell>
  </xsl:template>
  <xsl:template match="tr">
    <row>
      <xsl:if test="parent::thead">
        <xsl:attribute name="role">label</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|*|text()"/>
    </row>
  </xsl:template>
  <xsl:template match="abbr">
    <abbr>
      <xsl:apply-templates/>
    </abbr>
  </xsl:template>
  <xsl:template match="address">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="article">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="aside">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="audio[source]|video[source]">
    <xsl:apply-templates select="source[1]"/>
  </xsl:template>
  <xsl:template match="cite">
    <ref>
      <xsl:apply-templates/>
    </ref>
  </xsl:template>
  <xsl:template match="del">
    <del>
      <xsl:apply-templates/>
    </del>
  </xsl:template>
  <xsl:template match="figcaption">
    <head>
      <xsl:apply-templates/>
    </head>
  </xsl:template>
  <xsl:template match="figure">
    <figure>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>
  <xsl:template match="footer">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ins">
    <add>
      <xsl:apply-templates/>
    </add>
  </xsl:template>
  <xsl:template match="kbd">
    <code rend="kbd">
      <xsl:apply-templates/>
    </code>
  </xsl:template>
  <xsl:template match="samp">
    <code rend="samp">
      <xsl:apply-templates/>
    </code>
  </xsl:template>
  <xsl:template match="section">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="small">
    <hi rend="small">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="sub">
    <hi rend="sub">
      <xsl:apply-templates/>
    </hi>
  </xsl:template>
  <xsl:template match="summary">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="var">
    <code rend="var">
      <xsl:apply-templates/>
    </code>
  </xsl:template>
  <xsl:template match="tbody">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tfoot">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="thead">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="hr"/>

  <xsl:template match="m:*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="img[starts-with(@src,'data:')]">
    <xsl:message>UNHANDLED data: in <xsl:value-of select="name()"/></xsl:message>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>UNTRANSLATED TAG <xsl:value-of select="name()"/></xsl:message>
    <xsl:comment>&lt;<xsl:value-of select="name()"/>
    <xsl:for-each select="@*">
      <xsl:text>&#10;  </xsl:text>
      <xsl:value-of select="name()"/>="<xsl:value-of select="."/><xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:text>&gt;</xsl:text>
    </xsl:comment>
    <xsl:apply-templates/>
    <xsl:comment>&lt;/<xsl:value-of select="name()"/>&gt;</xsl:comment>
  </xsl:template>

  <xsl:template match="comment()|@*|processing-instruction()|text()" mode="addnamespace">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="m:*" mode="addnamespace">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="*" mode="addnamespace">
    <xsl:element name="{name()}" xmlns="http://www.w3.org/1999/xhtml" >
      <xsl:apply-templates
	  select="@*|*|processing-instruction()|comment()|text()"
	  mode="addnamespace">
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
