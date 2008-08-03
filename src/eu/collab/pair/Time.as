/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair
{
	public class Time
	{
		private static var fullDayNames:Array = [
			'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
			'Saturday'];
		
		private static var shortDayNames:Array = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu',
												'Fri', 'Sat'];
		
		private static var fullMonthNames:Array = [
			'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
			'September', 'October', 'November', 'December'];
		
		private static var shortMonthNames:Array = [
			'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct',
			 'Nov', 'Dec'];
		
		public static function strftime(format:String, d:Date):String
		{
			var replacement_pairs:Array = [
					[fullDayNames[d.day], '%A'],
                    [fullMonthNames[d.month], '%B'], [shortDayNames[d.day], '%a'],
                    [shortMonthNames[d.month], '%b'], [am_pm(d), '%p'],
                    [d.fullYear, '%Y'], [String(d.fullYear).substr(2), '%y'], 
                    [dig(d.hours), '%H'], [dig(d.minutes), '%M'], 
                    [dig(d.seconds), '%S'], 
                    [dig(d.date), '%d'], [dig(d.month+1), '%m'],
                    [dig(d.day), '%w'], [dig(d.hours/2), '%I']];
                    
			var ret:String = format.slice();
			for (var s:int=0;s<replacement_pairs.length;s++) {
				ret = ret.replace(replacement_pairs[s][1], replacement_pairs[s][0]);
			}
			return ret;
		}
		
		private static function am_pm(d:Date):String
		{
			return 'AM';
		}
		
		public static function dig(d:int):String
		{
			if (d <= 9) {
				return '0' + d.toString();
			}
			
			return d.toString();
		}

	}
}