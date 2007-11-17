<?xml version="1.0" encoding="UTF-8"?> 
<!--
Copyright (c) The Pair Project, 2007

Thijs Triemstra

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:param name="timestamp"/>
   <xsl:param name="flexVersion"/>
   <xsl:param name="airVersion"/>
	
   <xsl:template match="project">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	    <head>
			<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
			
			<title>Configuration Report for <xsl:value-of select="name"/></title>
			
			<script type="text/javascript"></script>
			
			<style type="text/css" title="currentStyle" media="screen">
				@import "../css/project.css";
			</style>
	    </head>

        <body id="config-report">
			<div id="container">
				
				<div id="intro">
					<div id="pageHeader">
						<h1><span><xsl:value-of select="name"/></span></h1>
					</div>

					<div id="general">
						<p class="p1"><span>This report shows an overview of all project configuration settings, including documentation.</span></p>
						<br/>
						<h3><span>Project</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="name" class="spec">name</th>
						    <td><xsl:value-of select="name"/></td>
						    <td class="spec">Name.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="version" class="specalt">version</th>
						    <td class="hi"><xsl:value-of select="version"/></td>
						    <td class="alt">Version.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="url" class="spec">url</th>
						    <td><xsl:value-of select="url"/></td>
						    <td class="spec">Project url.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="description" class="specalt">description</th>
						    <td class="hi"><xsl:value-of select="description"/></td>
						    <td class="alt">Description.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="language" class="spec">language</th>
						    <td><xsl:value-of select="language"/></td>
						    <td class="spec">Language.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="license" class="specalt">license</th>
						    <td class="hi"><xsl:value-of select="license"/></td>
						    <td class="alt">License file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="copyright" class="spec">copyright</th>
						    <td><xsl:value-of select="copyright"/></td>
						    <td class="spec">The copyright information for this application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="buildDir" class="specalt">buildDir</th>
						    <td class="hi"><xsl:value-of select="buildDir"/></td>
						    <td class="alt">Temporary build directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="imageDir" class="spec">imageDir</th>
						    <td><xsl:value-of select="imageDir"/></td>
						    <td class="spec">Image content directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="distDir" class="specalt">distDir</th>
						    <td class="hi"><xsl:value-of select="distDir"/></td>
						    <td class="alt">Distribution directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="reportDir" class="spec">reportDir</th>
						    <td><xsl:value-of select="reportDir"/></td>
						    <td class="spec">Reports directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="configDir" class="specalt">configDir</th>
						    <td class="hi"><xsl:value-of select="configDir"/></td>
						    <td class="alt">Directory with project configuration files.</td>
						  </tr>
						</table>
						
						<h3><span>Organization</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="name" class="spec">name</th>
						    <td><xsl:value-of select="organization/name"/></td>
						    <td class="spec">Name.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="unit" class="specalt">unit</th>
						    <td class="hi"><xsl:value-of select="organization/unit"/></td>
						    <td class="alt">Unit name.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="country" class="spec">country</th>
						    <td><xsl:value-of select="organization/country"/></td>
						    <td class="spec">Country.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="email" class="specalt">email</th>
						    <td class="hi"><xsl:value-of select="organization/email"/></td>
						    <td class="alt">Email address.</td>
						  </tr>
						</table>
						
						<p/>
					</div>
				</div>
				
				<div id="components">
					<div id="flex">
						<p class="p1"><span><a href='http://adobe.com/go/flex'>Adobe Flex</a> is a cross platform, open source framework for creating rich Internet applications that run identically in all major browsers and operating systems using the <a href='http://adobe.com/go/flashplayer'>Flash Player</a>.</span></p>
						
						<h3><span>Project</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="swfName" class="spec">swfName</th>
						    <td><xsl:value-of select="flex/swfName"/></td>
						    <td class="spec">SWF filename.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="source" class="specalt">source</th>
						    <td class="hi"><xsl:value-of select="flex/source"/></td>
						    <td class="alt">Source path directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="mxml" class="spec">mxml</th>
						    <td><xsl:value-of select="flex/mxml"/></td>
						    <td class="spec">Main MXML file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="libraries" class="specalt">libraries</th>
						    <td class="hi"><xsl:value-of select="flex/libraries"/></td>
						    <td class="alt">SWC libraries directory.</td>
						  </tr>
						</table>
						
						<h3><span>Locale</span></h3>
						<p class="p2"><span>Flex locale settings.</span></p>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="path" class="spec">path</th>
						    <td><xsl:value-of select="flex/locale/path"/></td>
						    <td class="spec">Locale root directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="language" class="specalt">language</th>
						    <td class="hi"><xsl:value-of select="flex/locale/language"/></td>
						    <td class="alt">Selected locale language.</td>
						  </tr>
						</table>

						<h3><span>Compiler</span></h3>
						<p class="p3"><span>The <em>amxmlc</em> command-line compiler is used to create AIR compatible SWF files from MXML, AS, and other source files.</span></p>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="version" class="spec">version</th>
						    <td><xsl:value-of select="$flexVersion"/></td>
						    <td class="spec">Flex SDK version number.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="home" class="specalt">home</th>
						    <td class="hi"><xsl:value-of select="flex/compiler/home"/></td>
						    <td class="alt">Location of the Flex SDK root folder.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="libraries" class="spec">libraries</th>
						    <td><xsl:value-of select="flex/compiler/libraries"/></td>
						    <td class="spec">Location of the Flex SDK lib folder.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="config" class="specalt">config</th>
						    <td class="hi"><xsl:value-of select="flex/compiler/config"/></td>
						    <td class="alt">Specifies the location of the configuration file that defines compiler options.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="flexTasks" class="spec">flexTasks</th>
						    <td><xsl:value-of select="flex/compiler/flexTasks"/></td>
						    <td class="spec">Location of the <a href='http://ant.apache.org'>Ant</a> tasks for the Flex SDK.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="benchmark" class="specalt">benchmark</th>
						    <td class="hi"><xsl:value-of select="flex/compiler/benchmark"/></td>
						    <td class="alt">Prints detailed compile times to the standard output.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="useNetwork" class="spec">useNetwork</th>
						    <td><xsl:value-of select="flex/compiler/useNetwork"/></td>
						    <td class="spec">Specifies that the current application uses network services. <br/><br/>When the property is set to false, the application can access the local filesystem (for example, use the XML.load() method with <code>file:</code> URLs) but not network services.</td>
						  </tr>
						</table>
						
						<h3><span>Documentation</span></h3>
						
						<p class="p4"><span><a href='http://livedocs.adobe.com/flex/201/html/asdoc_127_1.html'>ASDoc</a> is a command-line tool used to create API language reference documentation as HTML pages from the classes in Flex applications.</span></p>

						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="outputDir" class="spec">outputDir</th>
						    <td><xsl:value-of select="flex/asdoc/outputDir"/></td>
						    <td class="spec">The output directory for the generated HTML documentation files.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="domainExtensions" class="specalt">domainExtensions</th>
						    <td class="hi"><xsl:value-of select="flex/asdoc/domainExtensions"/></td>
						    <td class="alt">Class-folders you want to search for classes to be included in the documentation, seperated by spaces ( for example <code>../com/ ../net/</code> ).<br/>
						    To include every .as and .mxml file within your project, just use <code>../</code></td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="template" class="spec">template</th>
						    <td><xsl:value-of select="flex/asdoc/template"/></td>
						    <td class="spec">The path to the ASDoc template directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="frameWidth" class="specalt">frameWidth</th>
						    <td class="hi"><xsl:value-of select="flex/asdoc/frameWidth"/></td>
						    <td class="alt">An integer that changes the width of the left frameset of the documentation. You can change this size to accommodate the length of your package names.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="windowTitle" class="spec">windowTitle</th>
						    <td><xsl:value-of select="flex/asdoc/windowTitle"/></td>
						    <td class="spec">The text that appears in the browser window in the output documentation.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="mainTitle" class="specalt">mainTitle</th>
						    <td class="hi"><xsl:value-of select="flex/asdoc/mainTitle"/></td>
						    <td class="alt">The text that appears at the top of the HTML pages in the output documentation.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="footer" class="spec">footer</th>
						    <td><xsl:value-of select="flex/asdoc/footer"/></td>
						    <td class="spec">The text that appears at the bottom of the HTML pages in the output documentation.</td>
						  </tr>
						</table>
						
						<p/>
					</div>
			
					<div id="air">
						<p class="p1"><span>Adobe Integrated Runtime (<a href='http://www.adobe.com/go/air'>AIR</a>) is a cross-operating system runtime being developed by <a href='http://adobe.com'>Adobe</a> that allows developers to leverage their existing web development skills (Flash, Flex, HTML, JavaScript, Ajax) to build and deploy rich Internet applications (RIAs) to the desktop.<br/><br/>
								Currently supports the following operating systems:<br/><br/>
								<li>Windows 2000 SP4, Windows XP SP2, and Windows Vista Home and Ultimate Edition</li>
								<li>Mac OS 10.4.7 and above (Intel and PowerPC)</li>
								<li>Linux support is <a href='http://labs.adobe.com/wiki/index.php/AIR:Developer_FAQ#Does_Adobe_AIR_support_Linux.3F'>expected</a> in Q3 2008</li></span></p>
						
						<h3><span>Project</span></h3>
						<p class="p2"><span>Package settings that determine the identity of the AIR application and its default installation path.</span></p>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="config" class="spec">config</th>
						    <td><xsl:value-of select="air/adt/config"/></td>
						    <td class="spec">The location of the template application descriptor file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="id" class="specalt">id</th>
						    <td class="hi"><xsl:value-of select="air/adt/id"/></td>
						    <td class="alt">A unique application identifier.<br/><br/>
						    				The appId string typically uses a dot-separated hierarchy, in alignment with a reversed DNS domain address, a Java 
											package or class name, or an OS X Universal Type Identifier.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="title" class="spec">title</th>
						    <td><xsl:value-of select="air/adt/title"/></td>
						    <td class="spec">The title displayed in the AIR application installer.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="name" class="specalt">name</th>
						    <td class="hi"><xsl:value-of select="air/adt/name"/></td>
						    <td class="alt">The name of the application.<br/><br/>In Windows, this is displayed in the application's title bar and in the Windows Start menu. On Mac OS X, it is displayed in the menu bar when the application is running. </td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="description" class="spec">description</th>
						    <td><xsl:value-of select="air/adt/description"/></td>
						    <td class="spec">The description displayed in the AIR application installer.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="systemChrome" class="specalt">systemChrome</th>
						    <td class="hi"><xsl:value-of select="air/adt/systemChrome"/></td>
						    <td class="alt">If you set this attribute to <code>standard</code>, system chrome is displayed, and the application has no transparency. If you set it to <code>none</code>, no system chrome is displayed.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="transparent" class="spec">transparent</th>
						    <td><xsl:value-of select="air/adt/transparent"/></td>
						    <td class="spec">Set this to <code>true</code>, and the <code>systemChrome</code> Tag to <code>none</code>, if you want the application window to support alpha blending.<br/><br/>
						    The <code>transparent</code> Tag of a window cannot be changed after the window has been created. A window with transparency may draw more slowly and require more memory than otherwise. </td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="visible" class="specalt">visible</th>
						    <td class="hi"><xsl:value-of select="air/adt/visible"/></td>
						    <td class="alt">Set this to <code>false</code> if you  want to have the main window be hidden when it is first created. The default value is <code>true</code>.<br/><br/>
						    				You may want to have the main window hidden initially, and then set its position and size in your application code.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="installFolder" class="spec">installFolder</th>
						    <td><xsl:value-of select="air/adt/installFolder"/></td>
						    <td class="spec">Identifies the subdirectory of the default installation directory.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="maximizable" class="specalt">maximizable</th>
						    <td class="hi"><xsl:value-of select="air/adt/maximizable"/></td>
						    <td class="alt">Maximizable window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="minimizable" class="spec">minimizable</th>
						    <td><xsl:value-of select="air/adt/minimizable"/></td>
						    <td class="spec">Minimizable window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="resizable" class="specalt">resizable</th>
						    <td class="hi"><xsl:value-of select="air/adt/resizable"/></td>
						    <td class="alt">Resizable window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="width" class="spec">width</th>
						    <td><xsl:value-of select="air/adt/width"/></td>
						    <td class="spec">The width of the initial window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="height" class="specalt">height</th>
						    <td class="hi"><xsl:value-of select="air/adt/height"/></td>
						    <td class="alt">The height of the initial window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="minSize" class="spec">minSize</th>
						    <td><xsl:value-of select="air/adt/minSize"/></td>
						    <td class="spec">The minSize of the initial window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="maxSize" class="specalt">maxSize</th>
						    <td class="hi"><xsl:value-of select="air/adt/maxSize"/></td>
						    <td class="alt">The maxSize of the initial window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="x" class="spec">x</th>
						    <td><xsl:value-of select="air/adt/x"/></td>
						    <td class="spec">The x position of the initial window of the application.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="y" class="specalt">y</th>
						    <td class="hi"><xsl:value-of select="air/adt/y"/></td>
						    <td class="alt">The y position of the initial window of the application.</td>
						  </tr>
						  
						</table>
						
						<h3><span>Icon</span></h3>
						<p class="p3"><span>The icon files used for the application, with support for the PNG format.</span></p>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="iconsFolder" class="specalt">iconsFolder</th>
						    <td class="hi"><xsl:value-of select="air/adt/iconsFolder"/></td>
						    <td class="alt">Source directory for the application icons.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="image16x16" class="spec">image16x16</th>
						    <td><xsl:value-of select="air/adt/icon/image16x16"/></td>
						    <td class="spec">16 x 16 pixels icon file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="image32x32" class="specalt">image32x32</th>
						    <td class="hi"><xsl:value-of select="air/adt/icon/image32x32"/></td>
						    <td class="alt">32 x 32 pixels icon file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="image48x48" class="spec">image48x48</th>
						    <td><xsl:value-of select="air/adt/icon/image48x48"/></td>
						    <td class="spec">48 x 48 pixel icon file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="image128x128" class="specalt">image128x128</th>
						    <td class="hi"><xsl:value-of select="air/adt/icon/image128x128"/></td>
						    <td class="alt">128 x 128 pixel icon file.</td>
						  </tr>
						</table>
						
						<h3><span>Runtime</span></h3>
						<p class="p4"><span>The runtime ensures consistent and predictable presentation and interactions across all the operating systems supported by AIR.</span></p>
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="version" class="spec">version</th>
						    <td><xsl:value-of select="$airVersion"/></td>
						    <td class="spec">The version number of the AIR runtime.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="config" class="specalt">config</th>
						    <td class="hi"><xsl:value-of select="air/runtime/config"/></td>
						    <td class="alt">Location of the AIR config file for the compiler.<br/><br/>
						    				The compiler loads the air-config.xml configuration file specifying the AIR and Flex libraries typically required to compile an AIR application. 
						    				You can use a local, project-level configuration file to override or add additional options to the global configuration.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="packager" class="spec">packager</th>
						    <td><xsl:value-of select="air/runtime/packager"/></td>
						    <td class="spec">Location of the ADT packager .jar file.<br/><br/>
						    				Applications are packaged as an AIR file for distribution with the AIR Developer Tool (ADT). 
						    				ADT creates installation packages for both HTML-based and SWF-based AIR applications.
						    				</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="debugger" class="specalt">debugger</th>
						    <td class="hi"><xsl:value-of select="air/runtime/debugger"/></td>
						    <td class="alt">Location of the AIR Debug Launcher (ADL).<br/><br/>
						    				The AIR Debug Launcher (ADL) is used to run both Flex-based and HTML-based applications during development. 
						    				Using ADL, you can run an application without first packaging and installing it.<br/><br/> 
						    				The runtime does not need to be installed to use ADL (just the Flex SDK). 
						    				The debugging support provided by ADL is limited to the printing of trace statements.
						    				</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="windows" class="spec">windows</th>
						    <td><xsl:value-of select="air/runtime/windows"/></td>
						    <td class="spec">The directory containing the Windows version of the AIR runtime.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="macosx" class="specalt">macosx</th>
						    <td class="hi"><xsl:value-of select="air/runtime/macosx"/></td>
						    <td class="alt">The directory containing the Mac OS X version of the AIR runtime.</td>
						  </tr>
						</table>
						
						<h3><span>Certificate</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="name" class="spec">name</th>
						    <td><xsl:value-of select="air/certificate/name"/></td>
						    <td class="spec">Certificate name.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="type" class="specalt">type</th>
						    <td class="hi"><xsl:value-of select="air/certificate/type"/></td>
						    <td class="alt">Type, either <code>1024-RSA</code> or <code>2048-RSA</code> for 1024-bit or 2048-bit <a href='http://en.wikipedia.org/wiki/RSA'>RSA</a> keys.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="file" class="spec">file</th>
						    <td><xsl:value-of select="air/certificate/file"/></td>
						    <td class="spec">Target location of AIR certificate file. If the specified file doesn't exist, a certificate file will be generated for you.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="password" class="specalt">password</th>
						    <td class="hi"><xsl:value-of select="air/certificate/password"/></td>
						    <td class="alt">Password for certificate.</td>
						  </tr>
						</table>
						
						<p/>
					</div>
			
					<div id="python">
						<p class="p1"><span><a href='http://python.org'>Python</a> is a dynamic object-oriented programming language that can be used for many kinds of software development. It runs on Windows, Linux/Unix, Mac OS X, OS/2, Amiga, Palm Handhelds, and Nokia mobile phones. Python has also been ported to the Java and .NET virtual machines.<br/><br/>
						Python is distributed under an <a href='http://www.opensource.org'>OSI</a>-approved <a href='http://www.python.org/psf/license'>open source license</a> that makes it free to use, even for commercial products.</span></p>
						<h3><span>General</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="version" class="spec">version</th>
						    <td><xsl:value-of select="python/version"/></td>
						    <td class="spec">Python version number.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="includes" class="specalt">includes</th>
						    <td class="hi"><xsl:value-of select="python/includes"/></td>
						    <td class="alt">Module includes.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="excludes" class="spec">excludes</th>
						    <td><xsl:value-of select="python/excludes"/></td>
						    <td class="spec">Module excludes.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="optimize" class="specalt">optimize</th>
						    <td class="hi"><xsl:value-of select="python/optimize"/></td>
						    <td class="alt">Python optimization level: <code>1</code> for "python -O", <code>2</code> for "python -OO", and <code>0</code> to disable.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="windows" class="spec">windows</th>
						    <td><xsl:value-of select="python/windows"/></td>
						    <td class="spec">Location of the Python interpreter executable (.exe file) for Windows.</td>
						  </tr>
						</table>
						
						<h3><span>Documentation</span></h3>
						
						<p class="p2"><span><a href='http://epydoc.sourceforge.net'>Epydoc</a> is a tool for generating API documentation for Python modules, based on their docstrings.</span></p>

						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="outputDir" class="spec">outputDir</th>
						    <td><xsl:value-of select="python/doc/outputDir"/></td>
						    <td class="spec">The output directory for the generated HTML documentation files.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="outputType" class="specalt">outputType</th>
						    <td class="hi"><xsl:value-of select="python/doc/outputType"/></td>
						    <td class="alt">The type of output that should be generated. Should be one of: <code>html</code>, <code>text</code>, <code>latex</code>, <code>dvi</code>, <code>ps</code>, <code>pdf</code>.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="frames" class="spec">frames</th>
						    <td><xsl:value-of select="python/doc/frames"/></td>
						    <td class="spec">Whether or not to include a frames-based table of contents.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="sourcecode" class="specalt">sourcecode</th>
						    <td class="hi"><xsl:value-of select="python/doc/sourcecode"/></td>
						    <td class="alt">Whether or not to include syntax highlighted source code in the output (HTML only).</td>
						  </tr>
						</table>

						<p/>
					</div>
			
					<div id="macosx">
						<p class="p1"><span><a href='http://www.apple.com/macosx/'>Mac OS X</a> is a line of proprietary, graphical operating systems developed, marketed, and sold by <a href='http://www.apple.com/'>Apple Inc.</a>, the latest of which is pre-loaded on all currently shipping Macintosh computers.</span></p>
						<h3><span>General</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="bundleId" class="spec">bundleId</th>
						    <td><xsl:value-of select="macosx/bundleId"/></td>
						    <td class="spec">CFBundleIdentifier.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="eula" class="specalt">eula</th>
						    <td class="hi"><xsl:value-of select="macosx/eula"/></td>
						    <td class="alt">Mac OS X can present the user with an <a href='http://en.wikipedia.org/wiki/EULA'>EULA</a> when the disk image is opened. This EULA is stored in the resource fork of the disk image with the <a href='http://developer.apple.com/documentation/Darwin/Reference/ManPages/man1/DeRez.1.html'>DeRez</a> and <a href='http://developer.apple.com/documentation/Darwin/Reference/ManPages/man1/Rez.1.html'>Rez</a> tools (part of the XCode Tools).<br/><br/>
						    				An example EULA file can be found in the <a href='ftp://ftp.apple.com/developer/Development_Kits/SLAs_for_UDIFs_1.0.dmg'>SLA SDK</a>, and is called <em>SLAResources</em>. 
						    				To edit it, use for example <a href='http://resknife.sourceforge.net/'>RezKnife</a>.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="plist" class="spec">plist</th>
						    <td><xsl:value-of select="macosx/plist"/></td>
						    <td class="spec"><a href='http://developer.apple.com/documentation/MacOSX/Conceptual/BPRuntimeConfig/Articles/PListKeys.html'>Plist</a> file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="appIcon" class="specalt">appIcon</th>
						    <td class="hi"><xsl:value-of select="macosx/appIcon"/></td>
						    <td class="alt">The system icon file used for the application.<br/><br/>
						    				On Mac OS X, icons are stored in special .icns files. These files can contain several versions of the icon, 
						    				as well as in some cases the required bitmasks. The main icon is 128x128 and uses alpha blending. <br/><br/>Besides this the developer can define 16x16, 32x32, and 48x48 versions, which use a 1-bit bitmask instead of alpha blending. These smaller versions serve as 'hints', which Mac OS X can use instead of scaling the 128x128 version, which might lead to undesired blurriness.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="volumeIcon" class="spec">volumeIcon</th>
						    <td><xsl:value-of select="macosx/volumeIcon"/></td>
						    <td class="spec">The volume icon file used for the application's DMG file.<br/><br/>
						    				Requires the <a href='http://developer.apple.com/documentation/Darwin/Reference/ManPages/man1/SetFile.1.html'>SetFile</a> tool (part of the XCode Tools) to change the custom icon attribute for the directory inside the DMG file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="background" class="specalt">background</th>
						    <td class="hi"><xsl:value-of select="macosx/background"/></td>
						    <td class="alt">DMG Finder window background PNG image.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="positionScript" class="spec">positionScript</th>
						    <td><xsl:value-of select="macosx/positionScript"/></td>
						    <td class="spec"><a href='http://developer.apple.com/documentation/AppleScript/AppleScript.html'>Applescript</a> for positioning installer items.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="mountDir" class="specalt">mountDir</th>
						    <td><xsl:value-of select="macosx/mountDir"/></td>
						    <td class="spec">Temporary mount directory for DMG volume.</td>
						  </tr>
						</table>
						
						<p/>				
					</div>
			
					<div id="windows">
						<p class="p1"><span><a href='http://www.microsoft.com/Windows/'>Windows</a> is the name of several families of proprietary software operating systems by <a href='http://www.microsoft.com'>Microsoft</a>.</span></p>
						<h3><span>General</span></h3>
						
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="imgcfg" class="spec">imagecfg</th>
						    <td><xsl:value-of select="windows/imgcfg"/></td>
						    <td class="spec">The location of the <a href='http://www.robpol86.com/Pages/imagecfg.php'>imgcfg</a> executable.<br/><br/>
						    				Sets the processor affinity for the application.</td>
						  </tr>
						</table>
						
						<h3><span>Installer</span></h3>
						<p class="p2"><span><a href='http://nsis.sourceforge.net'>Nullsoft Scriptable Install System</a> (NSIS) is a script-driven Windows installation system with minimal overhead backed by <a href='http://www.nullsoft.com/'>Nullsoft</a>, the creators of Winamp. <br/><br/>
						NSIS is released under a combination of free software licences, primarily the <a href='http://www.gzip.org/zlib/zlib_license.html'>zlib/libpng</a> license.</span></p>
						<table id="mytable" cellspacing="0">
						  <tr>
						    <th scope="col" abbr="Tag">Tag</th>
						    <th scope="col" abbr="Value">Value</th>
							<th scope="col" abbr="Description">Description</th>
						  </tr>
						  <tr>
						    <th scope="row" abbr="exe" class="spec">exe</th>
						    <td><xsl:value-of select="windows/nsis/exe"/></td>
						    <td class="spec">Executable location.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="config" class="specalt">config</th>
						    <td class="hi"><xsl:value-of select="windows/nsis/config"/></td>
						    <td class="alt">Configuration file.</td>
						  </tr>
						  <tr>
						    <th scope="row" abbr="header" class="spec">header</th>
						    <td ><xsl:value-of select="windows/nsis/header"/></td>
						    <td class="spec">Installer header image.</td>
						  </tr>
						</table>
						
					</div>
					
				</div>

			</div>
			<br/>
			<p class="p2"><span>Report generated on <xsl:value-of select="$timestamp"/></span></p>
			<br/>
			<p class="p3"><span><a href='http://python.org'><img src='../images/python-powered.png'/></a></span></p>
        </body>
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>
