/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp.error
{
	/**
	 * Not connected to any SMTP server.
	 * 
     * <p>This exception is raised when the server unexpectedly disconnects,
     * or when an attempt is made to use the SMTP instance before
     * connecting it to a server.</p>
	 */	
	public class SMTPServerDisconnected extends SMTPException
	{
		public function SMTPServerDisconnected(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}