/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import eu.collab.pair.OS;
	
	/**
	 * A <em>LogRecord</em> instance represents an event being logged. 
	 * 
	 * <p>LogRecord instances are created every time something is logged. They
     * contain all the information pertinent to the event being logged. The
     * main information passed in is in msg and args, which are combined
     * using str(msg) % args to create the message field of the record. The
     * record also includes information such as when the record was created,
     * the source line where the logging call was made, and any exception
     * information to be logged.</p>
	 */
	public class LogRecord
	{
		public var name:			String;
		public var msg:				String;
		public var levelName:		*;
		public var args:			Array;
		public var levelno:			int;
		public var lineno:			int;
		public var funcName:		*;
		public var pathName:		String;
		public var fileName:		String;
		public var module:			String;
		public var created:			Date;
		public var msecs:			int;
		public var relativeCreated:	int;
		public var asctime:			String;
		
		/**
		 * This is used as the base when calculating the relative time 
		 * of events.
		 */		
		private var startTime:int = new Date().getTime();

		/**
		 * Initialize a logging record with interesting information.
		 *  
		 * @param name
		 * @param level
		 * @param pathName
		 * @param lineno
		 * @param msg
		 * @param args
		 * @param exc_info
		 * @param func
		 */		
		public function LogRecord(name:String, level:*, pathName:String, lineno:int,
								  msg:String, args:Array, exc_info:*, func:*=null)
		{
			this.name = name;
			this.msg = msg;
			this.args = args;
			this.levelName = Logging.getLevelName(level);
			this.levelno = level;
			this.pathName = pathName;
			this.fileName = OS.path.basename(pathName);
			this.module = OS.path.splitext(this.fileName)[0];
			this.lineno = lineno;
			this.funcName = func;
			this.created = new Date();
			this.msecs = created.getTime();
			this.relativeCreated = (msecs - startTime);
		}
		
		/**
		 * Return the message for this LogRecord.
		 *
		 * @return The message for this LogRecord after merging any user-supplied
         *  	   arguments with the message.
		 */		
		public function getMessage():String
		{
			var message:String = this.msg;
			var myPattern:RegExp = /%s/;
			
			if (args.length > 0) {
				for (var d:int=0;d<args.length;d++) {
			 		message = message.replace(myPattern, args[d]);
				}
			}
			
			return message;
		}
		
		public function toString():String
		{
			return '<LogRecord: ' + name + ', ' + Logging.levelNames[levelno] + 
					', ' + pathName + ', ' + pathName + ', ' + lineno + ', ' + 
					msg + ' />';
		}

	}
}