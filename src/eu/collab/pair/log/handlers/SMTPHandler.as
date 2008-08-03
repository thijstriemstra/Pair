/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.email.Utils;
	import eu.collab.pair.log.Handler;
	import eu.collab.pair.log.LogRecord;
	import eu.collab.pair.smtp.SMTP;

	/**
	 * A handler class which sends an SMTP email for each logging event. 
	 */	
	public class SMTPHandler extends Handler
	{
		public var mailhost:	String;
		public var mailport:	int;
		public var fromaddr:	String;
		public var toaddrs:		Array;
		public var subject:		String;
		
		/**
		 * Initialize the handler.
		 *
		 * <p>Initialize the instance with the from and to addresses and subject
		 * line of the email. To specify a non-standard SMTP port, use the
		 * [host, port] array format for the mailhost argument.</p>
		 * 
		 * @param mailhost
		 * @param fromAddr
		 * @param toAddrs
		 * @param subject
		 */		
		public function SMTPHandler(mailhost:*, fromAddr:String, 
									toAddrs:*, subject:String)
		{
			super();
			
			if (mailhost is Array) {
				this.mailhost = mailhost;
				this.mailport = mailport;
			} else {
				this.mailhost = mailhost;
			}
			
			this.fromaddr = fromAddr;
			
			if (!(toAddrs is Array)) {
				toAddrs = [toAddrs];
			}
			
			this.toaddrs = toAddrs;
			this.subject = subject;
		}

		/**
		 * Determine the subject for the email.
		 * 
         * <p>If you want to specify a subject line which is record-dependent,
         * override this method.</p>
         *  
		 * @param record
		 * @return 
		 */		
		public function getSubject(record:LogRecord):String
		{
			return this.subject;
		}
		
		/**
		 * Emit a record.
		 * 
         * <p>Format the record and send it to the specified address(es).</p>
         * 
		 * @param record
		 */		
		override public function emit(record:LogRecord):void
		{
			var port:int = mailport;
			
			if (!mailport) {
				port = SMTP.SMTP_PORT;
			}
			
			var smtp:SMTP = new SMTP(mailhost, port);
			smtp.debuglevel = 1;

			var recMsg:String = format(record);
			var msg:String = "From: " + fromaddr + "\r\nTo: " + toaddrs.join(',') + "\r\nSubject: " + 
				  getSubject(record) + "\r\nDate: " + Utils.formatDate() + "\r\n\r\n" + recMsg;
			trace('smtphandler');
			
			smtp.sendMail(fromaddr, toaddrs, msg);
			smtp.quit();		
		}
		
	}
}