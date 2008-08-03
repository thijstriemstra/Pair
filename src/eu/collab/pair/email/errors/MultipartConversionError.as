/**
 Copyright (C) 2008 The Pair Project. 
 See LICENSE.txt for details.
*/
package eu.collab.pair.email.errors
{
	/**
	 * Conversion to a multipart is prohibited.
	 */	
	public class MultipartConversionError extends MessageError
	{
		public function MultipartConversionError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}