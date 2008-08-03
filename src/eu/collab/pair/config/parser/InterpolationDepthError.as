/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when substitutions are nested too deeply.
	 */	
	public class InterpolationDepthError extends InterpolationError
	{
		public function InterpolationDepthError(option:String, section:String, 
												rawval:String)
		{
			var msg:String = "Value interpolation too deeply recursive:\n" +
               "\tsection: [" + section +"]\n" +
               "\toption : " + option + "\n" +
               "\trawval : " + rawval + "\n";
               
			super(option, section, msg);
		}
		
	}
}