/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * A 'Unix-from' header was found in the middle of a header block.
	 */	
	public class MisplacedEnvelopeHeaderDefect extends MessageDefect
	{
		public function MisplacedEnvelopeHeaderDefect(line:String=null)
		{
			super(line);
		}
		
	}
}