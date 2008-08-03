/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email
{
	import eu.collab.pair.email.generator.Generator;
	
	import flash.utils.ByteArray;
	
	/**
	 * Basic message object for the email package object model. 
	 */	
	public class Message
	{
		public static const SEMISPACE:String = '; ';
		
		public var preamble:String;
		public var epilogue:String;
		public var defects:Array;
		
		private var _headers:Array;
		private var _unixFrom:Boolean;
		private var _payload:Array;
		private var _charset:String;
		private var _defaultType:String;
		
		/**
		 * Basic message object.
		 * 
		 * A message object is defined as something that has a bunch of RFC 2822
    	 * headers and a payload.  It may optionally have an envelope header
    	 * (a.k.a. Unix-From or From_ header).  If the message is a container (i.e. a
    	 * multipart or a message/rfc822), then the payload is a list of Message
    	 * objects, otherwise it is a string.

    	 * Message objects implement part of the `mapping' interface, which assumes
    	 * there is exactly one occurrance of the header per message.  Some headers
    	 * do in fact appear multiple times (e.g. Received) and for those headers,
    	 * you must use the explicit API to set or get all the headers.  Not all of
    	 * the mapping methods are implemented.
		 */		
		public function Message()
		{
			this._headers = new Array();
			this.defects = new Array();
			this._defaultType = 'text/plain';
		}
		
		/**
		 * Return the entire formatted message as a string.
         * This includes the headers, body, and envelope header.
         * 
		 * @return 
		 */		
		public function toString():String
		{
			return asString(true);
		}
	
		/**
		 * Return the entire formatted message as a string.
         * Optional `unixfrom' when True, means include the Unix From_ envelope
         * header.
		 * 
         * This is a convenience method and may not generate the message exactly
         * as you intend because by default it mangles lines that begin with
         * "From ".  For more flexibility, use the flatten() method of a
         * Generator instance.
         * 
		 * @param unixFrom
		 * @return 
		 */		
		public function asString(unixFrom:Boolean=false):String
		{
			var fp:ByteArray = new ByteArray();
			var g:Generator = new Generator(fp);
			g.flatten(this, unixFrom);
			
			return fp.toString();
		}
		
		/**
		 * Return true if the message consists of multiple parts.
		 * 
		 * @return 
		 */		
		public function isMultiPart():Boolean
		{
			return _payload is Array;
		}
		
		public function set unixFrom(unixFrom:Boolean):void
		{
			_unixFrom = unixFrom;
		}
		
		public function get unixFrom():Boolean
		{
			return _unixFrom;
		}
		
		public function getPayload(i:int=undefined, decode:Boolean=false):Array
		{
			return [];
		}
		
		/**
		 *  
		 * @param charset
		 */		
		public function setPayload(charset:String):void
		{
			
		}
		
		/**
		 * Set the charset of the payload to a given character set.
		 *
         * <p>charset can be a Charset instance, a string naming a character set, or
         * None.  If it is a string it will be converted to a Charset instance.
         * If charset is None, the charset parameter will be removed from the
         * Content-Type field.  Anything else will generate a TypeError.</p>
		 * 
         * <p>The message will be assumed to be of type text/* encoded with
         * charset.input_charset.  It will be converted to charset.output_charset
         * and encoded properly, if needed, when generating the plain text
         * representation of the message.  MIME headers (MIME-Version,
         * Content-Type, Content-Transfer-Encoding) will be added as needed.</p>
         *  
		 * @param charset
		 */		
		public function setCharset(charset:String):void
		{
			
		}
		
		/**
		 * Return the Charset instance associated with the message's payload. 
		 */		
		public function getCharset():String
		{
			return this._charset;
		}
		
		/**
		 * Add the given payload to the current payload.
		 * 
         * <p>The current payload will always be a list of objects after this method
         * is called.  If you want to set the payload to a scalar object, use
         * set_payload() instead.</p>
         * 
		 * @param payload
		 */		
		public function attach(payload:int):void
		{
			if (_payload == null) {
				_payload = [payload];
			} else {
				_payload.push(payload);
			}
		}
		
	}
}