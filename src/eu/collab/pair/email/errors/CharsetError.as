/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * An illegal charset was given.
	 */	
	public class CharsetError extends MessageError
	{
		public function CharsetError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}