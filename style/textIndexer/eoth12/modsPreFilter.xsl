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
      
      <!-- If no Dublin Core present, then extract meta-data from the MODS -->
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
               <xsl:call-template name="get-mods-date2"/>
               <xsl:call-template name="get-mods-type"/>
               <xsl:call-template name="get-mods-format"/>
               <xsl:call-template name="get-mods-identifier"/>
               <xsl:call-template name="get-mods-provenance"/>
               <xsl:call-template name="get-mods-source"/>
               <xsl:call-template name="get-mods-relation"/>
               <xsl:call-template name="get-mods-coverage"/>   
               <xsl:call-template name="get-mods-branch-facet"/>  
               <xsl:call-template name="get-mods-domain-facet"/>  

                          
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
     
 <xsl:message>metadata is: 
    <xsl:copy-of select="$meta">
    
    </xsl:copy-of>
 </xsl:message>  
      
      
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
   <xsl:template name="get-mods-title">
      <xsl:choose>
         <xsl:when test="/*:mods/*:titleInfo/*:title">
            <title xtf:meta="true" xtf:tokenize="no">
               <xsl:value-of select="/*:mods/*:titleInfo/*:title"/>
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
         <xsl:when test="/*:mods/*:subject/*:topic">
            <xsl:variable name="subjectString" select="tokenize(/*:mods/*:subject/*:topic, ',\s*')"/>
               <xsl:for-each select="$subjectString">
               <subject xtf:meta="true">
                  <xsl:value-of select="."/>
               </subject>
               </xsl:for-each>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   
   <!-- description -->
   <xsl:template name="get-mods-description">
      <xsl:choose>
         <xsl:when test="/*:mods/*:abstract">
            <description xtf:meta="true">
               <xsl:value-of select="/*:mods/*:abstract"/>
            </description>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
    
    
  <!-- date -->
   <xsl:template name="get-mods-date">
      <xsl:if test="/*:mods/*:originInfo/*:dateCaptured[@point='start']">
          <date xtf:meta="true">
             <xsl:value-of select="/*:mods/*:originInfo/*:dateCaptured[1]"/>
          </date>       
        </xsl:if>
   </xsl:template>
   
   <xsl:template name="get-mods-date2">
      <xsl:if test="/*:mods/*:originInfo/*:dateCaptured[@point='end']">
         <date xtf:meta="true">
            <xsl:value-of select="/*:mods/*:originInfo/*:dateCaptured[2]"/>
         </date>       
      </xsl:if>
   </xsl:template>
   
    
   
   <!-- type -->
   <xsl:template name="get-mods-type">
      <xsl:if test="/*:mods/*:genre">
          <type xtf:meta="true">
             <xsl:value-of select="/*:mods/*:genre"/>
          </type>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- format -->
   <xsl:template name="get-mods-format">
      <xsl:if test="/*:mods/*:physicalDescription/*:internetMediaType">
          <format xtf:meta="true">
             <xsl:value-of select="/*:mods/*:physicalDescription/*:internetMediaType"/>
          </format>       
        </xsl:if>
   </xsl:template>
   
   
   <!-- identifier -->
   <xsl:template name="get-mods-identifier">
      <xsl:if test="/*:mods/*:location/*:url[@displayLabel='Archived  site']">
          <identifier xtf:meta="true" xtf:tokenize="no">
             <xsl:value-of select="/*:mods/*:location[2]"/>
          </identifier>       
      </xsl:if>
      <xsl:if test="/*:mods/*:location/*:url[@displayLabel='Archived site']">
         <identifier xtf:meta="true" xtf:tokenize="no">
            <xsl:value-of select="/*:mods/*:location[2]"/>
         </identifier>       
      </xsl:if>
   </xsl:template>
   
    
   <!-- provenance -->
   <xsl:template name="get-mods-provenance">
      <xsl:if test="/*:mods/*:note[@type='system details']">
          <provenance xtf:meta="true">
             <xsl:value-of select="/*:mods/*:note[1]"/>
          </provenance>       
        </xsl:if>
   </xsl:template>
   
   

    <xsl:template name="get-mods-source">
          <xsl:variable name="startURL">
             <xsl:choose>
                <xsl:when test="/*:mods/*:note[@type='system  details']">
                   <xsl:value-of  select="/*:mods/*:note[@type='system  details']"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of  select="/*:mods/*:note[@type='system details']"/>
                </xsl:otherwise>
             </xsl:choose>
          </xsl:variable> 
          
          <!-- remove http:// and https:// from URLs -->
          <xsl:variable name="noHttpURL">
             <xsl:choose>
                <xsl:when test="contains($startURL, 'https://')">
                   <xsl:value-of select="substring-after($startURL, 'https://')"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="substring-after($startURL, 'http://')"/>
                </xsl:otherwise>
             </xsl:choose>
          </xsl:variable> 
          
          
          <!-- ignore any directory or file names -->
          <xsl:variable name="hostURL">
             <xsl:choose>
                <xsl:when test="contains($noHttpURL, '/')">
                   <xsl:value-of select="substring-before($noHttpURL, '/')"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="$noHttpURL"/>
                </xsl:otherwise>
             </xsl:choose>
          </xsl:variable> 
          
          
          <!-- remove www., .gov, .com, .mil, .org -->   
          <xsl:variable name="noWwwURL">
             <xsl:choose>
                <xsl:when test="contains($hostURL, 'www&#46;')">
                   <xsl:value-of select="substring-after($hostURL, 'www&#46;')"/>   
                </xsl:when>     
                <xsl:otherwise>
                   <xsl:value-of select="$hostURL"/>
                </xsl:otherwise>
             </xsl:choose>
          </xsl:variable> 
          
          <xsl:variable name="sourceString">
             <xsl:choose>
                <xsl:when test="ends-with($noWwwURL, '&#46;gov')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;gov')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;mil')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;mil')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;com')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;com')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;edu')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;edu')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;info')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;info')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;net')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;net')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;us')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;us')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;ws')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;ws')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;int')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;int')"/>
                </xsl:when>
                <xsl:when test="ends-with($noWwwURL, '&#46;org')">
                   <xsl:value-of select="substring-before($noWwwURL, '&#46;org')"/>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="$noWwwURL"/>
                </xsl:otherwise>    
             </xsl:choose>
          </xsl:variable> -->
          
          <!-- tokenize whatever is left -->
         
          <xsl:for-each select="tokenize($sourceString,'\.')">   
             <source xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no" xtf:facet="yes">
                <xsl:value-of select="."/>
             </source>
          </xsl:for-each>   
      </xsl:template>  
   
 
   
   
   <!-- coverage -->
   <xsl:template name="get-mods-coverage">
      <xsl:if test="/*:mods/*:note[@displayLabel='Government branch']">
         <coverage xtf:meta="true">
            <xsl:value-of select="/*:mods/*:note[2]"/>
         </coverage>       
      </xsl:if>
   </xsl:template>
   
   
   <!-- relation -->
   <xsl:template name="get-mods-relation">
      <xsl:if test="/*:mods/*:location/url[@usage='primary display']">
          <relation xtf:meta="true">
             <xsl:value-of select="/*:mods/*:location"/>
          </relation>       
      </xsl:if>
   </xsl:template>
   


   
   <!-- get facets -->
   
   <!-- govt. branch facet -->
   <xsl:template name="get-mods-branch-facet">
      <xsl:choose>
         <xsl:when test="/*:mods/*:note[@displayLabel='Government branch']">
            <facet-coverage xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no" xtf:facet="yes">
               <xsl:value-of select="/*:mods/*:note[2]"/>
            </facet-coverage>
         </xsl:when>
      </xsl:choose>
      </xsl:template> 
   
   
   
   <!-- domain facet -->
   

   
<xsl:template name="get-mods-domain-facet">
 
       <xsl:variable name="startURL">
          <xsl:choose>
             <xsl:when test="/*:mods/*:note[@type='system  details']">
                <xsl:value-of  select="/*:mods/*:note[@type='system  details']"/>
             </xsl:when>
             <xsl:otherwise>
                <xsl:value-of  select="/*:mods/*:note[@type='system details']"/>
             </xsl:otherwise>
          </xsl:choose>
        </xsl:variable> 
         
         <!-- remove http:// and https:// from URLs -->
       <xsl:variable name="noHttpURL">
            <xsl:choose>
               <xsl:when test="contains($startURL, 'https://')">
                  <xsl:value-of select="substring-after($startURL, 'https://')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="substring-after($startURL, 'http://')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable> 
         
         
     <!-- ignore any directory or file names -->
       <xsl:variable name="hostURL">
            <xsl:choose>
               <xsl:when test="contains($noHttpURL, '/')">
                  <xsl:value-of select="substring-before($noHttpURL, '/')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$noHttpURL"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable> 
         
         
         <!-- remove www., .gov, .com, .mil, .org -->   
     <xsl:variable name="noWwwURL">
            <xsl:choose>
               <xsl:when test="contains($hostURL, 'www&#46;')">
                  <xsl:value-of select="substring-after($hostURL, 'www&#46;')"/>   
               </xsl:when>     
               <xsl:otherwise>
                  <xsl:value-of select="$hostURL"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable> 
         
      <xsl:variable name="sourceString">
            <xsl:choose>
               <xsl:when test="ends-with($noWwwURL, '&#46;gov')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;gov')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;mil')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;mil')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;com')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;com')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;edu')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;edu')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;info')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;info')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;net')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;net')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;us')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;us')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;ws')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;ws')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;int')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;int')"/>
               </xsl:when>
               <xsl:when test="ends-with($noWwwURL, '&#46;org')">
                  <xsl:value-of select="substring-before($noWwwURL, '&#46;org')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$noWwwURL"/>
               </xsl:otherwise>    
            </xsl:choose>
         </xsl:variable> -->
         
         <!-- tokenize whatever is left -->
   
     
         <xsl:for-each select="tokenize($sourceString,'\.')">   
            <facet-source xtf:meta="true" xtf:indexOnly="yes" xtf:tokenize="no" xtf:facet="yes">
               <xsl:value-of select="."/>
            </facet-source>
            </xsl:for-each>   
  
   </xsl:template>
   

</xsl:stylesheet>
