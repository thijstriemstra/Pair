/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.smtp
{
	/**
	 * A fake file like object that really wraps a SSLObject.
	 * 
     * <p>It only supports what is needed in the smtp package.</p>
	 */	
	public class SSLFakeFile
	{
		public var sslobj:Object;
		
		public function SSLFakeFile(sslobj:Object)
		{
			this.sslobj = sslobj;
		}
		
		public function readline():String
		{
			var str:String = '';
			var chr:String;
			
			while (chr != '\n') {
				chr += this.sslobj.read(1);
				str += chr;
			}
			
			return str;
		}
		
		public function close():void
		{
		}

	}
}