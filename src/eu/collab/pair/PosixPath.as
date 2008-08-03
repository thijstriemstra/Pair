/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	import flash.filesystem.File;
	
	/**
	 * Common operations on Posix pathnames.
	 * 
	 * <p>Instead of importing this module directly, import os and refer to
	 * this module as os.path.  The "os.path" name is an alias for this
	 * module on Posix systems; on other systems (e.g. Mac, Windows),
	 * os.path provides the same operations in a manner specific to that
	 * platform, and is an alias to another module (e.g. macpath, ntpath).</p>
	 *
	 * <p>Some of this can actually be useful on non-Posix systems too, e.g.
	 * for manipulation of the pathname component of URLs.</p>
	 * 
	 * status: TODO
	 */
	public class PosixPath extends Path
	{
		public function PosixPath()
		{
			super();
			
			curdir = '.';
			pardir = '..';
			extsep = '.';
			sep = '/';
			pathsep = ':';
			defpath = ':/bin:/usr/bin';
			devnull = '/dev/null';
		}
		
	    /**
		 * Normalize case of pathname.  Has no effect under Posix.
		 * 
		 * @param path
		 * @return 
		 */	
		override public function normcase(path:String):String
		{
			return path;
		}
		
		/**
		 * Test whether a path is absolute
		 * 
		 * @param path
		 * @return 
		 */	
		override public function isabs(path:String):Boolean
		{
			return path.charAt(0) == '/' || path.indexOf('file://') > -1 ||
				path.indexOf('app:') > -1;
		}
		
		/**
		 * Join pathnames.
		 * <p>Ignore the previous parts if a part is absolute.
		 * Insert a '/' unless the first part is empty or already ends in '/'.</p>
		 * 
		 * @param path
		 * @return 
		 */	
		override public function join(path:String, ...p:Array):String
		{
			for (var b:int;b<p.length;b++) {
				var comp:String = p[b];
				if (comp.charAt(0) == '/') {
					path = comp;
				} else if (path == '' || path.charAt(path.length-1) == '/') {
					path += comp;
				} else {
					path += '/' + comp;
				}
			}
			return path;
		}
	    
	    /**
	     * Split a pathname.
	     * 
	     * @param path Path
	     * @return Array "[head, tail]" where "tail" is everything after the 
	     * final slash.  Either part may be empty.
	     */    
	    override public function split(path:String):Array
	    {
	    	var i:int = path.lastIndexOf('/') + 1;
	    	var head:String = path.substr(0, i);
	    	var tail:String = path.substr(i);
			var c:String='';
			
			for (var j:int=0;j<head.length;j++) { 
				c += '/';
			}
		    if (head && head != c) {
		        head = head.replace(new RegExp("\\{"+'/'+"\\}", "g"), '');
		    }
		    
		    return [head, tail];
	    }
	    
	    /**
	     * Split the extension from a pathname.
		 *
		 * <p>Extension is everything from the last dot to the end.
	     * 
	     * @param path
	     * @return [root, ext], either part may be empty.
	     */    
	    override public function splitext(path:String):Array
	    {
	    	var i:int = path.lastIndexOf('.');
	    	
	    	if (i <= path.lastIndexOf('/')) {
	    		return [path, ''];
	    	} else {
	    		return [path.substr(0, i), path.substr(i)];
	    	}
	    }
	    
	    /**
	     * Split a pathname into drive and path. <p>On Posix, drive is always
	     * empty.</p>
	     * 
	     * @param path
	     * @return 
	     */    
	    override public function splitdrive(path:String):Array
	    {
	    	return ['', path];
	    }
	    
	    /**
	     * Return the tail (basename) part of a path.
	     * 
	     * @param path Path
	     * @return The final component of a pathname
	     */    
	    override public function basename(path:String):String
	    {
	    	return split(path)[1];
	    }
	    
	    /**
	     * Returns the directory component of a pathname.
	     * 
	     * @param path
	     * @return 
	     */	    
	    override public function dirname(path:String):String
	    {
	    	return split(path)[0];
	    }
	    
	    /**
	     * Return the size of a file, reported by os.stat().
	     *  
	     * @param filename
	     * @return 
	     */	    
	    override public function getsize(filename:String):int
	    {
	    	return OS.stat(filename).size;
	    }
	    
	    /**
	     * Test whether a path is a symbolic link.
	     *  
	     * @param path
	     * @return 
	     */	    
	    override public function islink(path:String):Boolean
	    {
	    	var stat:File = OS.lstat(path);
	    	
			return stat.isSymbolicLink;
	    }
	    
	    /**
	     * Test whether a path exists.  Returns False for broken symbolic links.
	     *  
	     * @param path
	     * @return 
	     */	    
	    override public function exists(path:String):Boolean
	    {
	    	var stat:File = OS.stat(path);
	    	
	    	return stat.exists;
	    }
	    
	    /**
	     * Test whether a path is a directory
	     *  
	     * @param path
	     * @return 
	     */	    
	    override public function isdir(path:String):Boolean
	    {
	    	var stat:File = OS.stat(path);
	    	
	    	return stat.isDirectory;
	    }
	    
	    /**
	     * Test whether a path is a regular file
	     *  
	     * @param path
	     * @return 
	     */	    
	    override public function isfile(path:String):Boolean
	    {
	    	var stat:File = OS.stat(path);
	    	
	    	return !stat.isDirectory;
	    }
	    
	    /**
	     * Test whether two pathnames reference the same actual file
	     * 
	     * @param f1
	     * @param f2
	     * @return 
	     */	    
	    override public function samefile(f1:String, f2:String):Boolean
	    {
	    	var s1:File = OS.stat(f1);
	    	var s2:File = OS.stat(f2);

	    	return samestat(s1, s2);
	    }
	    
	    /**
	     * Test whether two stat buffers reference the same file
	     *  
	     * @param s1
	     * @param s2
	     * @return 
	     */	    
	    override public function samestat(s1:File, s2:File):Boolean
	    {
	    	return s1 == s2;
	    }
	    
	    /**
	     * Expand ~ and ~user constructions.  If user or $HOME is unknown,
    	 * do nothing.
    	 * 
	     * @param path
	     * @return 
	     */	    
	    override public function expanduser(path:String):String
	    {
	    	var userhome:String='';
	    	
	    	if (path.charAt(0) != '~') {
	    		return path;
	    	}
	    	
	    	var i:int = path.indexOf('/', 1);
	    	
	    	if (i < 0) {
	    		i = path.length;
	    	} else if (i == 1) {
	    		
	    	} else {
	    		return path;
	    	}
	    	userhome = userhome.substr(userhome.lastIndexOf('/'));
	    	return userhome + path.substr(i);
	    }
	    
	    /**
	     * Normalize path, eliminating double slashes, etc.
	     * 
	     * @param path
	     * @return 
	     */	    
	    override public function normpath(path:String):String
	    {
		    return path || '.';
	    }
	    
	    /**
	     * Return an absolute path.
	     *  
	     * @param path
	     * @return 
	     */	    
	    override public function abspath(path:String):String
	    {
	    	if (!isabs(path)) {
	    		path = join(OS.getcwd(), path);
	    	}
	    	
	    	return normpath(path);
	    }
	    
	}

}