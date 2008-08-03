/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.log.Handler;

	/**
	 * A class which sends records to a Web server, using either GET or
     * POST semantics.
	 */	
	public class HTTPHandler extends Handler
	{
		public var host:String;
		public var url:String;
		public var method:String;
		
		/**
		 * Initialize the instance with the host, the request URL, and the method
         * ("GET" or "POST")
         * 
		 * @param host
		 * @param url
		 * @param method
		 */		
		public function HTTPHandler(host:String, url:String, method:String="GET")
		{
			super();
		}
		
	}
}