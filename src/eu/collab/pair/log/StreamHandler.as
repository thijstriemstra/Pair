/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	import eu.collab.pair.sys.StdErr;
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	/**
	 * A handler class which writes logging records, appropriately formatted,
     * to a file stream. <p>Note that this class does not close the stream, as
     * Sys.StdOut or Sys.StdErr may be used.
	 */	
	public class StreamHandler extends Handler
	{
		public var stream:		FileStream;
		public var encoding:	String = File.systemCharset;
		
		/**
		 * Initialize the handler.
		 * 
		 * <p>If strm is not specified, Sys.StdErr is used.</p>
		 * 
		 * @param strm
		 */		
		public function StreamHandler(strm:FileStream=null)
		{
			super();
			
			if (strm == null) {
	            strm = new StdErr();
	  		}
	  		
	        stream = strm;
	        formatter = null;
		}
		
		/**
		 * Flush the internal buffer.
		 * 
		 * <p>This may be a no-op on some file-like objects.</p>
		 */		
		override public function flush():void
		{
		}
		
		/**
		 * Emit a record.
		 * 
	     * <p>If a formatter is specified, it is used to format the record.
	     * The record is then written to the stream with a trailing newline.
	     * 
		 * @param record
		 */		
		override public function emit(record:LogRecord):void
		{
			var msg:String = format(record);
			
			try
			{
				stream.writeMultiByte(msg + '\n', encoding);
			} 
			catch (e:IOError)
			{
				// cannot write to the file (for example, because the 
				// file is missing).
				handleError(e, record);
			}
			
			flush();
		}
		
	}
}