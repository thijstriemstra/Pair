/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Authentication error.
	 *
     * <p>Most probably the server didn't accept the username/password
     * combination provided.</p>
	 */	
	public class SMTPAuthenticationError extends SMTPResponseException
	{
		public function SMTPAuthenticationError(message:String="", code:int=null, id:int=0)
		{
			super(message, code, id);
		}
		
	}
}