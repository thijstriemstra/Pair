/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.log.Handler;
	import eu.collab.pair.log.LogRecord;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * A handler class which writes logging records, in ByteArray format, to
     * a streaming socket. 
     * 
     * <p>The socket is kept open across logging calls. If the peer resets it, 
     * an attempt is made to reconnect on the next call. The ByteArray which is 
     * sent is a typed LogRecord.
	 *
     * To unpickle the record at the receiving end into a LogRecord, use the
     * makeLogRecord function.
	 */	
	public class SocketHandler extends Handler
	{
		public var host:			String;
		public var port:			int;
		public var sock:			Socket;
		public var closeOnError:	Boolean;
		
		public var retryTime:		int = -1;
		public var retryStart:		int;
		public var retryMax:		int;
		public var retryFactor:		int;
		public var retryPeriod:		int;
		
		/**
		 * Initializes the handler with a specific host address and port.
		 *
         * <p>The attribute 'closeOnError' is set to 1 - which means that if
         * a socket error occurs, the socket is silently closed and then
         * reopened on the next logging call.</p>
         * 
		 * @param host
		 * @param port
		 */		
		public function SocketHandler(host:String, port:int)
		{
			super();
			
			this.host = host;
			this.port = port;
			this.closeOnError = false;
			
			this.retryStart = 1.0;
			this.retryMax = 30.0;
			this.retryFactor = 2.0;
		}
		
		/**
		 * A factory method which allows subclasses to define the precise
         * type of socket they want.
         * 
		 * @return 
		 */		
		public function makeSocket():Socket
		{
			var s:Socket = new Socket();
			s.addEventListener(Event.CONNECT, connect);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError);
			s.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			s.addEventListener(ProgressEvent.SOCKET_DATA, progress);
			s.connect(host, port);
			
			return s;
		}
		
		/**
		 * A network connection has been established.
		 * 
		 * @param event
		 */		
		private function connect(event:Event):void
		{
			trace('connect');
		}
		
		/**
		 * An input/output error occured that caused the connection 
		 * to fail.
		 * 
		 * @param event
		 */		
		private function ioError(event:IOErrorEvent):void
		{
			if (event.errorID == 2031) {
				
			}
			error(event);
		}
		
		/**
		 * Called when the socket has received data.
		 * 
		 * @param event
		 */		
		private function progress(event:ProgressEvent):void
		{
			
		}
		
		private function error(e:*):void
		{
			trace('error' + e);
            // Creation failed, so set the retry time and return.
            if (retryTime == -1) {
                retryPeriod = retryStart;
            } else {
                retryPeriod = retryPeriod * retryFactor;
                if (retryPeriod > retryMax) {
                    retryPeriod = retryMax;
                }
            }
            var now:int = new Date().getTime() / 1000;
            retryTime = now + retryPeriod;
            trace(retryTime + " : " + now);
		}
		
		/**
		 * Error occured in SWF content. Called when Socket.connect() 
		 * attempts to connect either to a server outside the caller's 
		 * security sandbox or to a port lower than 1024. You can work 
		 * around either problem by using a cross-domain policy file 
		 * on the server.
		 * 
		 * @param event
		 */		
		private function securityError(event:SecurityErrorEvent):void
		{
			trace('securityError');
		}
		
		/**
		 * Try to create a socket, using an exponential backoff with
         * a max retry time. 
		 */		
		public function createSocket():void
		{
			var now:int = new Date().getTime() / 1000;
			var attempt:Boolean;
			
	        // Either retryTime is None, in which case this
	        // is the first time back after a disconnect, or
	        // we've waited long enough.
	        if (retryTime == -1) {
	            attempt = true;
	        } else {
	            attempt = (now >= retryTime);
	        }

	        if (attempt) {
	        	sock = makeSocket();
	            retryTime = -1; // next time, no delay before trying
	        }
		}
		
		/**
		 * Send a pickled string to the socket.
		 * 
	     * This function allows for partial sends which can happen when the
	     * network is busy.
	     * 
		 * @param s
		 */		
		private function send(s:ByteArray):void
		{
			trace('send');
	        if (sock == null) {
	            createSocket();
	        }
	        
	        //self.sock can be None either because we haven't reached the retry
	        //time yet, or because we have reached the retry time and retried,
	        ///but are still unable to connect.
	        if (sock != null) {
	            try {
	                sock.writeObject(s);
	            } catch (e:IOError) {
	            	trace('hey');
	                sock.close();
	                sock = null;  // so we can call createSocket next time
	            }
	        }
	 	}
	 	
	    /**
	     * Pickles the record in binary format with a length prefix, and
	     * returns it ready for transmission across the socket.
	     *  
	     * @param record
	     * @return 
	     */		
	    private function makePickle(record:LogRecord):ByteArray
	    {
	    	// TODO
	        //var ei:int = record.exc_info
	        
	        //if (ei) {
	        //    dummy = format(record); // just to get traceback text into record.exc_text
	        //    record.exc_info = null;  // to avoid Unpickleable error
	        //}
	        
	        var s:ByteArray = new ByteArray();
	        s.writeObject(record);
	        
	        //if (ei) {
	        //     record.exc_info = ei;  // for next handler
	        //}
	        
	        return s;
	    }
	
	    /**
	     * Handle an error during logging.
		 *
	     * An error has occurred during logging. Most likely cause -
	     * connection lost. Close the socket so that we can retry on the
	     * next event.
	     * 
	     * @param record
	     */		
	    override public function handleError(e:*, record:LogRecord):void
	    {
	        if (closeOnError && sock) {
	            sock.close();
	            sock = null; //try to reconnect next time
	        } else {
	            super.handle(record);
	        }
	    }
		
	    /**
	     * Emit a record.
	     * 
	     * Pickles the record and writes it to the socket in binary format.
	     * If there is an error with the socket, silently drop the packet.
	     * If there was a problem with the socket, re-establishes the
	     * socket.
	     *  
	     * @param record
	     */		
	    override public function emit(record:LogRecord):void
	    {
	        try {
	            var s:ByteArray = makePickle(record);
	            send(s);
	        } catch (e:*) {
	        	handleError(e, record);
	        }
	    }
	
		/**
		* Closes the socket. 
		*/		
	    override public function close():void
	    {
	        if (sock != null) {
	            sock.close()
	            sock = null;
	        }
			
			super.close();
	    }
		
	}
}