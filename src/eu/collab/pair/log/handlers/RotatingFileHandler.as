/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.OS;
	import eu.collab.pair.log.LogRecord;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * Handler for logging to a set of files, which switches from one file
     * to the next when the current file reaches a certain size.
	 */	
	public class RotatingFileHandler extends BaseRotatingHandler
	{
		public var maxBytes:	int;
		
		/**
		 * Open the specified file and use it as the stream for logging.
		 * 
         * <p>By default, the file grows indefinitely. You can specify particular
         * values of maxBytes and backupCount to allow the file to rollover at
         * a predetermined size.</p>
		 * 
         * <p>Rollover occurs whenever the current log file is nearly maxBytes in
         * length. If backupCount is >= 1, the system will successively create
         * new files with the same pathname as the base file, but with extensions
         * ".1", ".2" etc. appended to it. For example, with a backupCount of 5
         * and a base file name of "app.log", you would get "app.log",
         * "app.log.1", "app.log.2", ... through to "app.log.5".</p>
         * 
         * <p>The file being written to is always "app.log" - when it gets 
         * filled up, it is closed and renamed to "app.log.1", and if files 
         * "app.log.1", "app.log.2" etc. exist, then they are renamed to 
         * "app.log.2", "app.log.3" etc. respectively.</p>
		 * 
         * <p>If maxBytes is zero, rollover never occurs.</p>
         * 
		 * @param fileName
		 * @param mode
		 * @param maxBytes
		 * @param backupCount
		 * @param encoding
		 */		
		public function RotatingFileHandler(fileName:String, 
											mode:String=FileMode.APPEND, 
											maxBytes:int=0,
											backupCount:int=0, 
											encoding:String=null)
		{
			if (maxBytes > 0) {
				mode = FileMode.APPEND;
			}

			super(fileName, mode, encoding);
			
			this.maxBytes = maxBytes;
			this.backupCount = backupCount;
		}
		
		/**
		 * Do a rollover, as described in the constructor.
		 */		
		override public function doRollover():void
		{
			stream.close();
			
			if (backupCount > 0) {
				for (var i:int=backupCount-1;i>0;i--) {
					var sfn:String = baseFileName + '.' + i.toString();
					var dfn:String = baseFileName + '.' + String(i+1);
					
					if (OS.path.exists(sfn)) {
						//trace(sfn + " -> " + dfn);
						
						if (OS.path.exists(dfn)) {
							OS.remove(dfn);
						}
						
						OS.rename(sfn, dfn);
					}
				}
				
				dfn = baseFileName + '.1';
				
				if (OS.path.exists(dfn)) {
					OS.remove(dfn);
				}
				OS.rename(baseFileName, dfn);
				
				//trace("Rotated " + baseFileName + " -> " + dfn);
			}
			
			stream.open(new File(baseFileName), FileMode.WRITE);
		}
		
		/**
		 * Determine if rollover should occur.
		 * 
         * <p>Basically, see if the supplied record would cause the file to exceed
         * the size limit we have.</p>
         * 
		 * @param record
		 * @return true or false
		 */		
		override public function shouldRollover(record:LogRecord):Boolean
		{
			if (maxBytes > 0) {
	            var msg:String = format(record) + "\n";

	            if ((stream.position + msg.length) >= maxBytes) {
	                return true;
	            }
	  		}
	  		
	        return false;
		}
		
	}
}