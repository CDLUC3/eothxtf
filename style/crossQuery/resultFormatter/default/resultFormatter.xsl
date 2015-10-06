<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Query result formatter stylesheet                                      -->
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
   
   <!-- this stylesheet implements very simple search forms and query results. 
      Alpha and facet browsing are also included. Formatting has been kept to a 
      minimum to make the stylesheets easily adaptable. -->
   
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   <xsl:import href="../common/resultFormatterCommon.xsl"/>
   <xsl:include href="searchForms.xsl"/> 

   
   <!-- ====================================================================== -->
   <!-- Output                                                                 -->
   <!-- ====================================================================== -->
   
   <xsl:output method="xhtml" indent="yes" 
      encoding="UTF-8" media-type="text/html; charset=UTF-8" 
      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
      omit-xml-declaration="yes"
      exclude-result-prefixes="#all"/>
   
   <!-- ====================================================================== -->
   <!-- Local Parameters                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:param name="css.path" select="concat($xtfURL, 'css/default/')"/>
   <xsl:param name="icon.path" select="concat($xtfURL, 'icons/default/')"/>
   <xsl:param name="eoth08Thumb.path" select="concat($xtfURL, 'media/eoth08/screens_thumb/')"/>
   <xsl:param name="eoth12Thumb.path" select="concat($xtfURL, 'media/eoth12/screens_thumb/')"/>
   <xsl:param name="docHits" select="/crossQueryResult/docHit"/>
   <xsl:param name="email"/>
   
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="/" exclude-result-prefixes="#all">
      <xsl:choose>
         <!-- robot response -->
         <xsl:when test="matches($http.user-agent,$robots)">
            <xsl:apply-templates select="crossQueryResult" mode="robot"/>
         </xsl:when>
         <xsl:when test="$smode = 'showBag'">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- book bag -->
         <xsl:when test="$smode = 'addToBag'">
            <span>Added</span>
         </xsl:when>
         <xsl:when test="$smode = 'removeFromBag'">
            <!-- no output needed -->
         </xsl:when>
         <xsl:when test="$smode='getAddress'">
            <xsl:call-template name="getAddress"/>
         </xsl:when>
         <xsl:when test="$smode='emailFolder'">
            <xsl:apply-templates select="crossQueryResult" mode="emailFolder"/>
         </xsl:when>
         <!-- similar item -->
         <xsl:when test="$smode = 'moreLike'">
            <xsl:apply-templates select="crossQueryResult" mode="moreLike"/>
         </xsl:when>
         <!-- modify search -->
         <xsl:when test="contains($smode, '-modify')">
            <xsl:apply-templates select="crossQueryResult" mode="form"/>
         </xsl:when>
         <!-- browse pages -->
         <xsl:when test="$browse-title or $browse-creator or $browse-source">
            <xsl:apply-templates select="crossQueryResult" mode="browse"/>
         </xsl:when>
         <!-- show results -->
         <xsl:when test="crossQueryResult/query/*/*">
            <xsl:apply-templates select="crossQueryResult" mode="results"/>
         </xsl:when>
         <!-- show form -->
         <xsl:otherwise>
            <xsl:apply-templates select="crossQueryResult" mode="form"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Results Template                                                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="results" exclude-result-prefixes="#all">
      
      <!-- modify query URL -->
      <xsl:variable name="modify" select="if(matches($smode,'simple')) then 'simple-modify' else 'advanced-modify'"/>
      <xsl:variable name="modifyString" select="editURL:set($queryString, 'smode', $modify)"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>End of Term Archive: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/>
			<script type="text/javascript" src="script/jquery-1.6.1.min.js"></script>
   
         <script type="text/javascript">

           $(document).ready(function(){    
              $("img").each(function(index) {   
              $(this).error(function() {   
              $(this).hide();//You can simply Hide it using this.   
           });   
           $(this).attr("src", $(this).attr("src"));   
         });       
        });  
        </script> 
         </head>
         <body>
            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- top navigation -->           
            <div class="forms">
                     <table>
                     <tr>
                        <td class="tab"><a href="index.html">Home</a></td>
                        <td class="tab"><a href="search?smode=advanced">Search Full Text</a></td>
                        <td class="tab-select"><a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Site List</a></td>
                        <!-- <td class="tab"><a href="search?smode=freeform">Explore Data</a></td> -->
                     </tr>
                     </table>
            
            </div>
            <br class="clear" />
            
            <!-- result header -->
            <div class="resultsHeader">
               <table>

                  <xsl:if test="//spelling">
                     <tr>
                        <td>
                           <xsl:call-template name="did-you-mean">
                              <xsl:with-param name="baseURL" select="concat($xtfURL, $crossqueryPath, '?', $queryString)"/>
                              <xsl:with-param name="spelling" select="//spelling"/>
                           </xsl:call-template>
                        </td>
                        <td class="right">&#160;</td>
                     </tr>
                  </xsl:if>
                  
                  
                  <tr>
                     <td width="33%">
                        <b><xsl:value-of select="if($smode='showBag') then 'Bookbag' else 'Results'"/>:</b>&#160;
                        <xsl:variable name="items" select="@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items = 1">
                              <span id="itemCount">1</span>
                              <xsl:text> Item</xsl:text>
                           </xsl:when>
                           <xsl:otherwise>
                              <span id="itemCount">
                                 <xsl:value-of select="$items"/>
                              </span>
                              <xsl:text> Items</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     
                     <td rowspan="3" align="center" width="34%"><h2>Site List</h2></td>
                        
                     <td class="right">
                       <!-- turn off other browse options for now
                        <xsl:text>Browse by </xsl:text>
                        <xsl:call-template name="browseLinks"/>  -->
                     </td>
                  </tr>
                  <xsl:if test="docHit">
                     <tr>
                        <td>
                           <form method="get" action="{$xtfURL}{$crossqueryPath}">
                              <b>Sorted by:&#160;</b>
                              <xsl:call-template name="sort.options"/>
                              <xsl:call-template name="hidden.query">
                                 <xsl:with-param name="queryString" select="editURL:remove($queryString, 'sort')"/>
                              </xsl:call-template>
                              <xsl:text>&#160;</xsl:text>
                              <input type="submit" value="Go"/>
                           </form>
                        </td>
                        
                        <td class="right">
                           <xsl:call-template name="pages"/>
                        </td>
                     </tr>
                  </xsl:if>
               </table>
            </div>
            
            <!-- results -->
            <xsl:choose>
               <xsl:when test="docHit">
                  <div class="results">
                     <table>
                        <tr>
                           <td class="facet">
                            <!-- I am adding a site name lookup box just above the facets -->
                            <br/>
                            <div class="facetName">Site Lookup:</div>
                            <form method="get" action="{$xtfURL}{$crossqueryPath}">
                                  <input type="text" name="keyword" size="25" value="{$keyword}"/><br/>
								  <input type="submit" value="Go"/>
								  <xsl:text>&#160;&#160;&#160;</xsl:text>
                                  <input type="reset" onclick="location.href='{$xtfURL}search?browse-all=yes'" value="Clear"/><br/>
                                  <span class="helpText">Look up a site by keywords in the title, description or URL.</span><br/>
								  
                             </form>
                             
                             <br/>
								 <xsl:apply-templates select="facet[@field='facet-administration']"/>
								 <xsl:apply-templates select="facet[@field='facet-coverage']"/>
                                 <xsl:apply-templates select="facet[@field='facet-source']"/>

                              </td>
  
                           <td class="docHit">
                          
                               <xsl:apply-templates select="docHit"/>
                           </td>
                        </tr>
                        <xsl:if test="@totalDocs > $docsPerPage">
                           <tr>
                              <td colspan="2" class="center">
                                 <xsl:call-template name="pages"/>
                              </td>
                           </tr>
                        </xsl:if>
                     </table>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <div class="results">
                     <table>
                        <tr>
                           <td>
                              <!--<xsl:choose>
                                 <xsl:when test="$smode = 'showBag'">
                                    <p>Your Bookbag is empty.</p>
                                    <p>Click on the 'Add' link next to one or more items in your <a href="{session:getData('queryURL')}">Search Results</a>.</p>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <p>Sorry, no results...</p>
                                    <p>Try modifying your search:</p>
                                    <div class="forms">
                                       <xsl:choose>
                                          <xsl:when test="matches($smode,'advanced')">
                                             <xsl:call-template name="advancedForm"/>
                                          </xsl:when>
                                          <xsl:otherwise>
                                             <xsl:call-template name="simpleForm"/>
                                          </xsl:otherwise>
                                       </xsl:choose>
                                    </div></xsl:otherwise>
                              </xsl:choose> -->
                           </td>
                        </tr>
                     </table>
                  </div>
               </xsl:otherwise>
            </xsl:choose>
            
            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Bookbag Templates                                                      -->
   <!-- ====================================================================== -->
   
   <xsl:template name="getAddress" exclude-result-prefixes="#all">
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Bookbag: Get Address</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body>
            <xsl:copy-of select="$brand.header"/>
            <div class="getAddress">
               <h2>E-mail My Bookbag</h2>
               <form action="{$xtfURL}{$crossqueryPath}" method="get">
                  <xsl:text>Address: </xsl:text>
                  <input type="text" name="email"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="reset" value="CLEAR"/>
                  <xsl:text>&#160;</xsl:text>
                  <input type="submit" value="SUBMIT"/>
                  <input type="hidden" name="smode" value="emailFolder"/>
               </form>
            </div>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template match="crossQueryResult" mode="emailFolder" exclude-result-prefixes="#all">
      
      <xsl:variable name="bookbagContents" select="session:getData('bag')/bag"/>
      
      <!-- Change the values for @smtpHost and @from to those valid for your domain -->
      <mail:send xmlns:mail="java:/org.cdlib.xtf.saxonExt.Mail" 
         xsl:extension-element-prefixes="mail" 
         smtpHost="smtp.yourserver.org" 
         useSSL="no" 
         from="admin@yourserver.org"
         to="{$email}" 
         subject="XTF: My Bookbag">
Your XTF Bookbag:
<xsl:apply-templates select="$bookbagContents/savedDoc" mode="emailFolder"/>
      </mail:send>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>E-mail My Citations: Success</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
         </head>
         <body onload="autoCloseTimer = setTimeout('window.close()', 1000)">
            <xsl:copy-of select="$brand.header"/>
            <h1>E-mail My Citations</h1>
            <b>Your citations have been sent.</b>
         </body>
      </html>
      
   </xsl:template>
   
   <xsl:template match="savedDoc" mode="emailFolder" exclude-result-prefixes="#all">
      <xsl:variable name="num" select="position()"/>
      <xsl:variable name="id" select="@id"/>
      <xsl:for-each select="$docHits[string(meta/identifier[1]) = $id][1]">
         <xsl:variable name="path" select="@path"/>
         <xsl:variable name="url">
            <xsl:value-of select="$xtfURL"/>
            <xsl:choose>
               <xsl:when test="matches(meta/display, 'dynaxml')">
                  <xsl:call-template name="dynaxml.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="rawDisplay.url">
                     <xsl:with-param name="path" select="$path"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
Item number <xsl:value-of select="$num"/>: 
<xsl:value-of select="meta/creator"/>. <xsl:value-of select="meta/title"/>. <xsl:value-of select="meta/year"/>. 
[<xsl:value-of select="$url"/>]
         
      </xsl:for-each>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Browse Template                                                        -->
   <!-- ====================================================================== -->
   
   <xsl:template match="crossQueryResult" mode="browse" exclude-result-prefixes="#all">
      
      <xsl:variable name="alphaList" select="'A B C D E F G H I J K L M N O P Q R S T U V W Y Z OTHER'"/>
      
      <html xml:lang="en" lang="en">
         <head>
            <title>End of Term Archive: Search Results</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <xsl:copy-of select="$brand.links"/>
            <!-- AJAX support -->
            <script src="script/yui/yahoo-dom-event.js" type="text/javascript"/> 
            <script src="script/yui/connection-min.js" type="text/javascript"/> 
         </head>
         <body>
            
            <!-- header -->
            <xsl:copy-of select="$brand.header"/>
            
            <!-- top navigation -->           
            <div class="forms">
                     <table>
                     <tr>
                        <td class="tab"><a href="index.html">Home</a></td>
                        <td class="tab"><a href="search?smode=advanced">Search Full Text</a></td>
                        <td class="tab-select"><a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Site List</a></td>
                        <!-- <td class="tab"><a href="search?smode=freeform">Explore Data</a></td> -->
                     </tr>
                     </table>
            
            </div>
            <br class="clear" />
            
            <!-- result header -->
            <div class="resultsHeader">
               <table>
                  <tr>
                     <td colspan="2" class="right">
                     </td>
                  </tr>
                  <tr>
                     <td>
                     <b>Browse by:&#160;</b>
                        <xsl:choose>
                           <xsl:when test="$browse-title">Title</xsl:when>
                           <xsl:otherwise>All Items</xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="right">
                        <a href="{$xtfURL}{$crossqueryPath}">
                           <xsl:text>New Search</xsl:text>
                        </a>
                        <xsl:if test="$smode = 'showBag'">
                           <xsl:text>&#160;|&#160;</xsl:text>
                           <a href="{session:getData('queryURL')}">
                              <xsl:text>Return to Search Results</xsl:text>
                           </a>
                        </xsl:if> 
                     </td>
                  </tr>
                  <tr>
                     <td>
                        <b>Results:&#160;</b>
                        <xsl:variable name="items" select="facet/group[docHit]/@totalDocs"/>
                        <xsl:choose>
                           <xsl:when test="$items &gt; 1">
                              <xsl:value-of select="$items"/>
                              <xsl:choose>
                                 <xsl:when test="$browse-title='other'">
                                    <xsl:text> items start with: </xsl:text>
                                    <b><xsl:text>Other</xsl:text></b>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text> items start with: </xsl:text>
                                    <b><xsl:value-of select="upper-case(substring($browse-title, 1, 1))"/></b>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:value-of select="$items"/>
                              <xsl:choose>
                                 <xsl:when test="$browse-title='other'">
                                    <xsl:text> item starts with: </xsl:text>
                                    <b><xsl:text>Other</xsl:text></b>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>item starts with: </xsl:text>
                                    <b><xsl:value-of select="upper-case(substring($browse-title, 1, 1))"/></b>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                     <td class="right">
                       
                       <!-- turn off other browse options for the time being
                        <xsl:text>Browse by </xsl:text>
                        <xsl:call-template name="browseLinks"/>
                      -->
                     </td>
                  </tr>
                  <tr>
                     <td colspan="2" class="center">
                        <xsl:call-template name="alphaList">
                           <xsl:with-param name="alphaList" select="$alphaList"/>
                        </xsl:call-template>
                     </td>
                  </tr>
                  
               </table>
            </div>
            
            <!-- results -->
            <div class="results">
               
             <table>
                  <tr>
                     <td class="facetHelp">
                        <xsl:choose>
                           <xsl:when test="$browse-title">
                              <p><xsl:text>Select a letter above to see website titles starting with that letter.</xsl:text></p>  
                              <p><xsl:text>Website titles are derived from the site itself and are not always provided.  Sites without titles are listed under other.</xsl:text></p>
                           </xsl:when>
                           <xsl:when test="$browse-source">
                              <xsl:text>I am some helpful text for the person browsing by URL.</xsl:text> 
                           </xsl:when>
                        </xsl:choose> 
                     </td>
                     <td>
                  <xsl:choose>
                      <xsl:when test="$browse-title">
                           <xsl:apply-templates select="facet[@field='browse-title']/group/docHit"/>
                       </xsl:when>
                       <xsl:when test="$browse-source">
                           <xsl:apply-templates select="facet[@field='browse-source']/group/docHit"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:apply-templates select="facet[@field='browse-creator']/group/docHit"/>
                        </xsl:otherwise>
                    </xsl:choose> 
                        
                    </td>
                  </tr>
               </table>
            </div>
            
            <!-- footer -->
            <xsl:copy-of select="$brand.footer"/>
            
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="browseLinks">
      <xsl:choose>
         <xsl:when test="$browse-all">
            <xsl:text>Facet | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Title</a> 
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-source=first;sort=title">URL</a>
         </xsl:when>
         
         <xsl:when test="$browse-title">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | Title | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-source=first;sort=title">URL</a>
         </xsl:when>
         
         <xsl:when test="$browse-source">
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Title</a>
            <xsl:text> | URL</xsl:text>
         </xsl:when>
         
         <xsl:otherwise>
            <a href="{$xtfURL}{$crossqueryPath}?browse-all=yes">Facet</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-title=first;sort=title">Title</a>
            <xsl:text> | </xsl:text>
            <a href="{$xtfURL}{$crossqueryPath}?browse-source=first;sort=title">URL</a>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Document Hit Template                                                  -->
   <!-- ====================================================================== -->
   
   <xsl:template match="docHit" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      <xsl:variable name="identifier" select="meta/identifier[1]"/>
      <xsl:variable name="quotedID" select="concat('&quot;', $identifier, '&quot;')"/>
      <xsl:variable name="indexId" select="replace($identifier, '.*/', '')"/>
      
      <!-- scrolling anchor -->
      <xsl:variable name="anchor">
         <xsl:choose>
            <xsl:when test="$sort = 'creator'">
               <xsl:value-of select="substring(string(meta/creator[1]), 1, 1)"/>
            </xsl:when>
            <xsl:when test="$sort = 'title'">
               <xsl:value-of select="substring(string(meta/title[1]), 1, 1)"/>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      
      <div id="main_{@rank}" class="docHit">   
         

      <xsl:variable name="thumbFilename1" select="replace($path, 'xml', 'png')"/>
      <xsl:variable name="thumbLink" select="meta/identifier"/>
	  <xsl:variable name="liveLink" select="meta/provenance"/>
	  <xsl:variable name="thumbFilename2">
		<xsl:choose>
			<xsl:when test="meta/sort-year='2008'">
				<xsl:value-of select="replace($thumbFilename1, 'default:eoth08/', '')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="replace($thumbFilename1, 'default:eoth12/', '')"/>
			</xsl:otherwise>
		</xsl:choose>
	  </xsl:variable>
	  <xsl:variable name="thumbURL">
		<xsl:choose>
			<xsl:when test="meta/sort-year='2008'">
				<xsl:value-of select="concat($eoth08Thumb.path, $thumbFilename2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($eoth12Thumb.path, $thumbFilename2)"/>
			</xsl:otherwise>
		</xsl:choose>
	  </xsl:variable>
	
         <table>
         	<tr valign="top">
         		<td width="140px"><a href="{$thumbLink}" target="new"><img src="{$thumbURL}" class="eoth08Thumb" border="0"/></a>
				</td>
         		
			
  		<td>
			<table>
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <xsl:if test="$sort = 'title'">
                     <a name="{$anchor}"/>
                  </xsl:if>
                  <b>Title:&#160;&#160;</b>
               </td>
               <td class="col3">

                     <xsl:choose>
                        <xsl:when test="string-length(meta/title)>0"> 
                           <a href="{$thumbLink}" target="new"><b><xsl:value-of select="meta/title"/></b></a>                        
                        </xsl:when>
                        <xsl:otherwise><em>none provided</em></xsl:otherwise>
                     </xsl:choose>

                  <xsl:text>&#160;</xsl:text>
                  <xsl:variable name="type" select="meta/type"/>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:variable name="type" select="meta/type"/>
                  <br/>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
                  
				  
		<!-- show the archival URL -->
						              
              <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">

                  <b>Archival URL:&#160;&#160;</b><br/>
               </td>
               <td class="col3">
                     <xsl:choose>
                        <xsl:when test="meta/identifier">
                           <xsl:value-of select="meta/identifier"/>
                        </xsl:when>
                        <xsl:otherwise>none provided</xsl:otherwise>
                     </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
			
			
			
   <!-- try to derive site value for full text search -->
<!--
			<tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">

                  <b>IA Site value:&#160;&#160;</b><br/>
               </td>
               <td class="col3">
                     <xsl:choose>
                        <xsl:when test="meta/provenance">
-->
<!--                         <xsl:variable name="siteUrl" select="meta/provenance"/> -->
<!--                             <xsl:value-of select="meta/provenance"/>
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
-->            

            
   <!-- show the live url -->
   
 		
			<tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">

                  <b>Live URL:&#160;&#160;</b>
               </td>
			   
               <td class="col3">
                     <xsl:choose>
                        <xsl:when test="meta/provenance">
                           <a href="{$liveLink}" target="new"><xsl:value-of select="meta/provenance"/></a>  
                        </xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                     </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
			
            
            <!-- show the date of capture -->
            
            <tr>
               <td class="col1">
                  <xsl:text>&#160;</xsl:text>
               </td>
               <td class="col2">
                  <b>Coverage:&#160;&#160;</b>
               </td>
               <td class="col3">
			     <xsl:choose>
					<xsl:when test="meta/date">
						<xsl:choose>
							<xsl:when test="meta/sort-year='2008'">
								<xsl:value-of select="format-date(meta/date[1], '[MNn] [D], [Y]')"/>
								-
								<xsl:value-of select="format-date(meta/date[2], '[MNn] [D], [Y]')"/>
							</xsl:when>
							<xsl:when test="meta/sort-year='2012'">
								<xsl:call-template name="DateFormat2012">
									<xsl:with-param name="coverage-date" select="meta/date[1]"/>
								</xsl:call-template>
								<xsl:text> - </xsl:text>
								<xsl:call-template name="DateFormat2012">
									<xsl:with-param name="coverage-date" select="meta/date[2]"/>
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates select="meta/date"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </td>
               <td class="col4">
                  <xsl:text>&#160;</xsl:text>
               </td>
            </tr>
			
			<!-- show the subjects is commented out.  The vast majority of subjects only appear once -->  
			
                       	      
     <!--        <xsl:if test="meta/subject">
               <tr>
                  <td class="col1">
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <b>Subjects:&#160;&#160;</b>
                  </td>
                  <td class="col3">
                     <xsl:apply-templates select="meta/subject"/>
                  </td>
                  <td class="col4">
                     <xsl:text>&#160;</xsl:text>
                  </td>
               </tr>
            </xsl:if> -->
			
            
            <!-- show the abstract if there is one -->        
			<xsl:if test="string-length(meta/description)>0">
				<xsl:if test="meta/description!='...'">
					<tr>
						<td class="col1">
							<xsl:text>&#160;</xsl:text>
						</td>
						<td class="col2">
							<b>Description:&#160;&#160;</b>
						</td>
						<td class="col3">
							<xsl:apply-templates select="meta/description"/>
						</td>
						<td class="col4">
							<xsl:text>&#160;</xsl:text>
						</td>
					</tr>
				</xsl:if>
            </xsl:if>
            
                  
            <!-- show where hits on search terms appeared -->
            
            <xsl:if test="snippet">
               <tr>
                  <td class="col1">
                     <br/>
                     <xsl:text>&#160;</xsl:text>
                  </td>
                  <td class="col2">
                     <br/>
                     <b>Matches:&#160;&#160;</b>
                     <br/>
                     <xsl:value-of select="@totalHits"/> 
                     <xsl:value-of select="if (@totalHits = 1) then ' hit' else ' hits'"/>&#160;&#160;&#160;&#160;
                  </td>
                  <td class="col3" colspan="2">
                     <br/>
                     <xsl:apply-templates select="snippet" mode="text"/>
                  </td>
               </tr>
            </xsl:if>
            
            
         </table>
		 </td>
		 </tr>
		 </table>
	
     </div>
</xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Snippet Template (for snippets in the full text)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="snippet" mode="text" exclude-result-prefixes="#all">
      <xsl:text>...</xsl:text>
      <xsl:apply-templates mode="text"/>
      <xsl:text>...</xsl:text>
      <br/>
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in the full text)                          -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" mode="text" exclude-result-prefixes="#all">
      <xsl:variable name="path" select="ancestor::docHit/@path"/>
      <xsl:variable name="display" select="ancestor::docHit/meta/display"/>
      <xsl:variable name="hit.rank"><xsl:value-of select="ancestor::snippet/@rank"/></xsl:variable>
      <xsl:variable name="snippet.link">    
         <xsl:call-template name="dynaxml.url">
            <xsl:with-param name="path" select="$path"/>
         </xsl:call-template>
         <xsl:value-of select="concat(';hit.rank=', $hit.rank)"/>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:when test="not(ancestor::snippet) or not(matches($display, 'dynaxml'))">
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:when>
         <xsl:otherwise>
            <a href="{$snippet.link}" class="hit"><xsl:apply-templates/></a>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- Term Template (for snippets in meta-data fields)                       -->
   <!-- ====================================================================== -->
   
   <xsl:template match="term" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="ancestor::query"/>
         <xsl:otherwise>
            <span class="hit"><xsl:apply-templates/></span>
         </xsl:otherwise>
      </xsl:choose> 
      
   </xsl:template>
   
   <!-- ====================================================================== -->
   <!-- More Like This Template                                                -->
   <!-- ====================================================================== -->
   
   <!-- results -->
   <xsl:template match="crossQueryResult" mode="moreLike" exclude-result-prefixes="#all">
      <xsl:choose>
         <xsl:when test="docHit">
            <div class="moreLike">
               <ol>
                  <xsl:apply-templates select="docHit" mode="moreLike"/>
               </ol>
            </div>
         </xsl:when>
         <xsl:otherwise>
            <div class="moreLike">
               <b>No similar documents found.</b>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   
   
   <!-- docHit -->
   <xsl:template match="docHit" mode="moreLike" exclude-result-prefixes="#all">
      
      <xsl:variable name="path" select="@path"/>
      
      <li>
         <xsl:apply-templates select="meta/creator[1]"/>
         <xsl:text>. </xsl:text>
         <a>
            <xsl:attribute name="href">
               <xsl:choose>
                  <xsl:when test="matches(meta/display, 'dynaxml')">
                     <xsl:call-template name="dynaxml.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:call-template name="rawDisplay.url">
                        <xsl:with-param name="path" select="$path"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="meta/title[1]"/>
         </a>
         <xsl:text>. </xsl:text>
         <xsl:apply-templates select="meta/date[1]"/>
         <xsl:text>. </xsl:text>
      </li>
      
   </xsl:template>
   <xsl:template name="DateFormat2012">
		<xsl:param name="coverage-date"/>
		<xsl:choose>
			<xsl:when test="substring($coverage-date,5,2)='01'">
				<xsl:text>January</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='02'">
				<xsl:text>February</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='03'">
				<xsl:text>March</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='04'">
				<xsl:text>April</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='05'">
				<xsl:text>May</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='06'">
				<xsl:text>June</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='07'">
				<xsl:text>July</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='08'">
				<xsl:text>August</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='09'">
				<xsl:text>September</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='10'">
				<xsl:text>October</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='11'">
				<xsl:text>November</xsl:text>
			</xsl:when>
			<xsl:when test="substring($coverage-date,5,2)='12'">
				<xsl:text>December</xsl:text>
			</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($coverage-date,7,2)"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="substring($coverage-date,1,4)"/>
   </xsl:template>
   
</xsl:stylesheet>
