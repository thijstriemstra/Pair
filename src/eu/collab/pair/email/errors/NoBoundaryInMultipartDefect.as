/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * A message claimed to be a multipart but had no boundary parameter.
	 */	
	public class NoBoundaryInMultipartDefect extends MessageDefect
	{
		public function NoBoundaryInMultipartDefect(line:String=null)
		{
			super(line);
		}
		
	}
}