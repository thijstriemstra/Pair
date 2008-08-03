/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import eu.collab.pair.Time;
	
	/**
	 * Formatter instances are used to convert a LogRecord to text.
	 *
	 * <p>Formatters need to know how a LogRecord is constructed. They are
     * responsible for converting a LogRecord to (usually) a string which can
     * be interpreted by either a human or an external system. The base Formatter
     * allows a formatting string to be specified. If null is supplied, the
     * default value of "%s(message)\n" is used.</p>
	 *
     * <p>The Formatter can be initialized with a format string which makes use of
     * knowledge of the LogRecord attributes - e.g. the default value mentioned
     * above makes use of the fact that the user's message and arguments are pre-
     * formatted into a LogRecord's message attribute.</p> <p>Currently, the useful
     * attributes in a LogRecord are described by:</p>
	 *
     * <li>%(name)s            Name of the logger (logging channel)</li>
     * <li>%(levelno)s         Numeric logging level for the message (DEBUG, INFO,
     *                     WARNING, ERROR, CRITICAL)</li>
     * <li>%(levelname)s       Text logging level for the message ("DEBUG", "INFO",
     *                     "WARNING", "ERROR", "CRITICAL")</li>
     * <li>%(pathname)s        Full pathname of the source file where the logging
     *                     call was issued (if available)</li>
     * <li>%(filename)s        Filename portion of pathname</li>
     * <li>%(class)s          Class (name portion of filename)</li>
     * <li>%(lineno)d          Source line number where the logging call was issued
     *                     (if available)</li>
     * <li>%(funcName)s        Function name</li>
     * <li>%(created)f         Time when the LogRecord was created</li>
     * <li>%(asctime)s         Textual time when the LogRecord was created</li>
     * <li>%(msecs)d           Millisecond portion of the creation time</li>
     * <li>%(relativeCreated)d Time in milliseconds when the LogRecord was created,
     *                     relative to the time the logging module was loaded
     *                     (typically at application startup time)</li>
     * <li>%(message)s         The result of record.getMessage(), computed just as
     *                     the record is emitted</li>
     * 
     * status: TODO exceptions
	 */	
	public class Formatter
	{
		private var fmt:		String;
		private var datefmt:	String;

		/**
		 * Initialize the formatter with specified format strings.
		 *
         * <p>Initialize the formatter either with the specified format string, or a
         * default as described above. Allow for specialized date formatting with
         * the optional datefmt argument (if omitted, you get the ISO8601 format).</p>
         * 
		 * @param fmt
		 * @param datefmt
		 */		
		public function Formatter(fmt:String=null, datefmt:String=null)
		{
			if (fmt != null) {
            	this.fmt = fmt;
   			} else {
            	this.fmt = "%(message)s";
      		}
      		
        	this.datefmt = datefmt;
		}
		
		/**
		 * Return the creation time of the specified LogRecord as formatted text.
 		 * 
         * <p>This method should be called from format() by a formatter which
         * wants to make use of a formatted time. This method can be overridden
         * in formatters to provide for any specific requirement, but the
         * basic behaviour is as follows: if datefmt (a string) is specified,
         * it is used with Time.strftime() to format the creation time of the
         * record. Otherwise, the ISO8601 format is used. The resulting
         * string is returned. 
         * 
         * <p>This function uses a user-configurable function
         * to convert the creation time to a Date. By default, Date()
         * is used; to change this for a particular formatter instance, set the
         * 'converter' attribute to a function with the same signature as
         * the date methods. To change it for all formatters, for example if 
         * you want all logging times to be shown in GMT, set the 'converter' 
         * attribute in the Formatter class.</p>
         *  
		 * @param record
		 * @param datefmt
		 * @return Formatted string
		 * 
		 * @see eu.collab.pair.log.Formatter.format() Formatter.format()
		 * @see eu.collab.pair.Time.strftime() Time.strftime()
		 * @see http://www.dmoz.org/Science/Reference/Standards/Individual_Standards/ISO/ISO_8601/ IS08601
		 */		
		public function formatTime(record:LogRecord, datefmt:String=null):String
		{
			var s:String;
	        
	        if (datefmt != null) {
	            s = Time.strftime(datefmt, record.created);
	        } else {
	            var t:String = Time.strftime("%Y-%m-%d %H:%M:%S", record.created);
	            var ms:* = record.created.milliseconds;
	            if (ms < 100) {
	            	ms = '0' + Time.dig(ms).toString();
	            }
	            s = t + "," + ms;
	        }
	        
	        return s;
	 	}

    	/**
    	 * Format and return the specified exception information as a string.
		 *
         * <p>This default implementation just uses TODO</p>
         * 
    	 * @param ei Exception information as Array
    	 * @return   Exception information as String
    	*/		
    	public function formatException(ei:Array):String
    	{
    		// TODO
    		
	        //sio = cStringIO.StringIO();
	        //traceback.print_exception(ei[0], ei[1], ei[2], None, sio);
	        //s = sio.getvalue();
	        //sio.close();
	        
	        var s:String = ei.join(' - ');
	        
	        //if (s[-1:] == "\n") {
	        //    s = s[:-1]
	        //}
	         
	        return s;
	    }

    	/**
    	 * Format the specified record as text.
		 *
         * <p>Before formatting the record, a couple of preparatory steps
         * are carried out. The message attribute of the record is computed
         * using LogRecord.getMessage(). If the formatting string contains
         * "%(asctime)", formatTime() is called to format the event time.
         * If there is exception information, it is formatted using
         * formatException() and appended to the message.</p>
         * 
    	 * @param record
    	 * @see eu.collab.pair.log.LogRecord.getMessage() LogRecord.getMessage()
    	 */		
    	public function format(record:LogRecord):String
    	{
    		var s:String;
    		
	        record.msg = record.getMessage();
	        
	        var replacement_pairs:Array = [
					[record.name, '%(name)s'], [record.levelName, '%(levelname)s'],
                    [record.msg, '%(message)s'], [record.levelno, '%(levelno)s'],
                    [record.pathName, '%(pathname)s'], [record.fileName, '%(filename)s'],
                    [record.module, '%(module)s'], [record.funcName, '%(funcName)s'],
                    [record.lineno, '%(lineno)d'], [record.created, '%(created)s'],
                    [record.relativeCreated, '%(relativeCreated)d'],
                    [record.msecs, '%(msecs)s']
            ];
                    
	        if (this.fmt.indexOf("%(asctime)") >= -1) {
	            record.asctime = formatTime(record, this.datefmt);
	            replacement_pairs.push([record.asctime, '%(asctime)s']);
	        }

			s = this.fmt.slice();
			
			for (var v:int=0;v<replacement_pairs.length;v++) {
				s = s.replace(replacement_pairs[v][1], replacement_pairs[v][0]);
			}

			// TODO
	        //if (record.exc_info) {
	            // Cache the traceback text to avoid converting it multiple times
	            // (it's a constant anyway)
	            //if (record.exc_text == null) {
	                //record.exc_text = formatException(record.exc_info);
	            //}
	        //}
	        
	        /*if (record.exc_text != nulL) {
	            if (s.substr(s.length-2) != "\n") {
	                s = s + "\n";
	            }
	            s = s + record.exc_text;
	        }*/
	        
	        return s;
	    }

	}
}