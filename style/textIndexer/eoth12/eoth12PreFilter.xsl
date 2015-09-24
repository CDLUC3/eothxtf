<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
   xmlns:xtf="http://cdlib.org/xtf"
   exclude-result-prefixes="#all">
   
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates and Functions                                  -->
   <!-- ====================================================================== -->
   
   <xsl:import href="../common/preFilterCommon.xsl"/>
   
   <!-- ====================================================================== -->
   <!-- Output parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xml" 
      indent="yes" 
      encoding="UTF-8"/>
   
   <!-- ====================================================================== -->
   <!-- Default: identity transformation                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/*">
      <xsl:copy>
         <xsl:namespace name="xtf" select="'http://cdlib.org/xtf'"/>
         <xsl:copy-of select="@*"/>
         <xsl:call-template name="get-meta"/>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Metadata Indexing                                                      -->
   <!-- ====================================================================== -->
   
 <xsl:template name="get-meta">
      <xsl:variable name="meta">
               <xsl:call-template name="get-title"/>
               <xsl:call-template name="get-subject"/>
               <xsl:call-template name="get-description"/>
               <xsl:call-template name="get-date"/>
               <xsl:call-template name="get-type"/>
               <xsl:call-template name="get-format"/>
               <xsl:call-template name="get-identifier"/>
               <xsl:call-template name="get-provenance"/>
               <xsl:call-template name="get-source"/>
               <xsl:call-template name="get-relation"/>
               <xsl:call-template name="get-coverage"/>   
               <xsl:call-template name="get-administration-facet"/>   
			   <xsl:call-template name="get-domain-facet"/>  
               <xsl:call-template name="get-branch-facet"/> 
         <!--  <xsl:call-template name="get-subject-facet"/> -->
      </xsl:variable>
<!--    
 <xsl:message>metadata is: 
    <xsl:copy-of select="$meta">
    
    </xsl:copy-of>
 </xsl:message>  
-->      
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display">
            <xsl:value-of select="'dynaxml'"/>
         </xsl:with-param>
         <xsl:with-param name="meta" select="$meta"/>
      </xsl:call-template>   
    </xsl:template>
    
   <!-- param to get source values out of the URL -->
   
    
   <!-- title --> 
 <!--  <xsl:template name="get-title">
      <xsl:choose>
         <xsl:when test="/*:dc/*:title">
            <title xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="/*:dc/*:title"/>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
            <xsl:value-of select="/*:dc/*:provenance"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> -->
   
   
   <!-- try title again -->

   
      <xsl:template name="get-title">
      <xsl:choose>
         <xsl:when test="/*:dc/*:title = ''">
            <title xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="/*:dc/*:provenance"/>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
            <xsl:value-of select="/*:dc/*:title"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   
   <!-- subject -->
   <xsl:template name="get-subject">
      <xsl:choose>
         <xsl:when test="/*:dc/*:subject">
             <xsl:for-each select="/*:dc/*:subject">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
             </xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   
   <!-- description -->
   <xsl:template name="get-description">
      <xsl:choose>
         <xsl:when test="/*:dc/*:description">
            <description xtf:meta="true">
               <xsl:value-of select="/*:dc/*:description"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
    
    
   <!-- date -->
   <xsl:template name="get-date">
      <xsl:choose>
         <xsl:when test="/*:dc/*:date">
             <xsl:for-each select="/*:dc/*:date">
               <date xtf:meta="true">
                  <xsl:value-of select="."/>
               </date>
             </xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template> 
    
   
   <!-- type -->
   <xsl:template name="get-type">
      <xsl:if test="/*:dc/*:type">
          <type xtf:meta="true">
             <xsl:value-of select="/*:dc/*:type"/>
          </type>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- format -->
   <xsl:template name="get-format">
      <xsl:if test="/*:dc/*:format">
          <format xtf:meta="true">
             <xsl:value-of select="/*:dc/*:format"/>
          </format>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- identifier -->
   <xsl:template name="get-identifier">
      <xsl:if test="/*:dc/*:identifier">
          <identifier xtf:meta="true">
             <xsl:value-of select="/*:dc/*:identifier"/>
          </identifier>       
        </xsl:if>
   </xsl:template>
   
     
    
   <!-- provenance -->
   <xsl:template name="get-provenance">
      <xsl:if test="/*:dc/*:provenance">
          <provenance xtf:meta="true">
             <xsl:value-of select="/*:dc/*:provenance"/>
          </provenance>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- source -->
   <xsl:template name="get-source">
      <xsl:choose>
         <xsl:when test="/*:dc/*:source">
             <xsl:for-each select="/*:dc/*:source">
               <source xtf:meta="true" xtf:tokenize="no" xtf:facet="yes">
                  <xsl:value-of select="."/>
               </source>
             </xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template> 
   
    
   
   <!-- relation -->
   <xsl:template name="get-relation">
      <xsl:if test="/*:dc/*:relation">
          <relation xtf:meta="true">
             <xsl:value-of select="/*:dc/*:relation"/>
          </relation>       
      </xsl:if>
   </xsl:template>
   
   <!-- coverage -->
   <xsl:template name="get-coverage">
      <xsl:if test="/*:dc/*:coverage">
         <coverage xtf:meta="true" xtf:tokenize="no" xtf:facet="yes">
            <xsl:value-of select="/*:dc/*:coverage"/>
         </coverage>       
      </xsl:if>
   </xsl:template>

   <!-- administration -->
   <xsl:template name="get-administration-facet">
      <facet-administration xtf:meta="true" xtf:tokenize="no" xtf:indexOnly="yes">
      2012
	  </facet-administration>
   </xsl:template> 

   <!-- get facets -->
   
   <!-- govt. branch facet (coverage) -->
   <xsl:template name="get-branch-facet">
      <xsl:choose>
         <xsl:when test="/*:dc/*:coverage">
            <facet-coverage xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no">
               <xsl:value-of select="/*:dc/*:coverage"/>
            </facet-coverage>
         </xsl:when>
      </xsl:choose>
      </xsl:template> 
   
   
   
    <!-- domain facet (source) -->
   <xsl:template name="get-domain-facet">
      <xsl:choose>
         <xsl:when test="/*:dc/*:source">
           <xsl:for-each select="/*:dc/*:source">
         	    <facet-source xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no">
                  <xsl:value-of select="."/>
               </facet-source>
             </xsl:for-each>
		       </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   
   <!-- subject facet (subject) -->
   <xsl:template name="get-subject-facet">
      <xsl:choose>
         <xsl:when test="/*:dc/*:subject">
           <xsl:for-each select="/*:dc/*:subject">
         	    <facet-subject xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no">
                  <xsl:value-of select="."/>
               </facet-subject>
             </xsl:for-each>
		       </xsl:when>
      </xsl:choose>
   </xsl:template>
  
   </xsl:stylesheet>
