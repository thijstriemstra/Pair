/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp
{
	import eu.collab.pair.email.Utils;
	import eu.collab.pair.smtp.error.*;
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.net.Socket;
	
	/**
	 * This class manages a connection to an SMTP or ESMTP server.
	 * 
     * <p>SMTP Objects:</p>
     *   <li>SMTP objects have the following attributes:
            <li>helo_resp<br/>
                This is the message given by the server in response to the
                most recent HELO command.</li>

            <li>ehlo_resp<br/>
                This is the message given by the server in response to the
                most recent EHLO command. This is usually multiline.</li>

            does_esmtp
                This is a True value _after you do an EHLO command_, if the
                server supports ESMTP.

            esmtp_features
                This is a dictionary, which, if the server supports ESMTP,
                will _after you do an EHLO command_, contain the names of the
                SMTP service extensions this server supports, and their
                parameters (if any).

                Note, all extension names are mapped to lower case in the
                dictionary.
	 *	 </li>
	 *
     * <p>In general, there is a method of the same name to perform each 
     * SMTP command.  There is also a method called 'sendMail' that will 
     * do an entire mail transaction.</p>
     * 
     * @see eu.collab.pair.smtp.SMTP.sendMail() sendMail()
	 */	
	public class SMTP
	{
		public static const SMTP_PORT:int 	= 25;
		public static const CRLF:String 	= "\r\n";
		
		public var local_hostname:String;
		public var esmtp_features:Object;
		
		public var file:File;
		public var sock:Socket;
		public var helo_resp:String;
		public var ehlo_resp:String;
		public var does_esmtp:int 			= 0;
		
		private var _debuglevel:int 		= 0;
		
		/**
		 * Initialize a new instance.
		 * 
         * If specified, `host' is the name of the remote host to which to
         * connect.  If specified, `port' specifies the port to which to connect.
         * By default, SMTP.SMTP_PORT is used.  An SMTPConnectError is raised
         * if the specified `host' doesn't respond correctly.  If specified,
         * `local_hostname` is used as the FQDN of the local host.  By default,
         * the local hostname is found using socket.getfqdn().
         * 
		 * @param host
		 * @param port
		 * @param localHostName
		 */		
		public function SMTP(host:String='', port:int=0, localHostName:String=null)
		{
			this.esmtp_features = new Object();
			
			if (host != null) {
				var v:Array = connect(host, port);
				if (v[0] != 220) {
					
				}
			}
			
			if (local_hostname != null) {
				local_hostname == localHostName;
			} else {
			}
		}
		
		public function get debuglevel():int
		{
			return _debuglevel;
		}
		
		/**
		 * Set the debug output level.
		 * 
         * A non-false value results in debug messages for connection and for all
         * messages sent to and received from the server. 
		 */		
		public function set debuglevel(val:int):void
		{
			this._debuglevel = val;
		}
		
		/**
		 * Connect to a host on a given port.
		 * 
         * If the hostname ends with a colon (`:') followed by a number, and
         * there is no port specified, that suffix will be stripped off and the
         * number interpreted as the port number to use.
		 * 
         * Note: This method is automatically invoked by the constructor if a host 
         * is specified during instantiation. 
		 */		
		public function connect(host:String='localhost', port:int=0):Array
		{
			if (host.indexOf(':') == host.lastIndexOf(':')) {
				var i:int = host.lastIndexOf(':');
				
				if (i >= 0) {
					var host:String = host.substr(0, i);
					var p:* = host.substr(i+1);
					try {
						port = int(p);
					} catch (e:*) {
						throw new Error('nonnumeric port: ' + p);
					}
				}
			}
			
			if (!port) {
				port = SMTP_PORT;
			}
			
			if (_debuglevel > 0) {
				trace('connect: ' + host + ":" + port);
			}
			
			var msg:String = 'getaddrinfo returns an empty array';

			try {
				sock.connect(host, port);
				if (debuglevel > 0) {
					trace('connect: ' + host);
				}
			} catch (e:*) {
				if (debuglevel > 0) {
					trace('connect fail: ' + e.message);
				}
				if (sock != null) {
					sock.close();
				}
				sock = null;
			}
			
			var reply:Array = getReply();
			
			return reply;
		}
		
		/**
		 * Quote a subset of the email addresses defined by RFC 821.
		 * 
    	 * <p>Should be able to handle anything rfc822.parseaddr can handle.</p>
    	 *  
		 * @param address
		 * @return 
		 */		
		public static function quoteAddress(address:String):String
		{
			var m:Array = [null, null];
			
			try {
				m = Utils.parseAddress(address)[1];
			} catch (e:Error) {
				
			}
			
			if (m == [null, null]) {
				return '<' + address + '>';
			} else if (m == null) {
				// the sender wants an empty return address
				return '<>';
			} else {
				return '<' + m + '>';
			}
		}
		
		/**
		 * Quote data for email.
		 * 
    	 * Double leading '.', and change Unix newline '\\n', or Mac '\\r' into
    	 * Internet CRLF end-of-line.
    	 *  
		 * @param address
		 * @return 
		 */		
		public static function quoteData(address:String):String
		{
			// TODO
			return address;
		}
		
		/**
		 * This command performs an entire mail transaction.
		 * 
         * <p>If there has been no previous EHLO or HELO command this session, this
         * method tries ESMTP EHLO first.  If the server does ESMTP, message size
         * and each of the specified options will be passed to it.  If EHLO
         * fails, HELO will be tried and ESMTP options suppressed. </p>
		 * 
         * <p>This method will return normally if the mail is accepted for at least
         * one recipient.  It returns a dictionary, with one entry for each
         * recipient that was refused.  Each entry contains a tuple of the SMTP
         * error code and the accompanying error message sent by the server.</p>
		 * 
         * <p>This method may raise the following exceptions:</p>
		 *
         * SMTPHeloError          The server didn't reply properly to
         *                       the helo greeting.
         * SMTPRecipientsRefused  The server rejected ALL recipients
         *                       (no mail was sent).
         * SMTPSenderRefused      The server didn't accept the from_addr.
         * SMTPDataError          The server replied with an unexpected
         *                       error code (other than a refusal of
         *                       a recipient).
		 *
         * Note: the connection will be open even after an exception is raised.
		 * 
		 * @param fromAddr		The address sending this mail.
		 * @param toAddrs		A list of addresses to send this mail to.  A bare
         *                    	string will be treated as a list with 1 address.
		 * @param msg 			The message to send.
		 * @param mailOptions	List of ESMTP options (such as 8bitmime) for the
         *                    	mail command.
		 * @param rcptOptions	List of ESMTP options (such as DSN commands) for
         *                    	all the rcpt commands.
		 */		
		public function sendMail(fromAddr:String, toAddrs:*, msg:String, 
				      			 mailOptions:Array=undefined, 
				      			 rcptOptions:Array=undefined):void
        {
        	var codeResp:Array;
        	
        	if (this.helo_resp == null && this.ehlo_resp == null) {
        		if (!(200 <= this.ehlo()[0] || this.ehlo()[0] <= 299)) {
        			codeResp = this.helo();
        			if (!(200 <= codeResp[0] || codeResp[0] <= 299)) {
        				throw new SMTPHeloError(codeResp[1], codeResp[0]);
        			}
        		}
        	}
        	
        	var esmtp_opts:Array = new Array();

        	if (this.does_esmtp) {
        		
        	}
        }
        
        /**
		 * Close the connection to the SMTP server. 
		 */		
		private function close():void
		{
			if (this.file != null) {
				//file.close();
			}
			
			this.file = null;
			
			if (this.sock != null) {
				this.sock.close();
			}
			
			this.sock = null;
		}
		
		/**
		 * Terminate the SMTP session. 
		 */		
		public function quit():void
		{
			this.docmd('quit');
			this.close();
		}
		
		/**
		 * Log in on an SMTP server that requires authentication.
		 * 
         * The arguments are:
         *   - user:     The user name to authenticate with.
         *   - password: The password for the authentication.
		 * 
         * If there has been no previous EHLO or HELO command this session, this
         * method tries ESMTP EHLO first.
		 * 
         * This method will return normally if the authentication was successful.
		 *
         * This method may raise the following exceptions:
		 * 
         * SMTPHeloError            The server didn't reply properly to
         *                         the helo greeting.
         * SMTPAuthenticationError  The server didn't accept the username/
         *                         password combination.
         * SMTPException            No suitable authentication method was
         *                         found.
         *   
		 * @param user
		 * @param password
		 */		
		public function login(user:String, password:String):void
		{
		}

		/**
		 * Get a reply from the server.
		 * 
         * <p>Returns a array consisting of:</p>
		 *
         * <li>server response code (e.g. '250', or such, if all goes well)
         *   Note: returns -1 if it can't read response code.</li>
		 *
         * <li>server response string corresponding to response code (multiline
         *   responses are converted to a single, multiline string).</li>
		 *
         * <p>Raises SMTPServerDisconnected if end-of-file is reached.</p>
         *   
		 * @return 
		 */				
		private function getReply():Array
		{
			var resp:Array = new Array();
			var errcode:int;
			
			if (this.file == null) {
				this.file = new File();
			}
			/*
			while (1) {
				var line:String; // = file.readline();
				if (line == '') {
					this.close();
					throw new SMTPServerDisconnected('Connection unexpectedly closed');
				}
				if (debuglevel > 0) {
					trace('reply: ' + line.toString());
				}
				resp.push(line.substr(4));
				var code:String = line.substr(0, 3);
				
				try {
					errcode = Number(code);	
				} catch (e:*) {
					errcode = -1;
					break;
				}
				
				if (line.substr(3, 4) != '-') {
					break;
				}
			}
			*/
			var errormsg:String = '';
			
			for (var d:int=0;d<resp.length;d++) {
				errormsg +=  resp[d] + "\n";
			}
			
			if (debuglevel > 0) {
				trace('reply: retcode (' + errcode + '); Msg: ' + errormsg);
			}
			
			return [errcode, errormsg];
		}
		
		/**
		 * Send a command, and return its response code.
		 *  
		 * @param cmd
		 * @param args
		 * @return 
		 */		
		private function docmd(cmd:String, args:String=''):Array
		{
			this.putcmd(cmd,args);
			
			return this.getReply();	
		}
		
		/**
		 * Send a command to the server.
		 *  
		 * @param cmd
		 * @param args
		 */		
		private function putcmd(cmd:String, args:String=""):void
		{
			var str:String;
			
			if (args == '') {
				str = cmd + CRLF;	
			} else {
				str = cmd + " " + args + CRLF;
			}
			
			this.send(str);
		}
		
		/**
		 * Send `str' to the server.
		 *  
		 * @param str
		 */		
		private function send(str:*):void
		{
			if (this.debuglevel > 0) {
				trace('send: ' + str.toString());
			}
			
			if (this.sock != null) {
				try {
					//this.sock.sendall(str);
				} catch (e:IOError) {
					this.sock.close();
					throw new SMTPServerDisconnected('Server not connected');
				}
			} else {
				throw new SMTPServerDisconnected('Please run connect() first');
			}
		}
		
		/**
		 * SMTP 'helo' command.
         * 
         * <p>Hostname to send for this command defaults to the FQDN of the local
         * host.</p>
         *  
		 * @param cmd
		 * @param name
		 * @return 
		 */		
		private function helo(cmd:String='', name:String=''):Array
		{
			this.putcmd('helo', name || this.local_hostname);
			
			var reply:Array = this.getReply();
			this.helo_resp = reply[1];
			
			return reply;
		}
		
		/**
		 * SMTP 'ehlo' command.
         * 
         * <p>Hostname to send for this command defaults to the FQDN of the local
         * host.</p>
         *  
		 * @param name
		 * @return 
		 */		
		private function ehlo(name:String=''):Array
		{
			this.esmtp_features = new Object();
			this.putcmd('ehlo', name || local_hostname);
			
			var reply:Array = this.getReply();
			var code:int = reply[0]
			var msg:String = reply[1];
			
			if (code == -1 && msg.length == 0) {
				this.close();
				throw new SMTPServerDisconnected('Server not connected');
			}
			
			this.ehlo_resp = msg;
			
			if (code != 250) {
				return reply;
			}
			
			this.does_esmtp = 1;
			
			var resp:Array = ehlo_resp.split('\n');
			resp.unshift();
			
			for (var s:int=0;s<resp.length;s++) {
				// TODO
				// OLDSTYLE_AUTH = re.compile("auth=(.*)", re.I)
			}
			
			return reply;
		}
		
		/**
		 * Does the server support a given SMTP service extension?
		 *  
		 * @param opt
		 * @return 
		 */		
		private function hasExtension(opt:String):Boolean
		{
			for (var d:int;d<esmtp_features.length;d++) {
				if (esmtp_features[d] == opt.toLowerCase()) {
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * SMTP 'help' command.
         * 
         * <p>Returns help text from server.</p>
         *  
		 * @param args
		 * @return 
		 */		
		private function help(args:String=''):String
		{
			this.putcmd('help', args);
			
			return this.getReply()[1];
		}
		
		/**
		 * SMTP 'rset' command -- resets session.
		 * 
		 * @return 
		 */		
		private function rset():Array
		{
			return this.docmd('rset');
		}
		
		/**
		 * SMTP 'noop' command -- doesn't do anything.
		 * 
		 * @return 
		 */		
		private function noop():Array
		{
			return this.docmd('noop');
		}
		
		/**
		 * SMTP 'mail' command -- begins mail xfer session.
		 *  
		 * @param sender
		 * @param options
		 * @return 
		 */		
		private function mail(sender:String, options:Array=undefined):Array
		{
			var optionList:String = '';
			
			return this.getReply();
		}
		
		/**
		 * SMTP 'rcpt' command -- indicates 1 recipient for this mail.
		 *  
		 * @param recip
		 * @param options
		 * @return 
		 */		
		private function rcpt(recip:String, options:Array=undefined):Array
		{
			var optionList:String = '';
			
			return this.getReply();
		}
		
		/**
		 * SMTP 'verify' command -- checks for address validity.
		 * 
		 * @param address
		 * @return 
		 */		
		private function verify(address:String):Array
		{
			this.putcmd('vrfy', quoteAddress(address));
			
			return this.getReply();
		}
		
		private function expn(address:String):Array
		{
			this.putcmd('expn', quoteAddress(address));
			
			return this.getReply();
		}
		
		/**
		 * SMTP 'DATA' command -- sends message data to server.
		 *
         * <p>Automatically quotes lines beginning with a period per rfc821.
         * Raises SMTPDataError if there is an unexpected reply to the
         * DATA command; the return value from this method is the final
         * response code received when the all data is sent.</p>
         * 
		 * @param msg
		 * @return
		 */		
		private function data(msg:String):Array
		{
			this.putcmd('data');
			
			return this.getReply();	
		}

	}
}