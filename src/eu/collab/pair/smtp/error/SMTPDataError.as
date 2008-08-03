/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * The SMTP server didn't accept the data.
	 */	
	public class SMTPDataError extends SMTPResponseException
	{
		public function SMTPDataError(message:String="", code:int=null, id:int=0)
		{
			super(message, code, id);
		}
		
	}
}