/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.sys
{
	import flash.filesystem.FileStream;

	/**
	 * Print messages to debugger console.
	 */	
	public class StdErr extends FileStream
	{
		public function StdErr()
		{
			super();
		}
		
		override public function writeMultiByte(value:String, charSet:String):void
		{
			trace(value.substr(0, value.length-1));
		}
		
	}
}