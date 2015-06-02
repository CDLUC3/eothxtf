<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0">
   
   
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Search forms stylesheet                                                -->
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   
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
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   
 	<xsl:import href="../common/home.xsl"/>
   <xsl:import href="../common/iasearch.xsl"/>
   <xsl:import href="../common/opensearch_to_html.xsl"/>
   <xsl:import href="../common/imageBrowse.xsl"/>



   <!-- ====================================================================== -->
   <!-- Global parameters                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:param name="freeformQuery"/>
   
   <!-- ====================================================================== -->
   <!-- Form Templates                                                         -->
   <!-- ====================================================================== -->
   
   <!-- main form page -->
   <xsl:template match="crossQueryResult" mode="form" exclude-result-prefixes="#all">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
         <head>
            <title>End of Term Web Archive</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="searchPage">
               <div class="forms">
                 
                 <!-- nav starts here -->
                      <xsl:call-template name="topNavigation"/>
                  <!-- nav ends here -->
                  
               </div>
            </div>
            <xsl:copy-of select="$brand.footer"/>
         </body>
      </html>
   </xsl:template>
   

   
   <!-- ====================================================================== -->
   <!-- Stylesheet change   | Simple form                                      -->
   <!-- ====================================================================== -->
   
<!-- The original searchForms.xsl puts a template for the simple search (keyword) tab here.
That has been replaced with the EOTH home page.
Because the content of the home page is markedly different from other pages, I have placed it in
its own file: resultFormatter/common/home.xsl.  
This way, you do not risk breaking something totally unrelated if you have to edit text on the 
home page.  -->



   
   <!-- ====================================================================== -->
   <!-- Stylesheet change   | Advanced form                                      -->
   <!-- ====================================================================== -->
   
<!-- What used to appear here as the advanced form template is now the full text search page.
This is a separate file, stored in resultFormatter/common/iasearch.xsl.
This file provides full text search and integrates search results via the internet archive opensearch api
 -->


   <!-- ====================================================================== -->
   <!-- Stylesheet change   | free-form form                                      -->
   <!-- ====================================================================== -->
   
<!-- What used to appear here as the freeform search template is now the 'image browse' page. This is a separate file, stored in resultFormatter/common/imageBrowse.xsl.
 -->
 
   <!-- ====================================================================== -->
   <!-- Moved top nav bar to a template so I can call it from the browse page.                                      -->
   <!-- ====================================================================== -->
   

                  <xsl:template name="topNavigation" exclude-result-prefixes="#all">
                  <table>
                     <tr>
                        <td class="{if(matches($smode,'simple')) then 'tab-select' else 'tab'}"><a href="index.html">Home</a></td>
                        <td class="{if(matches($smode,'advanced')) then 'tab-select' else 'tab'}"><a href="search?smode=advanced">Search Full Text</a></td>
                        <td class="{if(matches($smode,'browse')) then 'tab-select' else 'tab'}"><a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Site List</a></td>
                        <td class="{if(matches($smode,'freeform')) then 'tab-select' else 'tab'}"><a href="search?smode=freeform">Explore Data</a></td>
                     </tr>
                     <tr>
                        <td colspan="4">
                           <div class="form">
                              <xsl:choose>
                                 <xsl:when test="matches($smode,'simple')">
                                   <xsl:call-template name="simpleForm"/> 
                                  </xsl:when>
                                 <xsl:when test="matches($smode,'advanced')">
                                    <xsl:call-template name="advancedForm"/>
                                 </xsl:when>
                                 <xsl:when test="matches($smode,'freeform')">
                                    <xsl:call-template name="freeformForm"/>
                                 </xsl:when>
                              </xsl:choose>
                           </div>
                        </td>
                     </tr>
                  </table>
                  </xsl:template>


   
</xsl:stylesheet>
