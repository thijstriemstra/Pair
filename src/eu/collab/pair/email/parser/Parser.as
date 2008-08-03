/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.parser
{
	import eu.collab.pair.email.feedparser.FeedParser;
	
	/**
	 * A parser of RFC 2822 and MIME email messages. 
	 */	
	public class Parser
	{
		/**
		 * Parser of RFC 2822 and MIME email messages.
		 *
         * <p>Creates an in-memory object tree representing the email message, which
         * can then be manipulated and turned over to a Generator to return the
         * textual representation of the message.</p>
		 * 
         * <p>The string must be formatted as a block of RFC 2822 headers and header
         * continuation lines, optionally preceeded by a `Unix-from' header.  The
         * header block is terminated either by the end of the string or by a
         * blank line.</p>
		 * 
  		 * <p>_class is the class to instantiate for new message objects when they
         * must be created.  This class must have a constructor that can take
         * zero arguments.  Default is Message.Message.</p>
		 */		
		public function Parser()
		{
		}
		
		/**
		 * Create a message structure from the data in a file.
		 * 
         * <p>Reads all the data from the file and returns the root of the message
         * structure.  Optional headersonly is a flag specifying whether to stop
         * parsing after reading the headers or not.  The default is false,
         * meaning it parses the entire contents of the file.</p>
         *  
		 * @param fp
		 * @param headersOnly
		 * @return 
		 */		
		public static function parse(fp:*, headersOnly:Boolean=false):*
		{
			var feedparser:FeedParser = new FeedParser(_class);
			
			if (headersOnly) {
				
			}
			
			while (true) {
				data = fp.read(8192);
				if (data == null) {
					break;
				}
				feedparser.feed(data);
			}
			
			return feedparser.close();
		}
		
		/**
		 * Create a message structure from a string.
		 * 
         * <p>Returns the root of the message structure.  Optional headersonly is a
         * flag specifying whether to stop parsing after reading the headers or
         * not.  The default is false, meaning it parses the entire contents of
         * the file.</p>
         * 
		 * @param text
		 * @param headersOnly
		 * @return 
		 */		
		public static function parsestr(text:String, headersOnly:Boolean=false):*
		{
			return parse(new StringIO(text), headersOnly);
		}

	}
}