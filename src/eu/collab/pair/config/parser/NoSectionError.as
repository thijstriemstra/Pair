/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when no section matches a requested option. 
	 */	
	public class NoSectionError extends ConfigParserError
	{
		public var section:String;
		
		public function NoSectionError(section:String)
		{
			super('No section: ' + section);
			this.section = section;
		}
		
	}
}