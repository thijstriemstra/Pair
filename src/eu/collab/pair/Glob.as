/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	/**
	 * Filename globbing utility.
	 * 
	 * <p>The Glob class finds all the pathnames matching a specified 
	 * pattern according to the rules used by the Unix shell. No tilde expansion 
	 * is done, but *, ?, and character ranges expressed with [] will be 
	 * correctly matched. This is done by using the OS.listdir() and 
	 * FileNameMatch.fnmatch() functions in concert, and not by actually invoking
	 * a subshell. For tilde and shell variable expansion, use OS.path.expanduser()
	 * and OS.path.expandvars().</p>
	 * 
	 * @see eu.collab.pair.OS.listdir() OS.listdir()
	 * @see eu.collab.pair.OS.path.expandvars() OS.path.expandvars()
	 * @see eu.collab.pair.OS.path.expanduser() OS.path.expanduser()
	 * @see eu.collab.pair.FileNameMatch.fnmatch() FileNameMatch.fnmatch()
	 */	
	public class Glob
	{
		private static var magicCheck:RegExp = new RegExp('[*?[]');
		
		/**
		 * Return a list of paths matching a pathname pattern.
		 * 
    	 * <p>The pattern may contain simple shell-style wildcards a la FileNameMatch.</p>
    	 * 
		 * @param pathname
		 * @return 
		 */		
		public static function glob(pathname:String):Array
		{
			return iglob(pathname);
		}
		
		/**
		 * Return a list of paths matching a pathname pattern.
		 * 
    	 * <p>The pattern may contain simple shell-style wildcards a la FileNameMatch.</p>
    	 * 
		 * @param pathname
		 * @return 
		 */		
		public static function iglob(pathname:String):Array
		{
			var list:Array = new Array();
			
			if (!hasMagic(pathname)) {
		        if (OS.path.lexists(pathname)) {
		            list.push(pathname);
		        }
		        return list;
		 	}
		 	
		    var dirname:String = OS.path.split(pathname)[0];
		    var basename:String = OS.path.split(pathname)[1];
		    
		    if (dirname == null) {
		        for (var name:String in glob1(OS.path.curdir, basename)) {
		            list.push(name);
		        }
		        return list;
		    }
		    
		    var dirs:Array;
		    
		    if (hasMagic(dirname)) {
		        dirs = iglob(dirname);
		    } else {
		        dirs = [dirname];
		    }
		    
		    var glob_in_dir:Function;
		    
		    if (hasMagic(basename)) {
		        glob_in_dir = glob1;
		    } else {
		        glob_in_dir = glob0;
		    }
		    
		    for (var d:int=0;d<dirs.length;d++) {
		    	var dname:String = dirs[d];
		    	var res:Array = glob_in_dir(dname, basename);
		        for (var n:int=0;n<res.length;n++) {
		        	var fname:String = res[n];
		            list.push(OS.path.join(dname, fname));
		        }
		    }
		    
		    return list;
		}
		
		private static function glob0(dirname:String, basename:String):Array
		{
			var ret:Array = new Array();
			
			if (basename == '') {
		        // `OS.path.split()` returns an empty basename for paths ending with a
		        // directory separator.  'q*x/' should match only directories.
		        if (OS.path.isdir(dirname)) {
		            ret.push(basename);
		        }
		 	} else {
		        if (OS.path.lexists(OS.path.join(dirname, basename))) {
		            ret.push(basename);
		        }
		 	}
		 	
		    return ret;
		}
		
		private static function glob1(dirname:String, pattern:String):Array
		{
			var names:Array = new Array();
			
			if (dirname == null) {
		        dirname = OS.path.curdir;
		 	}
		 	
		    try {
		        names = OS.listdir(dirname);
		    } catch (e:Error) {
		        return names;
		    }
		    
		    // TODO, filenames starting with a period
		    if (pattern.charAt(0) != '.') {
		        //names = filter(lambda x: )
		    }

		    return FileNameMatch.filter(names, pattern);
		}
		
		private static function hasMagic(s:String):Boolean
		{
			return magicCheck.exec(s) != null;
		}

	}
}