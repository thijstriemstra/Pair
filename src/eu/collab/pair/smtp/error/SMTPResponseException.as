/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Base class for all exceptions that include an SMTP error code.
	 * 
     * <p>These exceptions are generated in some instances when the SMTP
     * server returns an error code.  The error code is stored in the
     * `smtp_code' attribute of the error, and the `smtp_error' attribute
     * is set to the error message.</p>
	 */	
	public class SMTPResponseException extends SMTPException
	{
		public var smtpCode:int;
		public var smtpError:String;
		public var args:Array;
		
		public function SMTPResponseException(message:String="", code:int=undefined, id:int=0)
		{
			super(message, id);
			
			this.smtpCode = code;
			this.smtpError = message;
			this.args = [code, message];
		}
		
	}
}