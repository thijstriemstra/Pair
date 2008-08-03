/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * A requested option was not found.
	 */	
	public class NoOptionError extends ConfigParserError
	{
		public var section:String;
		public var option:String;
		
		public function NoOptionError(option:String, section:String)
		{
			super('No option ' + option + ' in section: ' + section);
			this.section = section;
			this.option = option;
		}
		
	}
}