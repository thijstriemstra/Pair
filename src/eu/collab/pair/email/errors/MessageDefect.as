package eu.collab.pair.email.errors
{
	/**
	 * Base class for a message defect.
	 */	
	public class MessageDefect
	{
		public var line:String;
		
		public function MessageDefect(line:String=null)
		{
			this.line = line;
		}

	}
}