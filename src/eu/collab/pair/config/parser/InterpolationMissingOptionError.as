/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * A string substitution required a setting which was not available.
	 */	
	public class InterpolationMissingOptionError extends InterpolationError
	{
		public var reference:String;
		
		public function InterpolationMissingOptionError(option:String, 
												section:String, rawval:String,
												reference:String)
		{
			var msg:String = "Bad value substitution:\n" +
               "\tsection: [" + section +"]\n" +
               "\toption : " + option + "\n" +
               "\tkey    : " + reference + "\n" +
               "\trawval : " + rawval + "\n";
               
			super(option, section, msg);
		    this.reference = reference
		}
		
	}
}