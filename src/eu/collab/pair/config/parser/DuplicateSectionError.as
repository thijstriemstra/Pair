/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.config.parser
{
	/**
	 * Raised when a section is multiply-created.
	 */	
	public class DuplicateSectionError extends ConfigParserError
	{
		public var section:String;
		
		public function DuplicateSectionError(section:String)
		{
			super('Section ' + section + ' already exists');
			this.section = section;
		}
		
	}
}