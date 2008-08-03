/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * Base class for errors in the email package. 
	 */	
	public class MessageError extends Error
	{
		public function MessageError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}