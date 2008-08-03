/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * All recipient addresses refused.
	 * 
     * <p>The errors for each recipient are accessible through the attribute
     * 'recipients', which is a dictionary of exactly the same sort as
     * SMTP.sendmail() returns.</p>
	 */	
	public class SMTPRecipientsRefused extends SMTPException
	{
		public var recipients:Array;
		public var args:Array;
		
		public function SMTPRecipientsRefused(message:String="", recipients:Array=null, id:int=0)
		{
			super(message, id);
			
			this.recipients = recipients;
			this.args = [recipients];
		}
		
	}
}