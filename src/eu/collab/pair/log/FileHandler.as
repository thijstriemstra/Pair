/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import eu.collab.pair.OS;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * A handler class which writes formatted logging records to disk 
	 * files.
	 */	
	public class FileHandler extends StreamHandler
	{
		/**
		 * Name of the file for the logging records.
		 */		
		public var baseFileName:	String;
		
		/**
		 * Capability available to the FileStream object once the file is 
		 * opened.
		 * 
		 * @see flash.filesystem.FileMode
		 */		
		public var mode:			String;

		/**
		 * Open the specified file and use it as the stream for logging.
		 *  
		 * @param fileName
		 * @param mode
		 * @param encoding
		 */		
		public function FileHandler(fileName:String, mode:String=FileMode.APPEND,
									encoding:String=null)
		{
			this.baseFileName = OS.path.abspath(fileName);
        	this.mode = mode;
        	
			stream = openStream();
            
            super(stream);
		}
		
		/**
		 * Closes the stream. 
		 */		
		override public function close():void
		{
			if (this.stream) {
				this.flush();
	            this.stream.close();
	            super.close();
			}
		}
		
		private function openStream():FileStream
		{
			var file:File = new File(this.baseFileName);
			var str:FileStream = new FileStream();
			
			try {
				str.open(file, mode);
			} catch (error:IllegalOperationError) {
				trace(error);
			    // Error #2037: Functions called in incorrect sequence, or earlier
			    // call was unsuccessful.
			}
			
			return str;
		}
		
	}
}