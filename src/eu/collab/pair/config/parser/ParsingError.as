/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when a configuration file does not follow legal syntax. 
	 */	
	public class ParsingError extends ConfigParserError
	{
		public var filename:String;
		public var errors:Array;
		
		public function ParsingError(filename:String)
		{
			super('File contains parsing errors: ' + filename);
			this.filename = filename;
        	this.errors = new Array();
		}
		
		public function append(lineno:int, line:String):void
		{
			this.errors.push([lineno, line]);
			this.message += '\n\t[line ' + lineno.toString() + ']: ' + line;
		}
		
	}
}