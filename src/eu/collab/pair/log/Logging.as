/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * Logging package for Actionscript 3. 
	 * 
	 * <p>Based on the logging package in Python.</p>
	 */
	public class Logging
	{
		static private var _instance:Logging;
		
		public function Logging(singletonEnforcer:SingletonEnforcer) {}
		
		public static function getInstance():Logging
		{
			if (Logging._instance == null) {
				Logging._instance = new Logging(new SingletonEnforcer());
			}
			
			return Logging._instance;
		}

		// Default levels and level names, these can be replaced with any positive set
		// of values having corresponding names. There is a pseudo-level, NOTSET, which
		// is only really there as a lower limit for user-defined levels. Handlers and
		// loggers are initialized with NOTSET so that they will log all messages, even
		// at user-defined levels.

		public static var CRITICAL:int 	= 50;
		public static var FATAL:int 	= CRITICAL;
		public static var ERROR:int 	= 40;
		public static var WARNING:int 	= 30;
		public static var WARN:int 		= WARNING;
		public static var INFO:int 		= 20;
		public static var DEBUG:int 	= 10;
		public static var NOTSET:int 	= 0;

		public static var BASIC_FORMAT:String = "%(levelname)s:%(name)s:%(message)s";
		
		private static var _levelNames:Object =
		{
		    '50': 		'CRITICAL',
		    '40': 		'ERROR',
		    '30': 		'WARNING',
		    '20': 		'INFO',
		    '10': 		'DEBUG',
		    '0': 		'NOTSET',
		    'CRITICAL': CRITICAL,
		    'ERROR': 	ERROR,
		    'WARN': 	WARNING,
		    'WARNING': 	WARNING,
		    'INFO': 	INFO,
		    'DEBUG': 	DEBUG,
		    'NOTSET': 	NOTSET
		}
		
		private var _defaultFormatter:Formatter = new Formatter();
		
		/**
		 * Repository of handlers (for flushing when shutdown called) .
		 */		
		private var _handlers:Object = {};
		
		/**
		 * Added to allow handlers to be removed in reverse of order initialized .
		 */		
		private var _handlerList:Array = [];
		private var _loggerClass:Class = Logger;
		
		public static var root:Logger = new RootLogger(WARNING);
		
		/**
		 * Return a logger with the specified name, creating it if necessary.
		 * 
		 * <p>If no name is specified, return the root logger.</p>
		 * 
		 * @param name
		 * @return Logger
		 */		
		public static function getLogger(name:String=null):Logger
		{
			if (name != null) {
				return Manager.getInstance().getLogger(name);
			} else {
				return root;
			}
		}
		
		/**
		 * @return Levels and level names
		 */		
		public static function get levelNames():Object
		{
			return _levelNames;
		}
		
		/**
		 * Return the textual representation of logging level 'level'.
		 * 
	     * <p>If the level is one of the predefined levels (CRITICAL, ERROR, WARNING,
	     * INFO, DEBUG) then you get the corresponding string. If you have
	     * associated levels with names using addLevelName then the name you have
	     * associated with 'level' is returned.</p>
		 * 
	     * <p>If a numeric value corresponding to one of the defined levels is passed
	     * in, the corresponding string representation is returned.</p>
	     * 
		 * @param level integer or string
		 * @return 		integer or string
		 */		
		public static function getLevelName(level:*):*
		{
			return levelNames[level];
		}
		
		/**
		 * Do basic configuration for the logging system.
		 * 
	     * <p>This function does nothing if the root logger already has handlers
	     * configured. It is a convenience method intended for use by simple 
	     * scripts to do one-shot configuration of the logging package.</p>
		 *
	     * <p>The default behaviour is to create a StreamHandler which writes to
	     * Sys.StdErr, set a formatter using the <code>BASIC_FORMAT</code> format 
	     * string, and add the handler to the root logger.</p>
	     * 
		 * @param lvl		int or string
		 * @param format	log message format string
		 * @param datefmt	date format string
		 * @param filename	filename (absolute or relative)
		 * @param filemode	see FileMode
		 * @param stream	FileStream to write to
		 */		
		public function basicConfig(lvl:*=null, format:String=null, 
									datefmt:String=null, filename:String=null, 
									filemode:String='write', 
									stream:FileStream=null):void
		{
			if (root.handlers.length == 0) {
				var fname:String = filename;
				var hdlr:Handler;
				var fs:String;
				
				if (fname != null) {
					hdlr = new FileHandler(fname, filemode);
				} else {
					hdlr = new StreamHandler(stream);
				}
				
				if (format == null) {
					fs = BASIC_FORMAT;
				} else {
					fs = format;
				}
				
				var fmt:Formatter = new Formatter(fs, datefmt);
				hdlr.setFormatter(fmt);
				root.addHandler(hdlr);
				
				if (lvl != null) {
					root.setLevel(lvl);
				}
			}
		}
		
		/**
		 * Log a message with severity 'CRITICAL' on the root logger.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function critical(msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.critical(msg, args);
		}
		
		/**
		 * Log a message with severity 'ERROR' on the root logger.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function error(msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.error(msg, args);
		}
		
		/**
		 * Log a message with severity 'ERROR' on the root logger,
		 * with exception information.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function exception(msg:String, ...args:Array):void
		{
			root.error(msg, args);
		}
		
		/**
		 * Log a message with severity 'WARNING' on the root logger.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function warning(msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.warning(msg, args);
		}
		
		/**
		 * Log a message with severity 'INFO' on the root logger.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function info(msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.info(msg, args);
		}
		
		/**
		 * Log a message with severity 'DEBUG' on the root logger.
		 * 
		 * @param msg
		 * @param args
		 */		
		public function debug(msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.debug(msg, args);
		}
		
		/**
		 * Log 'msg % args' with the integer severity 'level' on 
		 * the root logger.
		 * 
		 * @param level
		 * @param msg
		 * @param args
		 */		
		public function log(level:*, msg:String, ...args:Array):void
		{
			if (root.handlers.length == 0) {
				basicConfig();
			}
			
			root.log(level, msg, args);
		}
		
		/**
		 * Disable all logging calls less severe than 'level'.
		 *  
		 * @param level
		 */		
		public function disable(level:*):void
		{
			root.manager.disable = level;
		}
		
		/**
		 * Perform any cleanup actions in the logging system.
		 * 
		 * <p>Should be called at application exit.</p>
		 * 
		 * @param handlerList
		 */		
		public function shutdown(handlerList:Array=null):void
		{
			if (handlerList == null) {
				handlerList = _handlerList;
			}
			
			for (var d:int=0;d<handlerList.length;d++) {
				var hdlr:Handler = handlerList[d];
				try {
					hdlr.flush();
					hdlr.close();
				} catch (e:*) {
					
				}
			}
		}
		
	}
}

class SingletonEnforcer {}