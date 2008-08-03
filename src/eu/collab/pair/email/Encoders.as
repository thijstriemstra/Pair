package eu.collab.pair.email
{
	/**
	 * Encodings and related functions.
	 */	
	public class Encoders
	{
		/**
		 * Encode the message's payload in Base64.
		 * 
    	 * <p>Also, add an appropriate Content-Transfer-Encoding header.</p>
    	 *  
		 * @param msg
		 */		
		public static function encode_base64(msg:Message):void
		{
			var orig:Array = msg.getPayload();
			var encdata:Array = bencode(orig);
		}
		
		/**
		 * Encode the message's payload in quoted-printable.
		 * 
    	 * <p>Also, add an appropriate Content-Transfer-Encoding header.</p>
    	 *  
		 * @param msg
		 */		
		public static function encode_quopri(msg:Message):void
		{
			
		}

		/**
		 * Set the Content-Transfer-Encoding header to 7bit or 8bit.
		 *  
		 * @param msg
		 */		
		public static function encode_7or8bit(msg:Message):void
		{
			
		}

		/**
		 * Do nothing.
		 *  
		 * @param msg
		 */		
		public static function encode_noop(msg:Message):void
		{
		}	
		
		private static function bencode(s:Array):Array
		{
			return [];
		}
		
		private static function qencode(s:Array):Array
		{
			return [];
		}
		
	}
}