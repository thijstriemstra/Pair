package eu.collab.pair.email.errors
{
	/**
	 * A message had a continuation line as its first header line.
	 */	
	public class FirstHeaderLineIsContinuationDefect extends MessageDefect
	{
		public function FirstHeaderLineIsContinuationDefect(line:String=null)
		{
			super(line);
		}
		
	}
}