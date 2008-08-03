/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * The claimed start boundary was never found.
	 */	
	public class StartBoundaryNotFoundDefect extends MessageDefect
	{
		public function StartBoundaryNotFoundDefect(line:String=null)
		{
			super(line);
		}
		
	}
}