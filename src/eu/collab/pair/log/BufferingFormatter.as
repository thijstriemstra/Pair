/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * A formatter suitable for formatting multiple messages in a batch.
	 * 
	 * <p>In addition to the format string (which is applied to each 
	 * message in the batch), there is provision for header and trailer 
	 * format strings.</p>
	 */	
	public class BufferingFormatter
	{
		public var linefmt:Formatter;
		
		/**
		 * Optionally specify a formatter which will be used to format each
         * individual record.
         * 
		 * @param linefmt
		 */		
		public function BufferingFormatter(linefmt:Formatter=null)
		{
			if (linefmt) {
            	this.linefmt = linefmt
   			} else {
            	this.linefmt = new Formatter();
      		}
		}
		
		/**
		 * Return the header string for the specified records.
		 * 
		 * @param records
		 */		
		public function formatHeader(records:Array):String
		{
			return '';
		}
		
		/**
		 * Return the footer string for the specified records.
		 * 
		 * @param records
		 */		
		public function formatFooter(records:Array):String
		{
			return '';
		}
		
		/**
		 * Format the specified records and return the result as a string.
		 * 
		 * @param records
		 */		
		public function format(records:Array):String
		{
			var rv:String = "";
			
	        if (records.length > 0) {
	            rv = rv + formatHeader(records);
	            for (var d:int=0;d<records.length;d++) {
	            	var record:LogRecord = records[d];
	                rv = rv + this.linefmt.format(record);
	            }
	            rv = rv + formatFooter(records);
	        }
	        
	        return rv;
		}

	}
}