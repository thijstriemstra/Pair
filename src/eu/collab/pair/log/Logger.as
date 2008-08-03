/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * Instances of the Logger class represent a single logging channel.
	 * 
	 * <p>A "logging channel" indicates an area of an application. Exactly how an
     * "area" is defined is up to the application developer. Since an
     * application can have any number of areas, logging channels are identified
     * by a unique string.</p>
     * 
     * <p>Application areas can be nested (e.g. an area
     * of "input processing" might include sub-areas "read CSV files", "read
     * XLS files" and "read Gnumeric files"). To cater for this natural nesting,
     * channel names are organized into a namespace hierarchy where levels are
     * separated by periods, much like the Java or Python package namespace.</p> 
     * 
     * <p>So in the instance given above, channel names might be "input" for the 
     * upper level, and "input.csv", "input.xls" and "input.gnu" for the sub-levels.
     * </p><p>There is no arbitrary limit to the depth of nesting.</p>
	 */	
	public class Logger extends Filterer
	{
		public var name:		String;
		public var level:		*;
		public var parent:		Logger;
		public var propagate:	int;
		public var handlers:	Array;
		public var disabled:	int;
		
		public var manager: 	Manager = Manager.getInstance();
		
		/**
		 * Initialize the logger with a name and an optional level.
		 *  
		 * @param name
		 * @param level
		 */		
		public function Logger(name:String=null, level:*=null)
		{
			super();
			
			if (level == null) {
				level = Logging.NOTSET;
			}
			this.name = name;
		    this.level = level;
		    this.propagate = 1;
		    this.handlers = [];
		    this.disabled = 0;
		}
		
		/**
		 * Set the logging level of this logger.
		 *  
		 * @param level
		 * @return 
		 */		
		public function setLevel(level:*):void
		{
			this.level = level;
		}

	    /**
	     * Log 'msg % args' with severity 'DEBUG'.
		 *
	     * @example logger.debug("Houston, we have a %s", "thorny problem")
	     * 
	     * @param msg
	     * @param args
	     */		
	    public function debug(msg:String, ...args:Array):void
	    {
	        if (isEnabledFor(Logging.DEBUG)) {
	            _log(Logging.DEBUG, msg, args);
	        }
	    }
	    
	    /**
	     * Log 'msg % args' with severity 'INFO'.
		 *
	     * @example logger.info("Houston, we have a %s", "interesting problem") 
	     * 
	     * @param msg
	     * @param args
	     */	    
	    public function info(msg:String, ...args:Array):void
		{
	        if (isEnabledFor(Logging.INFO)){
	            _log(Logging.INFO, msg, args);
	        }
	 	}
	 	
		/**
	     * Log 'msg % args' with severity 'WARNING'.
		 *
	     * @example logger.warning("Houston, we have a %s", "bit of a problem") 
	     * 
	     * @param msg
	     * @param args
	     */	
	    public function warning(msg:String, ...args:Array):void
	    {
	        if (isEnabledFor(Logging.WARNING)) {
	            _log(Logging.WARNING, msg, args);
	        }
	    }
	    
	    /**
	     * Alias for the warn() method.
	     * 
	     * @param msg
	     * @param args
	     * @see eu.collab.pair.log.Logger.warn() warn()
	     */	    
	    public function warn(msg:String, ...args:Array):void {
	    	warning(msg, args);
	    }
	    
		/**
	     * Log 'msg % args' with severity 'ERROR'.
		 *
	     * @example logger.error("Houston, we have a %s", "major problem") 
	     * 
	     * @param msg
	     * @param args
	     */	
	    public function error(msg:String, ...args:Array):void
	    {
	        if (isEnabledFor(Logging.ERROR)) {
	            _log(Logging.ERROR, msg, args);
	        }
	    }
	    
	    /**
	     * Convenience method for logging an ERROR with exception information.
	     * 
	     * @param msg
	     * @param args
	     */	    
	    public function exception(msg:String, ...args:Array):void
	    {
	    	// TODO
	        error(msg, args, {'exc_info': 1});
	    }
		
		/**
	     * Log 'msg % args' with severity 'CRITICAL'.
		 *
	     * @example logger.critical("Houston, we have a %s", "major disaster") 
	     * 
	     * @param msg
	     * @param args
	     */
	    public function critical(msg:String, ...args:Array):void
	    {
	        if (isEnabledFor(Logging.CRITICAL)) {
	            _log(Logging.CRITICAL, msg, args);
	        }
	    }
	    
	    /**
	     * Log 'msg % args' with the integer severity 'level'.
	     * 
	     * @example logger.log(level, "We have a %s", "mysterious problem")
	     * 
	     * @param level
	     * @param msg
	     * @param args
	     */		
	    public function log(level:int, msg:String, ...args:Array):void
	    {
	        if (isEnabledFor(level)) {
	            _log(level, msg, args);
	        }
	    }
	       
	    /**
	     * Find the stack frame of the caller so that we can note the source
         * file name, line number and function name.
         * 
	     * @return 
	     */	    
	    public function findCaller():Array
	    {
	    	// TODO
	    	//f = currentframe().f_back
	        var rv:Array = ["(unknown file)", 0, "(unknown function)"]
	        
	        /*
	        while hasattr(f, "f_code"):
	            co = f.f_code
	            filename = OS.path.normcase(co.co_filename)
	            if filename == _srcfile:
	                f = f.f_back
	                continue
	            rv = [filename, f.f_lineno, co.co_name]
	            break;*/
	            
	        return rv
	    }
        
	    /**
	     * A factory method which can be overridden in subclasses to create
	     * specialized LogRecords.
	     * 
	     * @param name
	     * @param level
	     * @param fn
	     * @param lno
	     * @param msg
	     * @param args
	     * @param exc_info
	     * @param func
	     */	    
	    public function makeRecord(name:String, level:*, fn:String, lno:int, 
	    						   msg:String, args:Array, exc_info:*,
	    						   func:*=null):LogRecord
	    {
	        var rv:LogRecord = new LogRecord(name, level, fn, lno, msg, args, 
	        							 	 exc_info, func);
	        
	        return rv;
	    }
	
	    /**
	     * Low-level logging routine which creates a LogRecord and then calls
	     * all the handlers of this logger to handle the record.
	     * 
	     * @param level
	     * @param msg
	     * @param args
	     * @param exc_info
	     */		
	    private function _log(level:int, msg:String, args:Array, 
	    					  exc_info:*=null):void
	    {
	    	var c:Array = findCaller();
        	var fn:String = c[0];
	    	var lno:int = c[1];
	    	var func:String = c[2];
	        
	        // TODO
	        /*
	        if (exc_info) {
	            if (type(exc_info) != types.TupleType) {
	                exc_info = sys.exc_info();
	            }
	        }
	        */
	        
	        args = args.toString().split(',');
	        
	        var record:LogRecord = makeRecord(name, level, fn, lno, msg, args, 
	        								  exc_info, func);
	        handle(record);
	    }
	
	    /**
	     * Call the handlers for the specified record.
		 *
	     * <p>This method is used for unpickled records received from a socket, as
	     * well as those created locally. Logger-level filtering is applied.</p>
	     * 
	     * @param record
	     */		
	    public function handle(record:LogRecord):void
	    {
	        if (!disabled && filter(record)) {
	            callHandlers(record);
	        }
	    }
	
	    /**
	     * Add the specified handler to this logger.
	     *  
	     * @param hdlr
	     */		
	    public function addHandler(hdlr:Handler):void
	    {
	    	var found:Boolean = false;
	    	
	    	for (var s:int=0;s<handlers.length;s++) {
	    		if (handlers[s] == hdlr) {
	    			found = true;
	    			break;
	    		}
	    	}
	        if (!found) {
	        	handlers.push(hdlr);
	        }
	    }
	
	    /**
	     * Remove the specified handler from this logger.
	     *  
	     * @param hdlr
	     */		
	    public function removeHandler(hdlr:Handler):void
	    {
	    	var found:Boolean = false;
	    	
	    	for (var s:int=0;s<handlers.length;s++) {
	    		if (hdlr == handlers[s]) {
	    			found = true;
	    			break;
	    		}
	    	}
	    	
	    	if (found) {
	    		hdlr.close()
	            handlers.splice(s, 1); 
	    	}
	    }
	
	    /**
	     * Pass a record to all relevant handlers.
		 * 
	     * <p>Loop through all handlers for this logger and its parents in the
	     * logger hierarchy. If no handler was found, output a one-off error
	     * message to Sys.StdErr. Stop searching up the hierarchy whenever a
	     * logger with the "propagate" attribute set to zero is found - that
	     * will be the last logger whose handlers are called.</p>
	     * 
	     * @param record
	     */		
	    public function callHandlers(record:LogRecord):void
	    {
	        var c:Logger = this;
	        var found:int = 0;
	        
	       	while (c) {
	       		for (var f:int=0;f<c.handlers.length;f++) {
	       			found = found + 1;
	       			if (record.levelno >= c.handlers[f].level) {
	       				c.handlers[f].handle(record);
	       			}
	       		}
	            
	            if (!c.propagate) {
	            	// break out
	                c = null;
	            } else {
	                c = c.parent;
	            }
	        }
	        
	        if (found == 0 && manager.emittedNoHandlerWarning == 0) {
	            trace("No handlers could be found for logger \"" + name + "\"\n");
	           	
	           	manager.emittedNoHandlerWarning = 1;
	        }
	    }
	
	    /**
	     * Get the effective level for this logger.
		 * 
	     * <p>Loop through this logger and its parents in the logger hierarchy,
	     * looking for a non-zero logging level. Return the first one found.</p>
	     * 
	     * @return Level
	     */		
	    public function getEffectiveLevel():*
	    {
	        var logger:Logger = this;
	        
	        while (logger) {
	            if (logger.level) {
	                return logger.level;
	            }
	            logger = logger.parent;
	    	}
	        
	        return Logging.NOTSET;
	    }
	
	    /**
	     * Is this logger enabled for level 'level'?
	     *  
	     * @param level
	     * @return true or false
	     */		
	    public function isEnabledFor(level:*):Boolean
	    {
	        if (this.manager.disable >= level) {
	        	return false;
	        }
	        
	        return level >= this.getEffectiveLevel();
	    }
		
	}
}