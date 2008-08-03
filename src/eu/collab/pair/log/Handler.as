/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * Handler instances dispatch logging events to specific destinations.
	 * 
     * <p>The base handler class. Acts as a placeholder which defines the Handler
     * interface. Handlers can optionally use Formatter instances to format
     * records as desired.</p> <p>By default, no formatter is specified; in this case,
     * the 'raw' message, as determined by record.message, is logged.</p>
	 */	
	public class Handler extends Filterer
	{
		public var level:			int;
		public var formatter:		Formatter;
		
		private var _handlers:		Object;
		private var _handlerList:	Array;
		
		/**
		 * Initializes the instance - basically setting the formatter to null
         * and the filter list to empty.
         *  
		 * @param level
		 */
		public function Handler(level:*='NOTSET')
		{
			super();
			
			this.level = level;
			this.formatter = null;
			
			try {
				_handlers[this] = 1;
				_handlerList.unshift();
			} catch (e:TypeError) {
				//trace(e.toString());
			}
		}
		
		/**
		 * Set the logging level of this handler.
		 *  
		 * @param level
		 */		
		public function setLevel(level:int):void
		{
        	this.level = level;
		}
		
    	/**
    	 * Format the specified record.
		 * 
         * <p>If a formatter is set, use it. Otherwise, use the default formatter
         * for the class.</p>
         * 
    	 * @param record
    	 * @return 
    	 */		
    	public function format(record:LogRecord):String
    	{
    		var fmt:Formatter;
    		
	        if (this.formatter != null) {
	            fmt = this.formatter;
	        } else {
	            fmt = new Formatter();
	        }
	        
	        return fmt.format(record);
	    }

    	/**
    	 * Do whatever it takes to actually log the specified logging record.
		 *
         * <p>This version is intended to be implemented by subclasses and so
         * raises a IllegalOperationError.</p>
         * 
    	 * @param record
    	 * @return 
    	 */		
    	public function emit(record:LogRecord):void
    	{
	        throw new IllegalOperationError('emit must be implemented ' +
	                                    	'by Handler subclasses');
	    }
	
    	/**
    	 * Conditionally emit the specified logging record.
		 * 
         * <p>Emission depends on filters which may have been added to the 
         * handler.</p>
         * 
    	 * @param record
    	 * @return whether the filter passed the record for emission.
    	 */		
    	public function handle(record:LogRecord):int
		{
	        var rv:int = filter(record);
	        
	        if (rv) {
	            try {
	                emit(record);
	            } catch (e:*) {
	    		}
	        }
	        
	        return rv;
	 	}

    	/**
    	 * Set the formatter for this handler.
    	 *  
    	 * @param fmt
    	 */		
    	public function setFormatter(fmt:Formatter):void
    	{
        	this.formatter = fmt;
     	}

    	/**
    	 * Ensure all logging output has been flushed.
		 *
         * <p>This version does nothing and is intended to be implemented by
         * subclasses.</p>
    	 */		
    	public function flush():void
        {
        }

    	/**
    	 * Tidy up any resources used by the handler.
		 * 
         * <p>This version removes the handler from an internal list of handlers
         * which is closed when shutdown() is called.</p>
         * 
         * <p>Subclasses should ensure that this gets called from overridden close()
         * methods.</p>
    	 */		
    	public function close():void
    	{
            delete _handlers[this];
            
            for (var d:int=0;d<_handlerList.length;d++) {
            	if (_handlerList[d] == this) {
            		_handlerList.splice(d, 1);
            		break;
            	}
            }
	    }

    	/**
    	 * Handle errors which occur during an emit() call.
 		 * 
         * <p>This method should be called from handlers when an exception is
         * encountered during an emit() call. If raiseExceptions is false,
         * exceptions get silently ignored. This is what is mostly wanted
         * for a logging system - most users will not care about errors in
         * the logging system, they are more interested in application errors.
         * You could, however, replace this with a custom handler if you wish.</p>
         *  
    	 * @param record The record which was being processed
    	 */		
    	public function handleError(e:*, record:LogRecord):void
    	{
    		// TODO
    		// trace(e.toString() + '\n ' + record);
	        
	        /*
	        if raiseExceptions:
	            ei = sys.exc_info()
	            traceback.print_exception(ei[0], ei[1], ei[2], None, sys.stderr)
	            del ei
	        */
	    }
		
	}
}