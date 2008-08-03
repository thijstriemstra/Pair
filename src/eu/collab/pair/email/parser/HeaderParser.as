/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.parser
{
	public class HeaderParser extends Parser
	{
		public function HeaderParser()
		{
			super();
		}
		
		public static function parse(fp:*, headersOnly:Boolean=true):*
		{
			return Parser.parse(fp, true);
		}
		
		public static function parsestr(text:String, headersOnly:Boolean=true):*
		{
			return Parser.parsestr(text, true);
		}
		
	}
}