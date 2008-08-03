/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Base class for interpolation-related exceptions.
	 */	
	public class InterpolationError extends ConfigParserError
	{
		public var section:String;
		public var option:String;
		
		public function InterpolationError(option:String, section:String, msg:String)
		{
			super(msg);
			this.section = section;
			this.option = option;
		}
		
	}
}