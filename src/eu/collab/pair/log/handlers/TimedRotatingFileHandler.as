/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.log.handlers
{
	import eu.collab.pair.Glob;
	import eu.collab.pair.OS;
	import eu.collab.pair.Time;
	import eu.collab.pair.log.LogRecord;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	
	/**
	 * Handler for logging to a file, rotating the log file at certain timed
     * intervals.
	 * 
     * <p>If backupCount is > 0, when rollover is done, no more than backupCount
     * files are kept and the oldest ones are deleted.</p> 
	 */	
	public class TimedRotatingFileHandler extends BaseRotatingHandler
	{
		public var when:		String;
		public var suffix:		String;
		public var interval:	int;
		public var dayOfWeek:	int;
		public var rolloverAt:	int;
		public var daysToWait:	int;
		
		public static const SECONDS:String 		= 'S';
		public static const MINUTES:String 		= 'M';
		public static const HOURS:String 		= 'H';
		public static const DAYS:String 		= 'D';
		public static const MIDNIGHT:String 	= 'midnight';
		public static const WEEKDAY:String 		= 'W';
		
		// Number of seconds in a day
		private static const _MIDNIGHT:int = 24 * 60 * 60;
		
		/**
		 * @param fileName
		 * @param rollover
		 * @param interval
		 * @param backupCount
		 * @param encoding
		 */		
		public function TimedRotatingFileHandler(fileName:String, rollover:String=HOURS,
												 interval:int=1, backupCount:int=0,
												 encoding:String=null)
		{
			super(fileName, FileMode.APPEND, encoding);
			
			this.when = rollover.toUpperCase();
			this.backupCount = backupCount;
			
			// Calculate the real rollover interval, which is just the number of
	        // seconds between rollovers.  Also set the filename suffix used when
	        // a rollover occurs.  Current 'when' events supported:
	        // S - Seconds
	        // M - Minutes
	        // H - Hours
	        // D - Days
	        // midnight - roll over at midnight
	        // W{0-6} - roll over on a certain day; 0 - Monday
	        //
	        // Case of the 'when' specifier is not important; lower or upper case
	        // will work.
	        
	        var currentTime:int = new Date().getTime() / 1000; // nr of secs
	        var iv:int;
	        
	        if (when == SECONDS) {
	            iv = 1; // one second
	            this.suffix = "%Y-%m-%d_%H-%M-%S";
	        } else if (when == MINUTES) {
	            iv = 60; // one minute
	            this.suffix = "%Y-%m-%d_%H-%M";
	        } else if (when == HOURS) {
	            iv = 60 * 60; // one hour
	            this.suffix = "%Y-%m-%d_%H";
	        } else if (when == DAYS || when == MIDNIGHT) {
	            iv = 60 * 60 * 24; // one day
	            this.suffix = "%Y-%m-%d";
	        } else if (when.charAt(0) == WEEKDAY) {
	            iv = 60 * 60 * 24 * 7; // one week
	            if (when.length != 2) {
	                throw new TypeError('You must specify a day for weekly rollover from 0 to 6 (0 is Monday): ' + when);
	            }
	            if (when.charAt(1) < '0' || when.charAt(1) > '6') {
	                throw new TypeError("Invalid day specified for weekly rollover: " + when);
	            }
	            
	            this.dayOfWeek = Number(when.charAt(1));
	            this.suffix = "%Y-%m-%d";
	            
	        } else {
	            throw new TypeError("Invalid rollover interval specified: " + when);
	        }
	        
	        this.interval = interval * iv; // multiply by units requested
	        this.rolloverAt = currentTime + this.interval;
	
	        // If we are rolling over at midnight or weekly, then the interval is already known.
	        // What we need to figure out is WHEN the next interval is.  In other words,
	        // if you are rolling over at midnight, then your base interval is 1 day,
	        // but you want to start that one day clock at midnight, not now.  So, we
	        // have to fudge the rolloverAt value in order to trigger the first rollover
	        // at the right time.  After that, the regular interval will take care of
	        // the rest.  Note that this code doesn't care of leap seconds.
	        if (when == MIDNIGHT || when.charAt(0) == WEEKDAY) {
	            var t:Date = new Date();
	            t.setDate(currentTime * 1000);
	            
	            var currentHour:int = t.hours;
	            var currentMinute:int = t.minutes;
	            var currentSecond:int = t.seconds;
	            
	            // r is the number of seconds left between now and midnight
	            var r:int = _MIDNIGHT - ((currentHour * 60 + currentMinute) * 60 + currentSecond);
	            this.rolloverAt = currentTime + r;
	            
	            // If we are rolling over on a certain day, add in the number of days until
	            // the next rollover, but offset by 1 since we just calculated the time
	            // until the next day starts.  There are three cases:
	            // Case 1) The day to rollover is today; in this case, do nothing
	            // Case 2) The day to rollover is further in the interval (i.e., today is
	            //         day 2 (Wednesday) and rollover is on day 6 (Sunday).  Days to
	            //         next rollover is simply 6 - 2 - 1, or 3.
	            // Case 3) The day to rollover is behind us in the interval (i.e., today
	            //         is day 5 (Saturday) and rollover is on day 3 (Thursday).
	            //         Days to rollover is 6 - 5 + 3, or 4.  In this case, it's the
	            //         number of days left in the current week (1) plus the number
	            //         of days in the next week until the rollover day (3).
	            if (when.charAt(0) == WEEKDAY) {
	                var day:int = t.day; // 0 is Monday (sunday actually)
	                if (day > dayOfWeek) {
	                    this.daysToWait = (day - dayOfWeek) - 1;
	                    this.rolloverAt = rolloverAt + (daysToWait * (60 * 60 * 24));
	                }
	                
	                if (day < dayOfWeek) {
	                    this.daysToWait = (6 - dayOfWeek) + day;
	                    this.rolloverAt = rolloverAt + (daysToWait * (60 * 60 * 24));
	                }
	            }
	        }
	        
	        //trace("Will rollover at " + rolloverAt + ", " + (rolloverAt-currentTime) + 
	        //" seconds from now");
		}
		
		/**
		 * Determine if rollover should occur.
		 *
         * <p>record is not used, as we are just comparing times, but it is needed so
         * the method siguratures are the same.</p>
         * 
		 * @param record
		 * @return 
		 */		
		override public function shouldRollover(record:LogRecord):Boolean
		{
			var t:int = new Date().getTime() / 1000;
			
	        if (t >= rolloverAt) {
	            return true;
	        }
	        //trace("No need to rollover: " + t + " now, target -> " + rolloverAt);
	        
	        return false;
		}
		
		/**
		 * Do a rollover; in this case, a date/time stamp is appended to the filename
         * when the rollover happens.
		 * 
		 * <p>However, we want the file to be named for the start of the interval, 
		 * not the current time.  If there is a backup count, then we have to get a 
		 * list of matching filenames, sort them and remove the one with the oldest 
		 * suffix.</p>
		 */		
		override public function doRollover():void
		{
			stream.close();
			
	        // get the time that this sequence started at
	        var t:int = rolloverAt - interval;
	        var d:Date = new Date();
	        d.setTime(t*1000);

	        var dfn:String = baseFileName + "." + Time.strftime(suffix, d);

	        if (OS.path.exists(dfn)) {
	            OS.remove(dfn);
	        }
	        
	        OS.rename(baseFileName, dfn);
	        
	        if (backupCount > 0) {
	            // find the oldest log file and delete it
	            var s:Array = Glob.glob(baseFileName + ".20*");
	            if (s.length > backupCount) {
	                s.sort();
	                OS.remove(s[0]);
	            }
	        }
	        
	       	//trace(baseFileName + " -> " + dfn);
	        
	        stream.open(new File(baseFileName), FileMode.WRITE);
	        
	        rolloverAt = rolloverAt + interval;
		}
		
	}
}