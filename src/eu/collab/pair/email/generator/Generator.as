/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.generator
{
	import eu.collab.pair.email.Message;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	/**
	 * Generates output from a Message object tree.
	 * 
     * <p>This basic generator writes the message to the given file object as plain
     * text.</p>
	 */	
	public class Generator
	{
		private var _fp:ByteArray;
		private var _mangleFrom:Boolean;
		private var _maxHeaderLen:int;
	
		/**
		 * Create the generator for message flattening.
         * 
         * <p>outfp is the output file-like object for writing the message to.  It
		 * must have a write() method.</p>
		 * 
	     * <p>Optional mangleFrom is a flag that, when true (the default), escapes
         * From_ lines in the body of the message by putting a `>' in front of
         * them.</p>
		 * 
         * <p>Optional maxHeaderLen specifies the longest length for a non-continued
         * header.  When a header line is longer (in characters, with tabs
         * expanded to 8 spaces) than maxHeaderLen, the header will split as
         * defined in the Header class.  Set maxHeaderLen to zero to disable
         * header wrapping.  The default is 78, as recommended (but not required)
         * by RFC 2822.</p>
         * 
		 * @param outfp
		 * @param mangleFrom
		 * @param maxHeaderLen
		 */		
		public function Generator(outfp:ByteArray, mangleFrom:Boolean=true, 
								  maxHeaderLen:int=78)
		{
			this._fp = outfp;
			this._mangleFrom = mangleFrom;
			this._maxHeaderLen = maxHeaderLen;
		}
		
		/**
		 * @param s
		 */		
		public function write(s:String):void
		{
			// delegate to the file object
			this._fp.writeMultiByte(s, File.systemCharset);
		}
		
		/**
		 * Print the message object tree rooted at msg to the output file
         * specified when the Generator instance was created.
		 * 
         * <p>unixfrom is a flag that forces the printing of a Unix From_ delimiter
         * before the first object in the message tree.  If the original message
         * has no From_ delimiter, a `standard' one is crafted.  By default, this
         * is False to inhibit the printing of any From_ delimiter.</p>
		 * 
         * <p>Note that for subobjects, no From_ line is printed.</p>
         * 
		 * @param msg
		 * @param unixFrom
		 */		
		public function flatten(msg:Message, unixFrom:Boolean=false):void
		{
			
		}

	}
}