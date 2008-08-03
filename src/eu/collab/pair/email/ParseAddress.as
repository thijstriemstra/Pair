package eu.collab.pair.email
{
	/**
	 * Email address parsing code.
	 */	
	public class ParseAddress
	{
		public static const SPACE:String = ' ';
		public static const EMPTYSTRING = '';
		public static const COMMASPACE:String = ', ';

		private static var _monthnames:Array = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul',
								                'aug', 'sep', 'oct', 'nov', 'dec',
								                'january', 'february', 'march', 'april', 'may', 'june', 'july',
								                'august', 'september', 'october', 'november', 'december'];
		private static var _daynames:Array = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
		private static var _timezones:Object = {'UT':0, 'UTC':0, 'GMT':0, 'Z':0,
								                'AST': -400, 'ADT': -300,  // Atlantic (used in Canada)
								                'EST': -500, 'EDT': -400,  // Eastern
								                'CST': -600, 'CDT': -500,  // Central
								                'MST': -700, 'MDT': -600,  // Mountain
								                'PST': -800, 'PDT': -700   // Pacific 
								                };
		/**
		 * Convert a date string to a time tuple.
		 * 
    	 * Accounts for military timezones.
    	 *  
		 * @param data
		 * @return 
		 */		
		public static function parsedate_tz(data:String):Array
		{
			
		}

	}
}