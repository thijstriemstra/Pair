/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * Found a header that was missing a colon, or was otherwise malformed.
	 */	
	public class MalformedHeaderDefect extends MessageDefect
	{
		public function MalformedHeaderDefect(line:String=null)
		{
			super(line);
		}
		
	}
}