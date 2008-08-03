/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * There is (under normal circumstances) just one Manager instance, which
     * holds the hierarchy of loggers.
	 */	
	public class Manager
	{
        public var disable:					int;
        public var emittedNoHandlerWarning:	int;
        public var loggerDict:				Object;
        
        static private var _instance:		Manager;
        
		/**
		 * Initialize the manager with the root node of the logger hierarchy. 
		 * 
		 * @param rootnode Logger
		 */		
		public function Manager()
		{
			disable = 0;
			emittedNoHandlerWarning = 0;
			loggerDict = {};
		}
		
		public static function getInstance():Manager
		{
			if (Manager._instance == null) {
				Manager._instance = new Manager();
			}
			
			return Manager._instance;	
		}
		
		/**
		 * Get a logger with the specified name (channel name), creating it
         * if it doesn't yet exist. <p>This name is a dot-separated hierarchical
         * name, such as "a", "a.b", "a.b.c" or similar.</p>
		 *
         * <p>If a PlaceHolder existed for the specified name [i.e. the logger
         * didn't exist but a child of it did], replace it with the created
         * logger and fix up the parent/child references which pointed to the
         * placeholder to now point to the logger.</p>
         * 
		 * @param name
		 * @return 
		 */		
		public function getLogger(name:String):Logger
		{
			var rv:Logger;
			
			try {
	            if (loggerDict[name] != null) {
	                rv = loggerDict[name];
	                if (rv is PlaceHolder) {
	                    var ph:PlaceHolder = new PlaceHolder(rv);
	                    rv = new Logger(name);
	                    rv.manager = this;
	                    loggerDict[name] = rv;
	                    fixupChildren(ph, rv);
	                    fixupParents(rv);
	                }
	            } else {
	                rv = new Logger(name);
	                rv.manager = this;
	                loggerDict[name] = rv;
	                fixupParents(rv);
	            }
	  		} finally {
	    	}

	        return rv;
		}
		
	    /**
	     * Ensure that there are either loggers or placeholders all the way
	     * from the specified logger to the root of the logger hierarchy.
	     * 
	     * @param alogger
	     */		
	    private function fixupParents(alogger:Logger):void
	    {
	        var name:String = alogger.name;
	        var i:int = name.lastIndexOf(".")
	        var rv:Logger;
	        
	        while ((i > 0) && rv == null) {
	            var substr:String = name.substr(0, i);
	            if (!loggerDict.hasOwnProperty(substr)) {
	                loggerDict[substr] = new PlaceHolder(alogger);
	            } else {
	                var obj:* = loggerDict[substr]
	                if (obj is Logger) {
	                    rv = obj;
	                } else {
	                    //assert isinstance(obj, PlaceHolder)
	                    obj.append(alogger)
	                }
	            }
	            i = name.lastIndexOf(".", 0);
	        }
	        
	        if (rv == null) {
	            rv = Logging.root;
	        }
	        
	        alogger.parent = rv;
	    }
	
	    /**
	     * Ensure that children of the placeholder ph are connected to the
	     * specified logger.
	     * 
	     * @param ph
	     * @param alogger
	     * @return 
	     */		
	    private function fixupChildren(ph:PlaceHolder, alogger:Logger):void
	    {
	        var name:String = alogger.name;
	        var namelen:int = name.length;
	        
	        for (var c:* in ph.loggerMap) {
	            //The if means ... if not c.parent.name.startswith(nm)
	            //if string.find(c.parent.name, nm) <> 0:
	            if (c.parent.name.substr(0, namelen) != name) {
	                alogger.parent = c.parent
	                c.parent = alogger
	            }
	        }
	    }

	}
}

class SingletonEnforcer {}