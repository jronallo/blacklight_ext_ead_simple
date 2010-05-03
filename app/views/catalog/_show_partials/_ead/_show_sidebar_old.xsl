<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:ns2="http://www.w3.org/1999/xlink"    
    exclude-result-prefixes="xsl ead ns2" >
    <!--
        JUST THE TOC LINKS FOR THE SIDEBAR!
    -->
    
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes" method="html"  encoding="utf-8"/>

<!--    
<xsl:include href="reports/Resources/eadToPdf/lookupLists.xsl"/>
-->

    <!--<xsl:include href="lookupLists.xsl"/>-->
    <!-- Creates the body of the finding aid.-->
        <xsl:template match="/">
            <xsl:call-template name="toc"/>
        </xsl:template>

    <!-- Creates an ordered table of contents that matches the order of the archdesc 
        elements. To change the order rearrange the if/for-each statements. -->  
    <xsl:template name="toc">
        <div id="toc">
            <h3>Table of Contents</h3>
            <dl>
                <!-- <xsl:if test="/ead/archdesc/did">
                    <dt><a href="#{generate-id(.)}">Summary Information</a></dt>
                    </xsl:if> -->
                <xsl:if test="/ead/archdesc/did/abstract">
                    <dt><a href="#{generate-id(.)}">Abstract</a></dt>
                </xsl:if> 
                <xsl:for-each select="/ead/archdesc/bioghist">
                        <dt>                                
                            <a><xsl:call-template name="tocLinks"/>
                                <xsl:choose>
                                    <xsl:when test="head">
                                        <xsl:value-of select="head"/></xsl:when>
                                    <xsl:otherwise>Biography/History</xsl:otherwise>
                                </xsl:choose>
                            </a>
                        </dt>   
                </xsl:for-each>
                <xsl:for-each select="/ead/archdesc/scopecontent">
                    <dt>                                
                        <a><xsl:call-template name="tocLinks"/>
                            <xsl:choose>
                                <xsl:when test="head">
                                    <xsl:value-of select="head"/></xsl:when>
                                <xsl:otherwise>Scope and Content</xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </dt>   
                </xsl:for-each>
                <xsl:for-each select="/ead/archdesc/arrangement">
                    <dt>                                
                        <a><xsl:call-template name="tocLinks"/>
                            <xsl:choose>
                                <xsl:when test="head">
                                    <xsl:value-of select="head"/></xsl:when>
                                <xsl:otherwise>Arrangement</xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </dt>   
                </xsl:for-each>
               
                <xsl:for-each select="/ead/archdesc/dsc">
                    <xsl:if test="child::*">
                        <dt>                                
                            <a href="#dsc">
                                <xsl:choose>
                                    <xsl:when test="head">
                                        <xsl:value-of select="head"/></xsl:when>
                                    <xsl:otherwise>Collection Inventory</xsl:otherwise>
                                </xsl:choose> 
                                <xsl:if test="descendant::dao and not(descendant::*[@level='subseries'] | descendant::*[@level='series'])"><xsl:text> </xsl:text>
                                    <img src="http://www.lib.ncsu.edu/findingaids/icons/default/image-x-generic.png" alt="Digital content available" title="Digital content available"/>
                                </xsl:if>
                               
                            </a>
                        </dt>                
                    </xsl:if>
                    <!--Creates a submenu for collections, record groups and series and fonds-->
                    <xsl:for-each select="child::*[@level = 'collection'] 
                        | child::*[@level = 'recordgrp']  | child::*[@level = 'series'] | child::*[@level = 'fonds']">
                        <dd><a><xsl:call-template name="tocLinks"/>
                            <xsl:choose>
                                <xsl:when test="head">
                                    <xsl:apply-templates select="child::*/head"/>      
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="child::*/unittitle"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="descendant::dao"><xsl:text> </xsl:text>  
                                <img src="http://www.lib.ncsu.edu/findingaids/icons/default/image-x-generic.png" alt="Digital content available" title="Digital content available"/>
                            </xsl:if>
                        </a></dd>
                    </xsl:for-each>
                </xsl:for-each>
            </dl>
        </div>
    </xsl:template>



    <!-- Linking elements. -->
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
    
    
    <!--Creates a hidden anchor tag that allows navigation within the finding aid. 
    In this stylesheet only children of the archdesc and c0* itmes call this template. 
    It can be applied anywhere in the stylesheet as the id attribute is universal. -->
    <xsl:template match="@id">
        <xsl:attribute name="id"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template name="anchor">
        <xsl:choose>
            <xsl:when test="@id">
                <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute>
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
 
    
   
    <xsl:template match="dao">
        <xsl:choose>
            <xsl:when test="child::*">
                <xsl:apply-templates/> 
                <a href="{@ns2:href}">
                    [<xsl:value-of select="@ns2:href"/>]
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a href="{@ns2:href}">
                    <xsl:value-of select="@ns2:href"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="daoloc">
        <a href="{@ns2:href}">
            <xsl:value-of select="@ns2:title"/>
        </a>
    </xsl:template>


</xsl:stylesheet>
