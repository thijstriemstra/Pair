/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when a key-value pair is found before any section header. 
	 */	
	public class MissingSectionHeaderError extends ParsingError
	{
		public var lineno:String;
		public var line:String;
		
		public function MissingSectionHeaderError(filename:String, 
											lineno:String, line:String)
		{
			var msg:String = 'File contains no section headers.\n' +
							 'file: ' + filename + ', line:' + lineno +
							 '\n' + line;
							 
			super(msg);
			
			this.filename = filename;
			this.lineno = lineno;
			this.line = line;
		}
		
	}
}