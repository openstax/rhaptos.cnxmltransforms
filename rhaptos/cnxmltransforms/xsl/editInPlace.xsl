<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cnx="http://cnx.rice.edu/cnxml"
  xmlns="http://www.w3.org/1999/xhtml">

  <!-- You should install the CNXML package and catalog so this can use a local copy-->
  <xsl:import href="cnxml2html.xsl" />

  <xsl:variable name="baseurl" select="/module/display/base/@href" />
  <xsl:variable name="authoremailstring">
    <xsl:for-each select="/module/metadata/author">
      <xsl:value-of select="email" />
      <xsl:if test="position()!=last()">,</xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="objectId" select="/module/publishing/objectId/text()" />
  <xsl:variable name="version" select="/module/publishing/version/text()" />
  <xsl:variable name="modlang" select="/module/metadata/language" />

  <xsl:param name="stylesheet_path" select="'/stylesheets/plone'" />

  <xsl:output omit-xml-declaration="yes" encoding="utf-8" />

  <xsl:template match="/">
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="module">
    
    <html xmlns="http://www.w3.org/1999/xhtml">

      <head>
        <base href="{$baseurl}" />
        <title><xsl:value-of select="title" /></title>

	<link rel="stylesheet" type="text/css" href="{$stylesheet_path}/document.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="/eip/editInPlace.css" media="screen" />

        <script type="text/javascript" src="/eip/sarissa.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript" src="/eip/sarissa_ieemu_xpath.js"><xsl:text> </xsl:text></script>
	
	<script type="text/javascript" src="/js/exercise.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/js/qml_1-0.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/eip/xmlHttpCheck.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/eip/editInPlace.js"><xsl:text> </xsl:text></script>
	<script type="text/javascript" src="/eip/published_init_eip.js"><xsl:text> </xsl:text></script>

	<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
	<link rel="source" title="Source" type="text/xml" href="/content/{$objectId}/{$version}/source" />
	<link rel="module" title="Module" type="text/xml" href="/content/{$objectId}/latest/" />
	<link rel="meta" type="application/rdf+xml" href="content_license" />
      </head>

      <body onload="initEip()" id="cnx_eip">

	<!-- Editing In Place javascript -->
	<form id="eipCommitForm" action="/content/{$objectId}/postUpdate" method="POST">
	  <div id="eipInstructionBox">
	    <span class="cnx_before"> <!-- Instructions:  -->
	      <xsl:call-template name="gentext">
		<xsl:with-param name="key">Instructions</xsl:with-param>
		<xsl:with-param name="lang" select="$modlang" />
	      </xsl:call-template>
	    </span>
	    <!--
	    To edit text, click on an area with a white background.  
	    Warning: Reloading or leaving the page will discard any 
	    unpublished changes.
	    -->
	    <xsl:call-template name="gentext">
	      <xsl:with-param name="key">Instructionstext</xsl:with-param>
	      <xsl:with-param name="lang" select="$modlang" />
	    </xsl:call-template>
	  </div>
	  <div id="eipCommitBox">
	    <div id="eipCommitLabel"> <!-- Briefly describe your changes: -->
	      <xsl:call-template name="gentext">
		<xsl:with-param name="key">Brieflydescribeyourchanges</xsl:with-param>
		<xsl:with-param name="lang" select="$modlang" />
	      </xsl:call-template>
	    </div>
	    <textarea id="eipCommitText" name="message" rows="2" ><xsl:text> </xsl:text></textarea>
	  </div>
	  <div id="eipCommitButtonBox">
	    <input type="hidden" name="baseVersion" value="{$version}" />
	    <button type="button" name="commit" onclick="doCommit()"> <!-- Publish -->
	      <xsl:attribute name="value">
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key">Publish</xsl:with-param>
		  <xsl:with-param name="lang" select="$modlang" />
		</xsl:call-template>
	      </xsl:attribute>
	      <xsl:call-template name="gentext">
		<xsl:with-param name="key">Publish</xsl:with-param>
		<xsl:with-param name="lang" select="$modlang" />
	      </xsl:call-template>
	    </button> 
	    <button type="button" name="cancel" onclick="doDiscard()"> <!-- Discard -->
	      <xsl:attribute name="value">
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key">Discard</xsl:with-param>
		  <xsl:with-param name="lang" select="$modlang" />
		</xsl:call-template>
	      </xsl:attribute>
	      <xsl:call-template name="gentext">
		<xsl:with-param name="key">Discard</xsl:with-param>
		<xsl:with-param name="lang" select="$modlang" />
	      </xsl:call-template>
	    </button>
	    <!-- <button alt="Patch" onclick="patchOnClick()" disabled="true">Patch</button> -->
	  </div>
	</form>

	<div id="cnx_module_header">
	  <h1><xsl:value-of select="title" /></h1>
	  <xsl:if test="metadata/abstract">
	    <p id="cnx_abstract">
	      <span class="cnx_before"> <!-- Summary: -->
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key">Summary</xsl:with-param>
		  <xsl:with-param name="lang" select="$modlang" />
		</xsl:call-template>
	      </span>
	      <xsl:value-of select="metadata/abstract" />
	    </p>
	  </xsl:if>
	</div>

        <xsl:apply-templates select="cnx:document" />

      </body>
    </html>

  </xsl:template>

  <!-- CONTENT -->
  <!-- add ID as CSS selector to distinguish content definitions from glossary definitions -->
  <xsl:template match="cnx:content">
    <div id="cnx_content">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <!-- SECTION -->
  <!-- force a space in the header, so that EIP can always display the section editing links -->
  <!-- add "section-contents" class as CSS selector for styling needs -->
  <!-- add "End of Section" text so users can more easily discern document structure -->
  <xsl:template match="cnx:section">
    <div class="section">
      <xsl:call-template name='IdCheck'/>
      <xsl:variable name="level-number">
        <xsl:call-template name="level-count" />
      </xsl:variable>
      <!-- h2, h3, etc... -->
      <xsl:element name="h{$level-number}">
        <xsl:attribute name="class">section-header</xsl:attribute>
        <xsl:variable name="labeled-exercise" select="(parent::cnx:problem or parent::cnx:solution) and
                                                      not(cnx:label[not(node())])" />
        <xsl:if test="cnx:label[node()] or $labeled-exercise">
          <span class="cnx_label">
            <xsl:apply-templates select="cnx:label" />
            <xsl:if test="cnx:label[node()] and (cnx:title[node()] and not($labeled-exercise))">
              <xsl:text>: </xsl:text>       
            </xsl:if>
            <xsl:if test="$labeled-exercise">
              <xsl:number level="any" count="cnx:exercise" format="1."/>
              <xsl:number level="single" format="a) " />
            </xsl:if>
          </span>
        </xsl:if>
        <xsl:apply-templates select="cnx:title"/>
        <xsl:text>&#160;</xsl:text>
      </xsl:element>
      <div class="section-contents">
        <xsl:apply-templates select="*[not(self::cnx:title|self::cnx:label)]"/>
      </div>
      <div class="section-end">End of section</div>
    </div>
  </xsl:template>

  <!-- PARA -->
  <!-- use <div> instead of <p> so that IE doesn't (a) prevent any element from being editable, or (b) visually close the paragraph 
       if an "illegal" block element, such as list or blockquote, is nested in the paragraph -->
  <!-- put para name inside the <div> -->
  <xsl:template match="cnx:para">
    <div class="para">
      <xsl:call-template name='IdCheck'/>     
      <xsl:if test="cnx:title[node()]">
        <xsl:variable name="level-number">
          <xsl:call-template name="level-count" />
        </xsl:variable>      
        <!-- h2, h3, etc... -->
        <xsl:element name="h{$level-number}">      
          <xsl:attribute name="class">para-header</xsl:attribute>
          <xsl:apply-templates select="cnx:title" />
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="*[not(self::cnx:title)]|text()" />
      <xsl:if test="not(node())">
        <xsl:comment>empty para tag</xsl:comment>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>
