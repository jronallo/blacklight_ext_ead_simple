<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9" xmlns:ns2="http://www.w3.org/1999/xlink"
    exclude-result-prefixes="xsl ead ns2">
    <!--
        *******************************************************************
        *                                                                 *
        * VERSION:          1.01                                          *
        *                                                                 *
        * AUTHOR:           Winona Salesky                                *
        *                   wsalesky@gmail.com                            *
        *                                                                 *
        *                                                                 *
        * ABOUT:           This file has been created for use with        *
        *                  the Archivists' Toolkit  July 30 2008.         *
        *                  this file calls lookupLists.xsl, which         *
        *                  should be located in the same folder.          *
        *                                                                 *
        * UPDATED          March 23, 2009                                 *
        *                  Added revision description and date,           * 
        *                  and publication information                    *
        *                  March 12, 2009                                 *
        *                  Fixed character encoding issues                *
        *                  March 11, 2009                                 *
        *                  Added repository branding device to header     *
        *                  March 1, 2009                                  *
        *                  Changed bulk date display for unitdates        *
        *                  Feb. 6, 2009                                   *
        *                  Added roles to creator display in summary      * 
        * UPDATED NCSU     August 2009                                    *
        *                  Entire <dsc> redone by Joyce Chapman.          *
        *                  Substantial other changes higher up as well.   *
        *******************************************************************
    -->

    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="html" encoding="utf-8"/>

    <!--    
<xsl:include href="reports/Resources/eadToPdf/lookupLists.xsl"/>
-->

    <!--<xsl:include href="lookupLists.xsl"/>-->
    <!-- Creates the body of the finding aid.-->
    <xsl:template match="/">
        <div id="xslt_output">
            <div id="main">

                <div id="contents">
                    <div id="content-right">
                        <!-- Arranges archdesc into predefined sections, to change order
                        or groupings, rearrange templates  -->
                        <div class="section" id="abstract">
                            <xsl:apply-templates select="/ead/archdesc/did/abstract"/>
                        </div>
                        <div class="section" id="bioghist">
                            <xsl:apply-templates select="/ead/archdesc/bioghist"/>
                        </div>
                        <div class="section" id="scopecontent">
                            <xsl:apply-templates select="/ead/archdesc/scopecontent"/>
                        </div>
                        <div class="section" id="arrangement">
                            <xsl:apply-templates select="/ead/archdesc/arrangement"/>
                        </div>
                        <xsl:apply-templates select="/ead/archdesc/daogrp"/>
                        <xsl:apply-templates select="/ead/archdesc/dao"/>
                        <xsl:if test="/ead/archdesc/dsc/child::*">
                            <xsl:apply-templates select="/ead/archdesc/dsc"/>
                        </xsl:if>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- This template creates a customizable header  -->
    <xsl:template name="header">
        <div id="header">
            <div>
                <h3>
                    <xsl:value-of select="/ead/eadheader/filedesc/publicationstmt/publisher"/>
                </h3>
                <!-- Adds repositry branding device, looks best if this is under 100px high. -->
                <xsl:if test="/ead/eadheader/filedesc/publicationstmt/p/extref">
                    <img src="{/ead/eadheader/filedesc/publicationstmt/p/extref/@ns2:href}"/>
                </xsl:if>
            </div>
        </div>
    </xsl:template>

    <!-- HTML meta tags for use by web search engines for indexing. -->
    <xsl:template name="metadata">
        <meta http-equiv="Content-Type" name="dc.title"
            content="{concat(/ead/eadheader/filedesc/titlestmt/titleproper,' ',/ead/eadheader/filedesc/titlestmt/subtitle)}"/>
        <meta http-equiv="Content-Type" name="dc.author" content="{/ead/archdesc/did/origination}"/>
        <xsl:for-each select="/ead/archdesc/controlaccess/descendant::*">
            <meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
        </xsl:for-each>
        <meta http-equiv="Content-Type" name="dc.type" content="text"/>
        <meta http-equiv="Content-Type" name="dc.format" content="manuscripts"/>
        <meta http-equiv="Content-Type" name="dc.format" content="finding aids"/>
    </xsl:template>

    <!-- Named template for a generic p element with a link back to the table of contents  -->
    <xsl:template name="returnTOC">
        <p class="returnTOC">
            <a href="#toc">Return to Table of Contents »</a>
        </p>
        
    </xsl:template>

    <!-- this template is apparently doing nothing JOYCE -->
    <xsl:template match="eadheader">
        <h1 id="{generate-id(filedesc/titlestmt/titleproper)}">
            <xsl:apply-templates select="filedesc/titlestmt/titleproper"/>
        </h1>
        <xsl:if test="filedesc/titlestmt/subtitle">
            <h2>
                <xsl:apply-templates select="filedesc/titlestmt/subtitle"/>
            </h2>
        </xsl:if>
    </xsl:template>
    <xsl:template match="filedesc/titlestmt/titleproper">
        <xsl:choose>
            <xsl:when test="@type = 'filing'">
                <xsl:choose>
                    <xsl:when test="count(parent::*/titleproper) &gt; 1"/>
                    <xsl:otherwise>
                        <xsl:value-of select="/ead/archdesc/did/unittitle"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="filedesc/titlestmt/titleproper/num">
        <br/>
        <xsl:apply-templates/>
    </xsl:template>
    
   <!-- JOYCE: I'm not calling these -->
   <!-- <xsl:template match="archdesc/did">
        <h3>
            <a name="{generate-id(.)}">
                <xsl:choose>
                    <xsl:when test="head">
                        <xsl:value-of select="head"/>
                    </xsl:when>
                    <xsl:otherwise> Summary Information </xsl:otherwise>
                </xsl:choose>
            </a>
        </h3>-->
        <!-- Determines the order in wich elements from the archdesc did appear, 
            to change the order of appearance for the children of did
            by changing the order of the following statements.
         -->
       <!-- <dl class="summary">
            <xsl:apply-templates select="repository"/>
            <xsl:apply-templates select="origination"/>
            <xsl:apply-templates select="unittitle"/>
            <xsl:apply-templates select="unitid"/>
            <xsl:apply-templates select="unitdate"/>
            <xsl:apply-templates select="physdesc"/>
            <xsl:apply-templates select="physloc"/>
            <xsl:apply-templates select="langmaterial"/>
            <xsl:apply-templates select="materialspec"/>
            <xsl:apply-templates select="container"/>
            <xsl:apply-templates select="abstract"/>
            <xsl:apply-templates select="note"/>
        </dl>
        <xsl:apply-templates select="../prefercite"/>
        <xsl:call-template name="returnTOC"/>
    </xsl:template>-->
    <!-- Template calls and formats the children of archdesc/did -->
    <!--  <xsl:template match="archdesc/did/repository | archdesc/did/unittitle | archdesc/did/unitid | archdesc/did/origination 
        | archdesc/did/unitdate | archdesc/did/physdesc | archdesc/did/physloc 
        | archdesc/did/abstract | archdesc/did/langmaterial | archdesc/did/materialspec | archdesc/did/container">
        <dt>
            <xsl:choose>
                <xsl:when test="@label">
                    <xsl:value-of select="concat(translate( substring(@label, 1, 1 ),
                        'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ), 
                        substring(@label, 2, string-length(@label )))" />
                    <xsl:if test="@type"> [<xsl:value-of select="@type"/>]</xsl:if>
                    <xsl:if test="self::origination">
                        <xsl:choose>
                            <xsl:when test="persname[@role != ''] and contains(persname/@role,' (')">
                                - <xsl:value-of select="substring-before(persname/@role,' (')"/>
                            </xsl:when>
                            <xsl:when test="persname[@role != '']">
                                - <xsl:value-of select="persname/@role"/>  
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="self::repository">Repository</xsl:when>
                        <xsl:when test="self::unittitle">Title</xsl:when>
                        <xsl:when test="self::unitid">ID</xsl:when>
                        <xsl:when test="self::unitdate">Date<xsl:if test="@type"> [<xsl:value-of select="@type"/>]</xsl:if></xsl:when>
                        <xsl:when test="self::origination">
                            <xsl:choose>
                                <xsl:when test="persname[@role != ''] and contains(persname/@role,' (')">
                                    Creator - <xsl:value-of select="substring-before(persname/@role,' (')"/>
                                </xsl:when>
                                <xsl:when test="persname[@role != '']">
                                    Creator - <xsl:value-of select="persname/@role"/>  
                                </xsl:when>
                                <xsl:otherwise>
                                    Creator        
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="self::physdesc">Extent</xsl:when>
                        <xsl:when test="self::abstract">Abstract</xsl:when>
                        <xsl:when test="self::physloc">Location</xsl:when>
                        <xsl:when test="self::langmaterial">Language</xsl:when>
                        <xsl:when test="self::materialspec">Technical</xsl:when>
                        <xsl:when test="self::container">Container</xsl:when>
                        <xsl:when test="self::note">Note</xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </dt>
        <dd>
            <xsl:apply-templates/>
        </dd>
        </xsl:template>-->

    <xsl:template match="archdesc/did/abstract[1]">

        <h3>Abstract</h3>
        <p>
            <xsl:apply-templates/>
        </p>

    </xsl:template>

    <xsl:template match="archdesc/did/abstract[2]">
        <p>
            <xsl:apply-templates/>
        </p>
        <xsl:call-template name="returnTOC"/>
    </xsl:template>

    <!-- Template calls and formats all other children of archdesc many of 
        these elements are repeatable within the dsc section as well.
    JOYCE: I'm not calling this -->
    <xsl:template
        match="bibliography | odd | accruals | arrangement  | bioghist 
        | accessrestrict | userestrict  | custodhist | altformavail | originalsloc 
        | fileplan | acqinfo | otherfindaid | phystech | processinfo | relatedmaterial
        | scopecontent  | separatedmaterial | appraisal">
        <xsl:choose>
            <xsl:when test="head">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="parent::archdesc">
                        <xsl:choose>
                            <xsl:when test="self::bibliography">
                                <h3><xsl:call-template name="anchor"/>Bibliography</h3>
                            </xsl:when>
                            <xsl:when test="self::odd">
                                <h3><xsl:call-template name="anchor"/>Other Descriptive Data</h3>
                            </xsl:when>
                            <xsl:when test="self::accruals">
                                <h4><xsl:call-template name="anchor"/>Accruals</h4>
                            </xsl:when>
                            <xsl:when test="self::arrangement">
                                <h3><xsl:call-template name="anchor"/>Arrangement</h3>
                            </xsl:when>
                            <xsl:when test="self::bioghist">
                                <h3><xsl:call-template name="anchor"/>Biography/History</h3>
                            </xsl:when>
                            <xsl:when test="self::accessrestrict">
                                <h4><xsl:call-template name="anchor"/>Restrictions on Access</h4>
                            </xsl:when>
                            <xsl:when test="self::userestrict">
                                <h4><xsl:call-template name="anchor"/>Restrictions on Use</h4>
                            </xsl:when>
                            <xsl:when test="self::custodhist">
                                <h4><xsl:call-template name="anchor"/>Custodial History</h4>
                            </xsl:when>
                            <xsl:when test="self::altformavail">
                                <h4><xsl:call-template name="anchor"/>Alternative Form
                                Available</h4>
                            </xsl:when>
                            <xsl:when test="self::originalsloc">
                                <h4><xsl:call-template name="anchor"/>Original Location</h4>
                            </xsl:when>
                            <xsl:when test="self::fileplan">
                                <h3><xsl:call-template name="anchor"/>File Plan</h3>
                            </xsl:when>
                            <xsl:when test="self::acqinfo">
                                <h4><xsl:call-template name="anchor"/>Acquisition Information</h4>
                            </xsl:when>
                            <xsl:when test="self::otherfindaid">
                                <h3><xsl:call-template name="anchor"/>Other Finding Aids</h3>
                            </xsl:when>
                            <xsl:when test="self::phystech">
                                <h3><xsl:call-template name="anchor"/>Physical Characteristics and
                                    Technical Requirements</h3>
                            </xsl:when>
                            <xsl:when test="self::processinfo">
                                <h4><xsl:call-template name="anchor"/>Processing Information</h4>
                            </xsl:when>
                            <xsl:when test="self::relatedmaterial">
                                <h4><xsl:call-template name="anchor"/>Related Material</h4>
                            </xsl:when>
                            <xsl:when test="self::scopecontent">
                                <h3><xsl:call-template name="anchor"/>Scope and Content</h3>
                            </xsl:when>
                            <xsl:when test="self::separatedmaterial">
                                <h4><xsl:call-template name="anchor"/>Separated Material</h4>
                            </xsl:when>
                            <xsl:when test="self::appraisal">
                                <h4><xsl:call-template name="anchor"/>Appraisal</h4>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4>
                            <xsl:call-template name="anchor"/>
                            <xsl:choose>
                                <xsl:when test="self::bibliography">Bibliography</xsl:when>
                                <xsl:when test="self::odd">Other Descriptive Data</xsl:when>
                                <xsl:when test="self::accruals">Accruals</xsl:when>
                                <xsl:when test="self::arrangement">Arrangement</xsl:when>
                                <xsl:when test="self::bioghist">Biography/History</xsl:when>
                                <xsl:when test="self::accessrestrict">Restrictions on Access</xsl:when>
                                <xsl:when test="self::userestrict">Restrictions on Use</xsl:when>
                                <xsl:when test="self::custodhist">Custodial History</xsl:when>
                                <xsl:when test="self::altformavail">Alternative Form Available</xsl:when>
                                <xsl:when test="self::originalsloc">Original Location</xsl:when>
                                <xsl:when test="self::fileplan">File Plan</xsl:when>
                                <xsl:when test="self::acqinfo">Acquisition Information</xsl:when>
                                <xsl:when test="self::otherfindaid">Other Finding Aids</xsl:when>
                                <xsl:when test="self::phystech">Physical Characteristics and
                                    Technical Requirements</xsl:when>
                                <xsl:when test="self::processinfo">Processing Information</xsl:when>
                                <xsl:when test="self::relatedmaterial">Related Material</xsl:when>
                                <xsl:when test="self::scopecontent">Scope and Content</xsl:when>
                                <xsl:when test="self::separatedmaterial">Separated Material</xsl:when>
                                <xsl:when test="self::appraisal">Appraisal</xsl:when>
                            </xsl:choose>
                        </h4>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <!-- If the element is a child of arcdesc then a link to the table of contents is included -->
        <xsl:if test="parent::archdesc">
            <xsl:choose>
                <xsl:when
                    test="self::accessrestrict or self::userestrict or
                    self::custodhist or self::accruals or
                    self::altformavail or self::acqinfo or
                    self::processinfo or self::appraisal or
                    self::originalsloc or  
                    self::relatedmaterial or self::separatedmaterial or self::prefercite"/>
                <xsl:otherwise>
                    <xsl:call-template name="returnTOC"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- Templates for publication information  -->
    <xsl:template match="/ead/eadheader/filedesc/publicationstmt">
        <h4>Publication Information</h4>
        <p>
            <xsl:apply-templates select="publisher"/>
            <xsl:if test="date">&#160;<xsl:apply-templates select="date"/></xsl:if>
        </p>
    </xsl:template>
    <!-- Templates for revision description  -->
    <xsl:template match="/ead/eadheader/revisiondesc">
        <h4>Revision Description</h4>
        <p>
            <xsl:if test="change/item">
                <xsl:apply-templates select="change/item"/>
            </xsl:if>
            <xsl:if test="change/date">&#160;<xsl:apply-templates select="change/date"
            /></xsl:if>
        </p>
    </xsl:template>


    <!-- Formats index and child elements, groups indexentry elements by type (i.e. corpname, subject...)-->
    <xsl:template match="index">
        <xsl:choose>
            <xsl:when test="head"/>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="parent::archdesc">
                        <h3><xsl:call-template name="anchor"/>Index</h3>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4><xsl:call-template name="anchor"/>Index</h4>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="child::*[not(self::indexentry)]"/>
        <xsl:if test="indexentry/corpname">
            <h4>Corporate Name(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/corpname">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/famname">
            <h4>Family Name(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/famname">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/function">
            <h4>Function(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/function">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/genreform">
            <h4>Genre(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/genreform">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/geogname">
            <h4>Geographic Name(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/geogname">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/name">
            <h4>Name(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/name">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/occupation">
            <h4>Occupation(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/occupation">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/persname">
            <h4>Personal Name(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/persname">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/subject">
            <h4>Subject(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/subject">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="indexentry/title">
            <h4>Title(s)</h4>
            <ul>
                <xsl:for-each select="indexentry/title">
                    <xsl:sort/>
                    <li><xsl:apply-templates select="."/>: &#160;<xsl:apply-templates
                            select="following-sibling::*"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="parent::archdesc">
            <xsl:call-template name="returnTOC"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="indexentry">
        <dl class="indexEntry">
            <dt>
                <xsl:apply-templates select="child::*[1]"/>
            </dt>
            <dd>
                <xsl:apply-templates select="child::*[2]"/>
            </dd>
        </dl>
    </xsl:template>
    <xsl:template match="ptrgrp">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Linking elements. -->
    <xsl:template match="ptr">
        <xsl:choose>
            <xsl:when test="@target">
                <a href="#{@target}">
                    <xsl:value-of select="@target"/>
                </a>
                <xsl:if test="following-sibling::ptr">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:choose>
            <xsl:when test="@target">
                <a href="#{@target}">
                    <xsl:apply-templates/>
                </a>
                <xsl:if test="following-sibling::ref">, </xsl:if>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <a href="#{@ns2:href}">
                    <xsl:apply-templates/>
                </a>
                <xsl:if test="following-sibling::ref">, </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="extptr">
        <xsl:choose>
            <xsl:when test="@href">
                <a href="{@href}">
                    <xsl:value-of select="@title"/>
                </a>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <a href="{@ns2:href}">
                    <xsl:value-of select="@title"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@title"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="extref">
        <xsl:choose>
            <xsl:when test="@href">
                <a href="{@href}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:when test="@ns2:href">
                <a href="{@ns2:href}">
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

  <!--   <xsl:template name="xsearchlink">
        <xsl:value-of select="@ns2:href"/>
             <xsl:text>http://dlisbox.lib.ncsu.edu/xsearch/?f[type_facet][]=Still+image&amp;per_page=10&amp;q=</xsl:text>
        <xsl:value-of select="matches(@ns2:href, '[a-z]{2}([0-9]{3}.){2}[0-9]{3}')"></xsl:value-of>
        <xsl:text>&amp;qt=search</xsl:text>
    </xsl:template>-->

    <!--Creates a hidden anchor tag that allows navigation within the finding aid. 
    In this stylesheet only children of the archdesc and c0* itmes call this template. 
    It can be applied anywhere in the stylesheet as the id attribute is universal. -->
    <xsl:template match="@id">
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>


    <xsl:template name="anchor">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="tocLinks">
        <xsl:choose>
            <xsl:when test="self::*/@id">
                <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">#<xsl:value-of select="generate-id(.)"/></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--Bibref, choose statement decides if the citation is inline, if there is a parent element
    or if it is its own line, typically when it is a child of the bibliography element.-->
    <xsl:template match="bibref">
        <xsl:choose>
            <xsl:when test="parent::p">
                <xsl:choose>
                    <xsl:when test="@ns2:href[not(not(string(.)))]">
                        <a href="{@ns2:href}">
                            <xsl:apply-templates/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:choose>
                        <xsl:when test="@ns2:href">
                            <a href="{@ns2:href}">
                                <xsl:apply-templates/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Formats prefered citiation -->
    <xsl:template match="prefercite">
        <div class="citation">
            <xsl:choose>
                <xsl:when test="head">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <h4>Preferred Citation</h4>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!-- Applies a span style to address elements, currently addresses are displayed 
        as a block item, display can be changed to inline, by changing the CSS -->
    <xsl:template match="address">
        <span class="address">
            <xsl:for-each select="child::*">
                <xsl:apply-templates/>
                <xsl:choose>
                    <xsl:when test="lb"/>
                    <xsl:otherwise>
                        <br/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </span>
    </xsl:template>

    <!-- Formats headings throughout the finding aid -->
    <xsl:template match="head[parent::*/parent::archdesc]">
        <xsl:choose>
            <xsl:when
                test="parent::accessrestrict or parent::userestrict or
                parent::custodhist or parent::accruals or
                parent::altformavail or parent::acqinfo or
                parent::processinfo or parent::appraisal or
                parent::originalsloc or  
                parent::relatedmaterial or parent::separatedmaterial or parent::prefercite">
                <h4>
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
            <xsl:otherwise>
                <h3>
                    <xsl:choose>
                        <xsl:when test="parent::*/@id">
                            <xsl:attribute name="id">
                                <xsl:value-of select="parent::*/@id"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="id">
                                <xsl:value-of select="generate-id(parent::*)"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="head">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>

    <!-- Digital Archival Object -->
    <xsl:template match="daogrp">
        <div class="section" id="daogrp">
            <xsl:choose>
                <xsl:when test="parent::archdesc">
                    <h3>
                        <xsl:call-template name="anchor"/>
                        <xsl:choose>
                            <xsl:when test="@ns2:title">
                                <xsl:value-of select="@ns2:title"/>
                            </xsl:when>
                            <xsl:otherwise> Digital Archival Object </xsl:otherwise>
                        </xsl:choose>
                    </h3>
                </xsl:when>
                <xsl:otherwise>
                    <h4>
                        <xsl:call-template name="anchor"/>
                        <xsl:choose>
                            <xsl:when test="@ns2:title">
                                <xsl:value-of select="@ns2:title"/>
                            </xsl:when>
                            <xsl:otherwise> Digital Archival Object </xsl:otherwise>
                        </xsl:choose>
                    </h4>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

<!--    <xsl:template match="dao">
        <div class="section" id="dao">
            <xsl:choose>
                <xsl:when test="child::*">
                    <xsl:apply-templates/>

                      <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:call-template name="xsearchlink"></xsl:call-template>
                    </xsl:attribute>Click to view
                </xsl:element>

                    <a href="{@ns2:href}"> Click to view </a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="{@ns2:href}">
                        <xsl:value-of select="@ns2:href"/>
                    </a>
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:call-template name="xsearchlink"/>
                        </xsl:attribute>Click to view </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>-->

    
    <xsl:template match="daoloc">
        <a href="{@ns2:href}">
            <xsl:value-of select="@ns2:title"/>
        </a>
    </xsl:template>

    <!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
    <xsl:template match="table">
        <xsl:for-each select="tgroup">
            <table>
                <tr>
                    <xsl:for-each select="colspec">
                        <td width="{@colwidth}"/>
                    </xsl:for-each>
                </tr>
                <xsl:for-each select="thead">
                    <xsl:for-each select="row">
                        <tr>
                            <xsl:for-each select="entry">
                                <td valign="top">
                                    <strong>
                                        <xsl:value-of select="."/>
                                    </strong>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="tbody">
                    <xsl:for-each select="row">
                        <tr>
                            <xsl:for-each select="entry">
                                <td valign="top">
                                    <xsl:value-of select="."/>
                                </td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
            </table>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="unitdate">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:choose>
            <xsl:when test="@type = 'bulk'"> (<xsl:apply-templates/>) </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="date">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="unittitle">
        <xsl:choose>
            <xsl:when test="child::unitdate[@type='bulk']">
                <xsl:apply-templates select="node()[not(self::unitdate[@type='bulk'])]"/>
                <xsl:apply-templates select="date[@type='bulk']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Following five templates output chronlist and children in a table -->
    <xsl:template match="chronlist">
        <table class="chronlist">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <xsl:template match="chronlist/listhead">
        <tr>
            <th>
                <xsl:apply-templates select="head01"/>
            </th>
            <th>
                <xsl:apply-templates select="head02"/>
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="chronlist/head">
        <tr>
            <th>
                <xsl:apply-templates/>
            </th>
        </tr>
    </xsl:template>
    <xsl:template match="chronitem">
        <tr>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="(position() mod 2 = 0)">odd</xsl:when>
                    <xsl:otherwise>even</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <td>
                <xsl:apply-templates select="date"/>
            </td>
            <td>
                <xsl:apply-templates select="descendant::event"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="event">
        <xsl:choose>
            <xsl:when test="following-sibling::*">
                <xsl:apply-templates/>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Output for a variety of list types -->
    <xsl:template match="list">
        <xsl:if test="head">
            <h4>
                <xsl:value-of select="head"/>
            </h4>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="descendant::defitem">
                <dl>
                    <xsl:apply-templates select="defitem"/>
                </dl>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@type = 'ordered'">
                        <ol>
                            <xsl:attribute name="class">
                                <xsl:value-of select="@numeration"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </ol>
                    </xsl:when>
                    <xsl:when test="@numeration">
                        <ol>
                            <xsl:attribute name="class">
                                <xsl:value-of select="@numeration"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </ol>
                    </xsl:when>
                    <xsl:when test="@type='simple'">
                        <ul>
                            <xsl:attribute name="class">simple</xsl:attribute>
                            <xsl:apply-templates select="child::*[not(head)]"/>
                        </ul>
                    </xsl:when>
                    <xsl:otherwise>
                        <ul>
                            <xsl:apply-templates/>
                        </ul>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="list/head"/>
    <xsl:template match="list/item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="defitem">
        <dt>
            <xsl:apply-templates select="label"/>
        </dt>
        <dd>
            <xsl:apply-templates select="item"/>
        </dd>
    </xsl:template>

    <!-- Formats list as tabel if list has listhead element  -->
    <xsl:template match="list[child::listhead]">
        <table>
            <tr>
                <th>
                    <xsl:value-of select="listhead/head01"/>
                </th>
                <th>
                    <xsl:value-of select="listhead/head02"/>
                </th>
            </tr>
            <xsl:for-each select="defitem">
                <tr>
                    <td>
                        <xsl:apply-templates select="label"/>
                    </td>
                    <td>
                        <xsl:apply-templates select="item"/>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!-- Formats notestmt and notes -->
    <xsl:template match="notestmt">
        <h4>Note</h4>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="note">
        <xsl:choose>
            <xsl:when test="parent::notestmt">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="@label">
                        <h4>
                            <xsl:value-of select="@label"/>
                        </h4>
                        <xsl:apply-templates/>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4>Note</h4>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Child elements that should display as paragraphs-->
    <xsl:template match="legalstatus">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!-- Puts a space between sibling elements -->
    <xsl:template match="child::*">
        <xsl:if test="preceding-sibling::*">&#160;</xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <!-- Generic text display elements -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    <xsl:template match="blockquote">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    <xsl:template match="emph">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <!--Render elements -->
    <xsl:template match="*[@render = 'bold'] | *[@altrender = 'bold'] ">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="bold"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="*[@render = 'bolddoublequote'] | *[@altrender = 'bolddoublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="bold">"<xsl:apply-templates/>"</span>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsinglequote'] | *[@altrender = 'boldsinglequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="bold">'<xsl:apply-templates/>'</span>
    </xsl:template>
    <xsl:template match="*[@render = 'bolditalic'] | *[@altrender = 'bolditalic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <strong>
            <span class="italic">
                <xsl:apply-templates/>
            </span>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldsmcaps'] | *[@altrender = 'boldsmcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <strong>
            <span class="smcaps"><xsl:apply-templates/></span>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'boldunderline'] | *[@altrender = 'boldunderline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <strong>
            <span class="underline">
                <xsl:apply-templates/>
            </span>
        </strong>
    </xsl:template>
    <xsl:template match="*[@render = 'doublequote'] | *[@altrender = 'doublequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>"<xsl:apply-templates/>" </xsl:template>
    <xsl:template match="*[@render = 'italic'] | *[@altrender = 'italic']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="italic"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="*[@render = 'singlequote'] | *[@altrender = 'singlequote']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>'<xsl:apply-templates/>' </xsl:template>
    <xsl:template match="*[@render = 'smcaps'] | *[@altrender = 'smcaps']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="smcaps">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="*[@render = 'sub'] | *[@altrender = 'sub']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="*[@render = 'super'] | *[@altrender = 'super']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="*[@render = 'underline'] | *[@altrender = 'underline']">
        <xsl:if test="preceding-sibling::*"> &#160;</xsl:if>
        <span class="underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <!-- 
        <value>nonproport</value>        
    -->



    <!-- ========================================== -->
    <!-- ***     Begin templates for <dsc>      *** -->
    <!-- ***     (AT templates end above)       *** -->
    <!-- ========================================== -->

    <xsl:template match="archdesc/dsc">
        <div id="dsc" class="section">            
            <h3>Collection Inventory</h3>
            <xsl:apply-templates select="c01"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="dsc/head"/> 
    <xsl:template match="dsc//scopecontent/head"/>


    <xsl:template name="title">
        <xsl:element name="h3">
            <xsl:attribute name="id"><xsl:value-of select="parent::node()/@id"/></xsl:attribute>
            <xsl:if test="container">
                <xsl:attribute name="class">file</xsl:attribute>
            </xsl:if>
            <a>
            <xsl:apply-templates select="unittitle"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="unitdate"/></a>
        </xsl:element>
    </xsl:template>

    <xsl:template name="component-did">
        <xsl:apply-templates select="physdesc"/>
        <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
            <xsl:apply-templates/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="dsc//physdesc[not(extent)][not(not(string(.)))]">
        <p>
            <span class="physdesc">
                <xsl:text>Physical description: </xsl:text>
            </span>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="dsc//physdesc/extent[not(not(string(.)))]">
        <p>
            <span class="physdesc">
                <xsl:text>Size: </xsl:text>
            </span>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>


    <xsl:template match="c01">
        <table class="c01">
            <tr>
                <td/>
                <td/>
                <td/>
            </tr>
            <xsl:choose>
                <xsl:when test="did/container">
                    <xsl:apply-templates select="did"/>
                </xsl:when>
                <xsl:otherwise>
                            <xsl:apply-templates select="did"/>
                    <xsl:apply-templates select="c02"/>
                </xsl:otherwise>
            </xsl:choose>
        </table>
    </xsl:template>
    
    <!--Processes series/subseries did -->
    <xsl:template match="*[@level='series']/did | *[@level='subseries']/did">
        <tr class="t{count(ancestor::node())}">
            <td colspan="3">
                    <xsl:call-template name="title"/>
                <xsl:call-template name="component-did"/>
                <xsl:apply-templates
                    select="following-sibling::scopecontent | following-sibling::bioghist | 
                    following-sibling::arrangement |  following-sibling::userestrict | following-sibling::accessrestrict 
                    | following-sibling::processinfo | following-sibling::acqinfo | following-sibling::custodhist | 
                    following-sibling::controlaccess/controlaccess | following-sibling::odd | following-sibling::note |
                    following-sibling::descgrp/*"
                    > </xsl:apply-templates>
                <xsl:call-template name="dao"/>
            </td>
        </tr>
    </xsl:template>
  

    <xsl:template
        match="dsc//scopecontent | dsc//bioghist | dsc//arrangement | dsc//userestrict | dsc//accessrestrict |
        dsc//processinfo | dsc//acqinfo | dsc//custodhist | dsc//controlaccess/controlaccess 
        | dsc//odd | dsc//note | dsc//descgrp/*">
        <xsl:for-each select="*[not(self::head)]">
            <xsl:choose>
                <xsl:when test="ancestor::node()[2]/@level='series' or ancestor::node()[2]/@level='subseries'">
                            <p class="scopelevel"><xsl:apply-templates/></p>
                </xsl:when>
                <xsl:otherwise>
                    <tr class="x{count(ancestor::node())}">
                        <td colspan="3">
                            <p class="scopelevel"><xsl:apply-templates/></p>
                        </td>
                    </tr>
                </xsl:otherwise>
            </xsl:choose>
           
        </xsl:for-each>
    </xsl:template>
    
   <xsl:template match="c02 | c03 | c04 | c05 | c06 | c07 | c08| c09 | c10 | c11 | c12">
       <xsl:apply-templates select="did | c02 | c03 | c04 | c05 | c06 | c07 | c08| c09 | c10 | c11 | c12"/>     
   </xsl:template>

    <!-- MATCH ALL <did> FOR COMPONANTS WITH CONTAINERS -->
    <xsl:template match="*[@level='file']/did">

        <xsl:variable name="class">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">mod0</xsl:when>
                <xsl:otherwise>mod1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="@audience='internal'"/>
            <xsl:otherwise>

                <tr class="{$class}">
                    <td valign="top" class="x{count(ancestor::node())}">
                        <span class="containertype">
                            <!-- output the value of the @type attribute, but capitalize it -->
                            <xsl:value-of
                                select="concat(translate(substring(container[1]/@type,
                            1,1),'abcdefghijklmnopqrstuvwxyz',
                            'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(container[1]/@type,2,string-length(container[1]/@type)))"
                            />
                        </span>
                        <xsl:text>&#160;</xsl:text>
                        <span class="container">
                            <xsl:value-of select="container[1]"/>
                        </span>
                    </td>
                    <td valign="top">
                        <span class="containertype">
                            <!-- output the value of the @type attribute, but capitalize it -->
                            <xsl:value-of
                                select="concat(translate(substring(container[2]/@type,
                            1,1),'abcdefghijklmnopqrstuvwxyz',
                            'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),substring(container[2]/@type,2,string-length(container[2]/@type)))"
                            />
                        </span>
                        <xsl:text>&#160;</xsl:text>
                        <span class="container">
                            <xsl:apply-templates select="container[2]"/>
                        </span>
                    </td>
                    <td valign="top">
                        <xsl:call-template name="title"/>
                        <xsl:call-template name="component-did"/>
                        <xsl:for-each select="abstract | note/p | langmaterial | materialspec">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                        <xsl:call-template name="dao"/>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dao">
        <xsl:if test="following-sibling::dao"><div class="section dao" >
            <a href="{following-sibling::dao/@ns2:href}">
                 <xsl:value-of select="following-sibling::dao/daodesc/p"/>
            </a>
        </div></xsl:if>
    </xsl:template>

</xsl:stylesheet>
