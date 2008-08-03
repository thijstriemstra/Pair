/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	public interface IPath
	{
		function basename(path:String):String
		
		function isabs(path:String):Boolean
		
		function join(a:String, ...p:Array):String
		
		function normcase(path:String):String
	}
}