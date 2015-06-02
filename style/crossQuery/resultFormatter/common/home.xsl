
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xtf="http://cdlib.org/xtf" 
   xmlns:editURL="http://cdlib.org/xtf/editURL"
   xmlns="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="#all"
   version="2.0">
   
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- Home page markup                                  -->
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
   <!-- Import Stylesheets                                                     -->
   <!-- ====================================================================== -->
   
   <xsl:import href="format-query.xsl"/>
   <xsl:import href="spelling.xsl"/>
   <!-- ====================================================================== -->
   <!-- Home text                                                              -->
   <!-- ====================================================================== -->
   
  <xsl:template name="simpleForm" exclude-result-prefixes="#all">

<!--<table>
  <tr valign="top">
     <td class="home-nav">
       
    <ul>
        <li>Overview</li>
        <li>Overview</li>
        <li>Overview</li>
        <li>Overview</li>
     </ul>
     </td>
     

  <td class="home-content"> 
    <h2 class="center"> How do government websites change <br/>
    when a new administration takes office? </h2>
    
    <img src="icons/default/eoth_home.gif" alt=""/>

      <p>The End of Term Government Web Archive documents the United States government's presence on the World Wide 
  Web during the transition between the administrations of President George W. Bush and President Barak 
  Obama. </p>
  </td>
  
   <td class="home-stats">
   <h4>Archive Stats</h4>
   3,300 websites<br/>
   2.3 gazillian files<br/>
   16 terabytes<br/>
  </td>
</tr>  
</table> -->


<script type="text/javascript">
window.location = "search?browse-all=yes";
</script>


</xsl:template>
</xsl:stylesheet>

