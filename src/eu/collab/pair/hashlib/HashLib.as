/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.hashlib
{
	/**
	 * hashlib module - A common interface to many hash functions.
	 *
	 * lib(name, string='') - returns a new hash object implementing the
     *                    given hash function; initializing the hash
     *                    using the given string data.
 	 *
	 * Named constructor functions are also available, these are much faster
	 * than using lib():
	 *
	 * md5(), sha1(), sha224(), sha256(), sha384(), and sha512()
	 *
	 * More algorithms may be available on your platform but the above are
	 * guaranteed to exist.
	 *
	 * Choose your hash function wisely.  Some have known collision weaknesses.
	 * sha384 and sha512 will be slow on 32 bit platforms.
	 *
	 * Hash objects have these methods:
	 *  - update(arg): Update the hash object with the string arg. Repeated calls
	 *                 are equivalent to a single call with the concatenation of all
	 *                 the arguments.
	 *  - digest():    Return the digest of the strings passed to the update() method
	 *                so far. This may contain non-ASCII characters, including
	 *                 NUL bytes.
	 *  - hexdigest(): Like digest() except the digest is returned as a string of
	 *                 double length, containing only hexadecimal digits.
	 *  - copy():      Return a copy (clone) of the hash object. This can be used to
	 *                 efficiently compute the digests of strings that share a common
	 *                initial substring.
	 */	
	public class HashLib
	{
		public static function lib(name:String, string:String=''):String
		{
			return '';
		}
		
		public static function md5():String
		{
			return '';
		}
		
		public static function sha1():String
		{
			return '';	
		}
		
		public static function sha224():String
		{
			return '';	
		}
		
		public static function sha256():String
		{
			return '';	
		}
		
		public static function sha384():String
		{
			return '';	
		}
		
		public static function sha512():String
		{
			return '';	
		}

	}
}