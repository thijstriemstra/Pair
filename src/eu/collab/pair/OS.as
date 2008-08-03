/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	import eu.collab.pair.errors.OSError;
	
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	/**
	 * This class provides a more portable way of using operating 
	 * system dependent functionality than importing a operating 
	 * system dependent built-in class like Capabilities.
	 */	
	public class OS
	{
		private static var _altsep:		String;
		private static var _name:		String;
		private static var _pathsep:	String;
		private static var _linesep:	String;
		private static var _path:		Path;
		
		public static function get linesep():String
		{
			switch (name) {
				case 'ce':
				case 'nt':
					_linesep = '\r\n';
					break;
				case 'posix':
					_linesep = '\n';
					break;
			}
			
			return _linesep;
		}
		
		public static function get name():String
		{
			_name = osname();
			
			return _name;
		}
		
		/**
		 * The name of the operating system dependent class imported.
		 * The following names have currently been registered: 'posix',
		 * 'nt', 'mac', and 'ce'.
		 */			
		public static function get path():Path
		{
			switch (name) {
				case 'posix':
					_path = new PosixPath();
					break;
			}
			
			return _path;
		}
		
		/**
		 * Perform a stat() system call on the given path.
		 * 
		 * <p>The return value is an object whose attributes correspond 
		 * to the members of the stat structure, namely: 
		 * st_mode (protection bits), st_ino (inode number), 
		 * st_dev (device), st_nlink (number of hard links), 
		 * st_uid (user ID of owner), st_gid (group ID of owner), 
		 * st_size (size of file, in bytes), 
		 * st_atime (time of most recent access), st_mtime 
		 * (time of most recent content modification), 
		 * st_ctime (platform dependent; time of most recent metadata 
		 * change on Unix, or the time of creation on Windows).</p>
		 * 
		 * <p>On Mac OS systems, the following attributes may also be 
		 * available: st_rsize, st_creator, st_type.</p>
		 * 
		 * @param path
		 * @return 
		 */	
		public static function stat(path:String):File
		{
			var file:File = new File(path);
	    	
	    	return file;
		}
		
		/**
		 * Like stat(), but do not follow symbolic links. <p>This is an 
		 * alias for stat() on platforms that do not support symbolic 
		 * links, such as Windows.</p>
		 * 
		 * @param path
		 * @return 
		 */	
		public static function lstat(path:String):File
		{
			var file:File = stat(path);
	    	
	    	if (file.isSymbolicLink) {
	    		return null;
	    	}
	    	
	    	return file;
		}
		
		/**
		 * Return a string representing the current working directory.
		 *  
		 * @return 
		 */
		public static function getcwd():String
		{
			var path:String = OS.path.curdir;
						
			return OS.path.dirname(path);
		}
		
		/**
		 * makedirs(path [, mode=0777])
		 * 
    	 * <p>Super-mkdir; create a leaf directory and all intermediate ones.
    	 * Works like mkdir, except that any intermediate path segment (not
    	 * just the rightmost) will be created if it does not exist.  This is
    	 * recursive.</p>
    	 * 
		 * @param name
		 */		
		public static function makedirs(name:String):void
		{
			var headTail:Array = path.split(name);
		    
		    if (headTail[1] == null) {
		        headTail = path.split(headTail[0]);
		    }
		    
		    if (headTail[0] && headTail[1] && !path.exists(headTail[0])) {
		        try {
		            makedirs(headTail[0]);
		        } catch(e:Error) {
		        	// TODO
		            // be happy if someone already created the path
		            //if e.errno != errno.EEXIST:
		            //    raise
		        }
		        if (headTail[1] == OS.path.curdir) {    // xxx/newdir/. exists if xxx/newdir exists
		            return
		        }
		    }
		        
		    mkdir(name);
		}
		
		/**
		 * Create a directory named path.
		 *  
		 * @param path
		 */		
		public static function mkdir(path:String):void
		{
			// TODO
			trace('makedir: ' + path);
		}
    
    	/**
    	 * Remove the file path. <p>If path is a directory, OSError is raised; see rmdir() below to 
    	 * remove a directory. This is identical to the unlink() function documented below. On Windows, 
    	 * attempting to remove a file that is in use causes an exception to be raised; on Unix, the 
    	 * directory entry is removed but the storage allocated to the file is not made available 
    	 * until the original file is no longer in use.</p>
    	 * 
    	 * @param path
    	 */    	
    	public static function remove(path:String):void
    	{
    		var f:File = new File(path);
    		
    		if (f.isDirectory) {
    			throw new OSError();
    		} else {
    			try {
    				f.deleteFile();
    			} catch (e:IOError) {
    				throw new OSError(e.message, e.errorID);
    			}
    		}
    	}
    	
    	/**
    	 * Remove the directory path.
    	 * 
    	 * @param path
    	 */    	
    	public static function rmdir(path:String):void
    	{
    		try {
    			var d:File = new File(path);
    			d.deleteDirectory();
    		} catch (e:IOError) {
    			
    		}
    	}
    	
    	/**
    	 * Rename the file or directory src to dst. If dst is a directory, OSError will be raised. 
    	 * On Unix, if dst exists and is a file, it will be removed silently if the user has permission.
    	 * The operation may fail on some Unix flavors if src and dst are on different filesystems. 
    	 * If successful, the renaming will be an atomic operation (this is a POSIX requirement). 
    	 * On Windows, if dst already exists, OSError will be raised even if it is a file; there 
    	 * may be no way to implement an atomic rename when dst names an existing file.
    	 * 
    	 * @param src
    	 * @param dest
    	 */    	   	
    	public static function rename(src:String, dest:String):void
    	{
    		var sourceFile:File = new File(src);
			var destination:File =  new File(dest);
			
			try  
			{
			    sourceFile.moveTo(destination, true);
			}
			catch (error:Error)
			{
			}
    	}
    	
    	
		/**
		 * Return a list containing the names of the entries in the directory.
		 * The list is in arbitrary order. It does not include the special 
		 * entries '.' and '..' even if they are present in the directory. 
		 * 
		 * @param path
		 * @return 
		 */		
		public static function listdir(path:String):Array
		{
			var f:File = new File(path);
			var files:Array = f.getDirectoryListing();
			var ret:Array = new Array();
			
			for (var s:int=0;s<files.length;s++) {
				ret.push(files[s].name);
			}
			
			return ret;
		}
    	
		private static function osname():String
		{
			var os:String = Capabilities.os.toLowerCase();
			
			if (os.indexOf('windows') > -1) {
				if (os.indexOf('ce') > -1) {
					_name = 'ce';
				} else {
					_name = 'nt';
				}
			} else if (os.indexOf('mac os') > -1 || 
					   os.indexOf('linux') > -1) {
					_name = 'posix';
			}
	
			return _name;
		}
		
	}
}