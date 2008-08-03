/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * A root logger is not that different to any other logger, except that
     * it must have a logging level and there is only one instance of it in
     * the hierarchy.
	 */	
	public class RootLogger extends Logger
	{
		/**
		 * Initialize the logger with the name 'root'.
		 *  
		 * @param level int or string
		 */		
		public function RootLogger(level:*)
		{
			super('root', level);
		}
		
	}
}