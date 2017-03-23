package utils
{
	//------------------------------------------------------------------------------
	//
	// Import
	//
	//------------------------------------------------------------------------------
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	This is a static register for the game's scores.
	 *
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class Register
	{
		//--------------------------------------------------------------------------
		//
		// Public constants
		//
		//--------------------------------------------------------------------------
		public static const gameID			:int 	= 9;
		public static const singlePlayer	:uint 	= 0;
		public static const multiPlayer		:uint 	= 1;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		public static var totalTimeSpent	:int 	= 0;
		public static var roundOnePoints	:int	= 0;
		public static var roundTwoPoints	:int 	= 0;
		public static var roundThreePoints	:int	= 0;
		
		public static var roundOneTime		:int 	= 60;
		public static var roundTwoTime		:int 	= 50;
		public static var roundThreeTime	:int	= 45;
	}
}