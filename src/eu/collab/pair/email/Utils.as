package eu.collab.pair.email
{
	/**
	 * Miscellaneous utilities.
	 */	
	public class Utils
	{
		public static const COMMASPACE:String = ', ';
		public static const EMPTYSTRING:String = '';
		public static const CRLF:String = '\r\n';
		public static const TICK:String = "'";
		
		public var specialsre:RegExp = new RegExp('[][\\()<>@,:;".]');
		public var escapesre:RegExp = new RegExp('[][\\()"]');

		public function Utils()
		{
		}

		private function identity(s:String):String
		{
			return s;
		}
		
		private function bdecode(s:String):String
		{
			return s
		}
		
		private function fix_eols(s:String):String
		{
			return s
		}
		
		/**
		 * The inverse of parseaddr(), this takes an Array of the form
	     * [realname, email_address] and returns the string value suitable
	     * for an RFC 2822 From, To or Cc header.
		 * 
	     * If the first element of pair is false, then the second element is
	     * returned unmodified.
	     *  
		 * @param pair
		 * @return 
		 */		
		public function formatAddress(pair:Array):String
		{
			return '';
		}
		
		public function getAddresses(fieldvalues:Array):void
		{
			
		}
		
		/**
		 * Returns a date string as specified by RFC 2822, e.g.:
		 *
	     * <p>Fri, 09 Nov 2001 01:08:47 -0000</p>
		 * 
	     * <p>Optional timeval if given is a floating point time value as accepted by
	     * gmtime() and localtime(), otherwise the current time is used.</p>
		 * 
	     * <p>Optional localtime is a flag that when True, interprets timeval, and
	     * returns a date relative to the local timezone instead of UTC, properly
	     * taking daylight savings time into account.</p>
		 *
	     * <p>Optional argument usegmt means that the timezone is written out as
	     * an ascii string, not numeric one (so "GMT" instead of "+0000"). This
	     * is needed for HTTP, and is only used when localtime==false.</p>
	     * 
		 * @param timeval
		 * @param localTime
		 * @param usegmt
		 * @return 
		 */		
		public static function formatDate(timeval:String=null, localTime:Boolean=false,
								   usegmt:Boolean=false):String
		{
			return '';	
		}
		
		public function makeMsgId(idString:String=null):String
		{
			return '';	
		}
		
		public static function parseAddress(address:String):String
		{
			return '';
		}
		
	}
}