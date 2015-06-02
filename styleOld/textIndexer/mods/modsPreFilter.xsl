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
      <!-- Access Dublin Core Record (if present) -->
      <xsl:variable name="dcMeta">
         <xsl:call-template name="get-dc-meta"/>
      </xsl:variable>
      
      <!-- If no Dublin Core present, then extract meta-data from the EAD -->
      <xsl:variable name="meta">
         <xsl:choose>
            <xsl:when test="$dcMeta/*">
               <xsl:copy-of select="$dcMeta"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="get-mods-title"/>
               <xsl:call-template name="get-mods-subject"/>
               <xsl:call-template name="get-mods-description"/>
               <xsl:call-template name="get-mods-date"/>
               <xsl:call-template name="get-mods-type"/>
               <xsl:call-template name="get-mods-format"/>
               <xsl:call-template name="get-mods-identifier"/>
               <xsl:call-template name="get-mods-source"/>
               <xsl:call-template name="get-mods-relation"/>
               <!-- elements not to index -->
               <xsl:call-template name="form"/>
               <xsl:call-template name="digitalOrigin"/>
               <xsl:call-template name="targetAudience"/>
               <xsl:call-template name="typeOfResource"/>
               <xsl:call-template name="relatedItem"/>
               <xsl:call-template name="physicalLocation"/>
               <xsl:call-template name="accessCondition"/>
               <xsl:call-template name="recordCreationDate "/>
               <xsl:call-template name="languageOfCataloging"/>               
              
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
     
     
      
      <!-- Add display and sort fields to the data, and output the result. -->
      <xsl:call-template name="add-fields">
         <xsl:with-param name="display">
            <xsl:value-of select="'raw'"/>
         </xsl:with-param>
         <xsl:with-param name="meta" select="$dcMeta"/>
      </xsl:call-template>   
    </xsl:template>
    
    
   <!-- title --> 
   <xsl:template name="get-mods-title">
      <xsl:choose>
         <xsl:when test="/mods/titleInfo/title">
            <title xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="/mods/titleInfo/title"/>
            </title>
         </xsl:when>
         <xsl:otherwise>
            <title xtf:meta="true">
               <xsl:value-of select="'unknown'"/>
            </title>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   <!-- subject -->
   <xsl:template name="get-mods-subject">
      <xsl:choose>
         <xsl:when test="/mods/subject/topic">
               <subject xtf:meta="true">
                  <xsl:value-of select="/mods/subject/topic"/>
               </subject>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   
   <!-- description -->
   <xsl:template name="get-mods-description">
      <xsl:choose>
         <xsl:when test="/mods/abstract">
            <description xtf:meta="true">
               <xsl:value-of select="/mods/abstract"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
    
    
  <!-- date -->
   <xsl:template name="get-mods-date">
        <xsl:if test="/mods/originInfo/dateCaptured[@point='start']">
          <date xtf:meta="true">
              <xsl:value-of select="/mods/originInfo/dateCaptured"/>
          </date>       
        </xsl:if>
   </xsl:template>
    
   
   <!-- type -->
   <xsl:template name="get-mods-type">
        <xsl:if test="/mods/genre">
          <type xtf:meta="true">
              <xsl:value-of select="/mods/genre"/>
          </type>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- format -->
   <xsl:template name="get-mods-format">
        <xsl:if test="/mods/physicalDescription/internetMediaType">
          <format xtf:meta="true">
              <xsl:value-of select="/mods/physicalDescription/internetMediaType"/>
          </format>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- identifier -->
   <xsl:template name="get-mods-identifier">
        <xsl:if test="/mods/location/url[@displayLabel='Archived  site']">
          <identifier xtf:meta="true" xtf:tokenize="no">
              <xsl:value-of select="/mods/location[2]"/>
          </identifier>       
        </xsl:if>
   </xsl:template>
   
    
   <!-- source -->
   <xsl:template name="get-mods-source">
        <xsl:if test="/mods/note[@type='system details']">
          <source xtf:meta="true">
              <xsl:value-of select="/mods/note"/>
          </source>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- relation -->
   <xsl:template name="get-mods-relation">
        <xsl:if test="/mods/location/url[@usage='primary  display']">
          <relation xtf:meta="true">
              <xsl:value-of select="/mods/location"/>
          </relation>       
        </xsl:if>
   </xsl:template>
   

    <!-- ignore form -->  
    <xsl:template name="form">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>  

   
    <!-- ignore digitalOrigin -->  
    <xsl:template name="digitalOrigin">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>  


    <!-- ignore targetAudience -->  
    <xsl:template name="targetAudience">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>  


    <!-- ignore typeOfResource -->  
    <xsl:template name="typeOfResource">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>   
   
   
    <!-- ignore relatedItem -->  
    <xsl:template name="relatedItem">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>   
   
   
    <!-- ignore physicalLocation -->  
    <xsl:template name="physicalLocation">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>


    <!-- ignore accessCondition -->  
    <xsl:template name="accessCondition">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>
        
    
    <!-- ignore recordCreationDate -->  
    <xsl:template name="recordCreationDate">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>
       
    
    <!-- ignore languageOfCataloging -->  
    <xsl:template name="languageOfCataloging">
      <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:attribute name="xtf:noindex" select="'true'"/>
          <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>
   
</xsl:stylesheet>
