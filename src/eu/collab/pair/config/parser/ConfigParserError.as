/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Base class for ConfigParser exceptions. 
	 */	
	public class ConfigParserError extends Error
	{
		public function ConfigParserError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}