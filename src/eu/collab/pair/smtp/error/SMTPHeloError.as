/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * The server refused our HELO reply.
	 */	
	public class SMTPHeloError extends SMTPResponseException
	{
		public function SMTPHeloError(message:String="", code:int=undefined, id:int=0)
		{
			super(message, code, id);
		}
		
	}
}