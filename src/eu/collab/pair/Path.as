/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	
	public class Path implements IPath
	{
		public var name:		String;
		
		/**
		 * The constant string used by the operating system to refer to 
		 * the current directory. 
		 * 
		 * <p>For example: '.' for POSIX or ':' for Mac OS 9. </p>
		 */		
		public var curdir:		String;
		
		/**
		 * The constant string used by the operating system to refer to 
		 * the parent directory.
		 * 
		 * <p>For example: '..' for POSIX or '::' for Mac OS 9.</p>
		 */		
		public var pardir:		String;
		
				
		public var extsep:		String;
		
		/**
		 * The character used by the operating system to separate pathname 
		 * components, for example, "/" for POSIX or ":" for Mac OS 9. 
		 * 
		 * <p>Note that knowing this is not sufficient to be able to parse 
		 * or concatenate pathnames -- use OS.path.split() and OS.path.join()
		 *  -- but it is occasionally useful.</p>
		 */
		public var sep:			String;
		
		/**
		 * The character which separates the base filename from the extension; 
		 * for example, the "." in OS.as. 
		 */		
		public var pathsep:		String;
		
		/**
		 * The default search path if the environment doesn't have a 'PATH' key.
		 */		
		public var defpath:		String;
		public var altsep:		String;
		public var devnull:		String;
		
		private static var sub:	String = 'Implement in subclass';
		
		public function isabs(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function join(a:String, ...p:Array):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function normcase(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		/**
		 * Split the pathname path into a pair, 
		 * (head, tail) where tail is the last 
		 * pathname component and head is everything 
		 * leading up to that.
		 * 
		 * @param path
		 * @return 
		 */		
		public function split(path:String):Array
		{
			throw new IllegalOperationError(sub);
		}
		
		public function splitext(path:String):Array
		{
			throw new IllegalOperationError(sub);
		}
		
		public function splitdrive(path:String):Array
		{
			throw new IllegalOperationError(sub);
		}
		
		public function basename(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function dirname(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function commonprefix(pathnames:Array):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function getsize(filename:String):int
		{
			throw new IllegalOperationError(sub);
		}
		
		public function getmtime(filename:String):int
		{
			throw new IllegalOperationError(sub);
		}
		
		public function getatime(filename:String):int
		{
			throw new IllegalOperationError(sub);
		}
		
		public function getctime(filename:String):int
		{
			throw new IllegalOperationError(sub);
		}
		
		public function islink(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		/**
		 * Return True if path refers to an existing path. 
		 * Returns False for broken symbolic links. <p>On 
		 * some platforms, this function may return False 
		 * if permission is not granted to execute OS.stat()
		 * on the requested file, even if the path physically 
		 * exists.</p>
		 * 
		 * @param path
		 * @return 
		 */		
		public function exists(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function lexists(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function isdir(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function isfile(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function samefile(f1:String, f2:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function samestat(s1:File, s2:File):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function ismount(path:String):Boolean
		{
			throw new IllegalOperationError(sub);
		}
		
		public function walk(top:String, func:Function, ...arg:Array):void
		{
			throw new IllegalOperationError(sub);
		}
		
		public function expanduser(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function expandvars(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function normpath(path:String):String
		{
			throw new IllegalOperationError(sub);
		}
		
		public function abspath(path:String):String
		{
			throw new IllegalOperationError(sub);
		}

	}
}