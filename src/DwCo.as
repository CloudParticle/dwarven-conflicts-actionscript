package
{	
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	
	import se.lnu.mediatechnology.stickossdk.core.Engine;
	
	import state.utilitystates.MenuState;
	
	//------------------------------------------------------------------------------
	//
	// SWF properties
	//
	//------------------------------------------------------------------------------
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	REMEMBER TO CHA  NGE THE NAME OF THIS CLASS, THE CLASS SHOULD HAVE THE 
	 *	SAME NAME AS THE GAME.
	 * 
	 *	@author		XXX XXX
	 *	@version 	0.0
	 *
	 */
	public class DwCo extends Engine
	{
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	The game constructor.
		 * 
		 *	@return void
		 * 
		 */
		public function DwCo():void
		{
			super(MenuState);
		}
	}
}