/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	import flash.utils.describeType;
	
	/**
	 * Filename matching with shell patterns.
 	 * 
	 * <p>fnmatch(FILENAME, PATTERN) matches according to the local convention.
	 * fnmatchcase(FILENAME, PATTERN) always takes case in account.</p>
	 * 
	 * <p>The functions operate by translating the pattern into a regular
	 * expression. They cache the compiled regular expressions for speed.</p>
	 * 
	 * <p>The function translate(PATTERN) returns a regular expression
	 * corresponding to PATTERN.  (It does not compile it.) </p>
	 */	
	public class FileNameMatch
	{
		private static var _cache:Object = {};
		
		/**
		 * Test whether FILENAME matches PATTERN.
		 * 
    	 * <p>Patterns are Unix shell style:</p>
		 *
    	 * <li> *       matches everything</li>
    	 * <li> ?       matches any single character</li>
    	 * <li> [seq]   matches any character in seq</li>
    	 * <li> [!seq]  matches any char not in seq</li>

    	 * <p>An initial period in FILENAME is not special.<br/>
    	 * Both FILENAME and PATTERN are first case-normalized
    	 * if the operating system requires it.<br/>
    	 * If you don't want this, use fnmatchcase(FILENAME, PATTERN).</p>
    	 * 
		 * @param name
		 * @param pat
		 * @return 
		 */		
		public static function fnmatch(name:String, pat:String):Boolean
		{
			name = OS.path.normcase(name);
		    pat = OS.path.normcase(pat);
		    
		    return fnmatchcase(name, pat);
		}
		
		/**
		 * Return the subset of the list NAMES that match PAT.
		 *  
		 * @param names
		 * @param pat
		 * @return 
		 */		
		public static function filter(names:Array, pat:String):Array
		{
		    var result:Array = new Array();
		    
		    pat = OS.path.normcase(pat);
		    
		    if (_cache[pat] == null) {
		        var res:RegExp = translate(pat);
		        _cache[pat] = res;
			}
			
		    var match:Function = _cache[pat].exec;
		    
		    if (OS.path is PosixPath) {
		        for (var n:int=0;n<names.length;n++) {
		            if (match(names[n])) {
		                result.push(names[n]);
		            }
		        }
		    } else {
		        for (var o:int=0;o<names.length;o++) {
		            if (match(OS.path.normcase(names[o]))) {
		                result.push(names[o]);
		            }
		        }
		    }

		    return result;
		}
		
		/**
		 * Test whether FILENAME matches PATTERN, including case.
		 * 
		 * <p>This is a version of fnmatch() which doesn't case-normalize
		 * its arguments.</p>
		 * 
		 * @param name
		 * @param pat
		 * @return 
		 */		
		public static function fnmatchcase(name:String, pat:String):Boolean
		{
		    if (_cache[pat] == null) {
		        var res:RegExp = translate(pat)
		        _cache[pat] = res;
		    }
		    
		    return _cache[pat].exec(name) != null;
		}
		
		/**
		 * Translate a shell PATTERN to a regular expression.
		 *
		 * <p>There is no way to quote meta-characters.</p>
		 * 
		 * @param pat
		 * @return 
		 */		
		public static function translate(pat:String):RegExp
		{
			var i:int = 0;
			var j:int = 0;
			var n:int = pat.length;
			var res:String = '';
			
			while (i < n)
			{
				var c:String = pat.charAt(i);
		        i = i+1;
		        if (c == '*') {
		            res = res + '.*';
		        }
		        else if (c == '?') {
		            res = res + '.';
		        }
		        else if (c == '[') {
		            j = i;
		            if (j < n && pat.charAt(j) == '!') {
		                j = j+1;
		            }
		            if (j < n && pat.charAt(j) == ']') {
		                j = j+1;
		            }
		            while (j < n && pat.charAt(j) != ']') {
		                j = j+1;
		            }
		            if (j >= n) {
		                res = res + '\\[';
		            } else {
		                var stuff:String = pat.substr(i, j).replace('\\','\\\\');
		                i = j+1;
		                if (stuff.charAt(0) == '!') {
		                    stuff = '^' + stuff.substr(1);
		                } else if (stuff.charAt(0) == '^') {
		                    stuff = '\\' + stuff;
		                }
		                res = (res + '[' + stuff + ']');
		            }
		        } else {
		            res = res + c; //re.escape(c);
		        }
			}
			
		    return new RegExp(res + "$");
		}

	}
}