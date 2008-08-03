/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when the source text into which substitutions are made
     * does not conform to the required syntax. 
	 */	
	public class InterpolationSyntaxError extends InterpolationError
	{
		public function InterpolationSyntaxError(option:String, section:String, msg:String)
		{
			super(option, section, msg);
		}
		
	}
}