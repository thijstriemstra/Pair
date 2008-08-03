/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.log.FileHandler;
	import eu.collab.pair.log.LogRecord;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.FileMode;

	/**
	 * Base class for handlers that rotate log files at a certain point.
	 * 
     * <p>Not meant to be instantiated directly. Instead, use RotatingFileHandler
     * or TimedRotatingFileHandler.</p>
     * 
     * @see eu.collab.pair.RotatingFileHandler RotatingFileHandler
     * @see eu.collab.pair.TimedRotatingFileHandler TimedRotatingFileHandler
	 */	
	public class BaseRotatingHandler extends FileHandler
	{
		public var backupCount:int;
		
		/**
		 * @param fileName
		 * @param mode
		 * @param encoding
		 */		
		public function BaseRotatingHandler(fileName:String,
											mode:String=FileMode.APPEND, 
											encoding:String=null)
		{
			this.mode = mode;
			this.encoding = encoding;
			
			super(fileName, mode, encoding);
		}
		
		/**
		 * Emit a record.
		 * 
         * <p>Output the record to the file, catering for rollover as described
         * in doRollover().</p>
         * 
		 * @param record
		 */		
		override public function emit(record:LogRecord):void
		{
			try {
	            if (this.shouldRollover(record)) {
	                this.doRollover();
	            }
	            super.emit(record);
	            
	  		} catch (e:*) {
	            handleError(e, record);
	   	 	}
		}
		
		/**
		 * Determine if rollover should occur.
		 *  
		 * @param record
		 * @return 
		 */		
		public function shouldRollover(record:LogRecord):Boolean
		{
			throw new IllegalOperationError('override in subclass');
		}
		
		/**
		 * Do a rollover.
		 */		
		public function doRollover():void
		{
			throw new IllegalOperationError('override in subclass');
		}
		
	}
}