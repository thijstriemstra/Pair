/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log
{
	/**
	 * PlaceHolder instances are used in the Manager logger hierarchy to take
     * the place of nodes for which no loggers have been defined.
     * 
     * <p>This class is intended for internal use only and not as part of the 
     * public API.</p>
	 */	
	public class PlaceHolder
	{
		public var loggerMap:Object;
		
		/**
		 * Initialize with the specified logger being a child of this placeholder.
		 * 
		 * @param alogger
		 */		
		public function PlaceHolder(alogger:Logger)
		{
			loggerMap = { alogger: null };
		}
		
		/**
		 * Add the specified logger as a child of this placeholder.
		 *  
		 * @param alogger
		 */		
		public function append(alogger:Logger):void
		{
			if (!loggerMap.hasOwnProperty(alogger)) {
            	loggerMap[alogger] = null;
   			}
		}

	}
}