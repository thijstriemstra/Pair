/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Sender address refused.
	 * 
     * <p>In addition to the attributes set by on all SMTPResponseException
     * exceptions, this sets `sender' to the string that the SMTP refused.</p>
	 */	
	public class SMTPSenderRefused extends SMTPResponseException
	{
		public var sender:String;
		
		public function SMTPSenderRefused(message:String="", code:int=null, 
										  sender:String=null, id:int=0)
		{
			super(message, code, id);
			
			this.smtpCode = code;
			this.smtpError = msg;
			this.sender = sender;
			this.args = [code, msg, sender];
		}
		
	}
}