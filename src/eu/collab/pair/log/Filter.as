/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * Filter instances are used to perform arbitrary filtering of 
	 * LogRecords.
	 * 
	 * <p>Loggers and Handlers can optionally use Filter instances to filter
     * records as desired. The base filter class only allows events which are
     * below a certain point in the logger hierarchy. For example, a filter
     * initialized with "A.B" will allow events logged by loggers "A.B",
     * "A.B.C", "A.B.C.D", "A.B.D" etc. but not "A.BB", "B.A.B" etc. If
     * initialized with the empty string, all events are passed.</p>
     * 
	 * @see eu.collab.pair.log.LogRecord LogRecord
	 * @see eu.collab.pair.log.Logger Logger
	 * @see eu.collab.pair.log.Handler Handler
	 */	
	public class Filter
	{
		public var name:	String;
		public var nlen:	int;
		
		/**
		 * Initialize a filter.
		 * 
		 * <p>Initialize with the name of the logger which, together with its
         * children, will have its events allowed through the filter. If no
         * name is specified, allow every event.</p>
         * 
		 * @param name
		 */		
		public function Filter(name:String='')
		{
			this.name = name;
			this.nlen = name.length;
		}
		
		/**
		 * Determine if the specified record is to be logged.
		 * 
		 * <p>Is the specified record to be logged? Returns 0 for no, nonzero for
         * yes. If deemed appropriate, the record may be modified in-place.</p>
         * 
		 * @param record
		 * @return 
		 */
		public function filter(record:LogRecord):int
		{
			if (nlen == 0) {
				return 1;
			}
			else if (name == record.name)
			{
				return 1;
			}
			else if(record.name.substr(0, nlen).indexOf(name) > -1)
			{
				return 0;
			}
			
			return int(record.name[nlen] == '.');
		}

	}
}