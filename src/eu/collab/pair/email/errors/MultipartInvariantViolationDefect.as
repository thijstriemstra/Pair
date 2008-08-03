/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * A message claimed to be a multipart but no subparts were found.
	 */	
	public class MultipartInvariantViolationDefect extends MessageDefect
	{
		public function MultipartInvariantViolationDefect(line:String=null)
		{
			super(line);
		}
		
	}
}