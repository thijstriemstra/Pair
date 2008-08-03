/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Error during connection establishment.
	 */	
	public class SMTPConnectError extends SMTPResponseException
	{
		public function SMTPConnectError(message:String="", code:int=null, id:int=0)
		{
			super(message, code, id);
		}
		
	}
}