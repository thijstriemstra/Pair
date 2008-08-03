/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Base class for all exceptions raised by this module.
	 */	
	public class SMTPException extends Error
	{
		public function SMTPException(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}