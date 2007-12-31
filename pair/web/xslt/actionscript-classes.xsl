<?xml version="1.0" encoding="UTF-8"?> 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="timestamp"/>
	
    <xsl:template match="report">
        <html>
        <head>
        	<title>Actionscript classes</title>
        	<script type="text/javascript"></script>
			
			<style type="text/css" title="currentStyle" media="screen">
				@import "../css/dependencies.css";
			</style>
        </head>
        
            <body>
            	<div id="container">
	            	<h1>Actionscript class dependencies</h1>
	            	<p class="p1"><span>
	            	To find ways to reduce SWF file sizes, you can look at the list of ActionScript classes that are linked into your SWF file. <br/><br/>
	            	More info can be found in the Flex <a href='http://livedocs.adobe.com/flex/2/docs/00001394.html'>documentation</a>.
	            	</span></p>
	            	<br/>
	                <xsl:apply-templates select="external-defs"/>
	                <xsl:apply-templates select="scripts"/>
	                <br/><br/>
	                <p class="p2"><span>Report created on <xsl:value-of select="$timestamp"/></span></p>
	        	</div>
            </body>
        </html>
    </xsl:template>
  
    <xsl:template match="scripts">
    	<h2>Scripts</h2>
    	<xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="external-defs">
    	<h2>External Definitions</h2>
    	<p class="p1"><span>List of dependencies to assets that were not linked in.</span></p>
    	<xsl:apply-templates/>
    </xsl:template>
  
   <xsl:template match="script">
        <p class="p1">
        	<xsl:apply-templates select="def"/>
	        <table id="mytable" cellspacing="0">
			  <tr>
			    <th scope="col" abbr="Tag">Tag</th>
				<th scope="col" abbr="Value">Value</th>
			  </tr>
			  <tr>
			    <th scope="row" abbr="source" class="spec">Source</th>
			    <td><xsl:value-of select="@name"/></td>
			  </tr>
			  <tr>
			    <th scope="row" abbr="size" class="specalt">Size</th>
			    <td class="hi"><xsl:value-of select="@size"/> bytes</td>
			  </tr>
			  <tr>
			    <th scope="row" abbr="optimizedsize" class="spec">Optimized Size</th>
			    <td><xsl:value-of select="@optimizedsize"/> bytes</td>
			  </tr>
			  <tr>
			    <th scope="row" abbr="mod" class="specalt">Creation Date</th>
			    <td class="hi"><xsl:value-of select="@mod"/></td>
			  </tr>
			  <tr>
			    <th scope="row" abbr="prerequisite" class="spec">Prerequisite</th>
			    <td><xsl:apply-templates select="pre"/></td>
			  </tr>
			  <tr>
			    <th scope="row" abbr="mod" class="specalt">Dependencies</th>
			    <td class="hi"><xsl:apply-templates select="dep"/></td>
			  </tr>
	        </table>
        </p>
    </xsl:template>
    
    <xsl:template match="def">
    	<h3><xsl:text disable-output-escaping="yes">&lt;a name='</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">'&gt;</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">&lt;a/&gt;</xsl:text></h3>
    </xsl:template>
    
    <xsl:template match="pre">
    	<li><xsl:text disable-output-escaping="yes">&lt;a href='#</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">'&gt;</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">&lt;a/&gt;</xsl:text></li>
    </xsl:template>
    
    <xsl:template match="dep">
    	<li><xsl:text disable-output-escaping="yes">&lt;a href='#</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">'&gt;</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">&lt;a/&gt;</xsl:text></li>
    </xsl:template>
    
    <xsl:template match="ext">
    	<li><xsl:text disable-output-escaping="yes">&lt;a name='</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">'&gt;</xsl:text><xsl:value-of select="@id"/><xsl:text disable-output-escaping="yes">&lt;a/&gt;</xsl:text></li>
    </xsl:template>
    
</xsl:stylesheet>
