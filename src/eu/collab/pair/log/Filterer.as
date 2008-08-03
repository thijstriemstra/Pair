/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * A base class for loggers and handlers which allows them to share
     * common code.
	 */	
	public class Filterer
	{
		public var filters:Array;
		
		/**
		 * Initialize the list of filters to be an empty list. 
		 */		
		public function Filterer()
		{
			filters = new Array();
		}
		
		/**
		 * Add the specified filter to this handler.
		 *  
		 * @param filter
		 */		
		public function addFilter(filter:Filter):void
		{
			var a:int = exists(filter)
			if (a == -1) {
				filters.push(filter);
			}
		}
		
		/**
		 * Remove the specified filter from this handler.
		 *  
		 * @param filter
		 */		
		public function removeFilter(filter:Filter):void
		{
			var a:int = exists(filter);
			filters.splice(a, 1);
		}
		
		/**
		 * Determine if a record is loggable by consulting all the filters.
		 * 
		 * <p>The default is to allow the record to be logged; any filter can veto
         * this and the record is then dropped. Returns a zero value if a record
         * is to be dropped, else non-zero.</p>
         * 
		 * @param record
		 * @return 
		 */		
		public function filter(record:LogRecord):int
		{
			var rv:int = 1;
			for (var s:int=0;s<filters.length;s++) {
				var f:Filter = filters[f];
				if (!f.filter(record)) {
					rv = 0;
					break;
				}
			}
			return rv;
		}
		
		private function exists(filter:Filter):int
		{
			var found:Boolean = false;
			
			for (var d:int=0;d<filters.length;d++) {
				if (filters[d] == filter) {
					found = true;
					break;
				}
			}
			
			if (found) {
				return d;
			} else {
				return -1;
			}
		}

	}
}