/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	/**
	 * Constants/functions for interpreting results of os.stat() and os.lstat(). 
	 */	
	public class Stat
	{
		// Indices for stat struct members in tuple returned by os.stat()
		public static var ST_MODE:int = 0
		public static var ST_INO:int = 1
		public static var ST_DEV:int = 2
		public static var ST_NLINK:int = 3
		public static var ST_UID:int = 4
		public static var ST_GID:int = 5
		public static var ST_SIZE:int = 6
		public static var ST_ATIME:int = 7
		public static var ST_MTIME:int = 8
		public static var ST_CTIME:int = 9

		public function Stat()
		{
		}

	}
}