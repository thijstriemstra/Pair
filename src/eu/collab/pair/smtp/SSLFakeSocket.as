/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp
{
	import flash.net.Socket;
	
	/**
	 * A fake socket object that really wraps a SSLObject.
	 * 
     * <p>It only supports what is needed in the smtp package.</p>
	 */	
	public class SSLFakeSocket
	{
		public var sslobj:Object;
		public var realsock:Socket;
		
		public function SSLFakeSocket(realsock:Socket, sslobj:Object)
		{
			this.realsock = realsock;
			this.sslobj = sslobj;
		}
		
		public function send(str:String):int
		{
			this.sslobj.write(str);
			
			return str.length;
		}
		
		public function sendall(str:String):int
		{
			return this.send(str);	
		}
		
		public function close():void
		{
			this.realsock.close();
		}

	}
}