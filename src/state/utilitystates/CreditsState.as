package state.utilitystates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import gamesound.Sounds;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Simple short class for the credits page state.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class CreditsState extends State
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _menuState			:MovieClip 		= new mc_state();
		private var _controlsEnabled	:Boolean 		= false;
		private var _sounds:Sounds;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@return	void
		 * 
		 */
		public function CreditsState()
		{
			super();
		}
		
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This method is executed when the state is ready for use.
		 * 
		 *	@return void
		 * 
		 */
		override public function init():void
		{
			_sounds  							= new Sounds("credit");
			addChild							(_menuState);
			_menuState.gotoAndStop				("creditState");
			Session.application.state.setPause	(3, enableControls);
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.  
		 * 
		 *	@return void
		 * 
		 */
		override public function update():void
		{
			if(keyboard.anyKeyIsPressed() && _controlsEnabled){
				state = new MenuState();
			}
		}
		
		/**
		 * 
		 *	Use this method to clean up the class before it is removed. 
		 * 	Remove event listeners here. 
		 * 
		 *	@return void
		 * 
		 */
		override public function dealloc():void
		{
			trace("dealloc from creaitsState");
			super.dealloc();
			removeChild(_menuState);
			_menuState  		= null;
			_sounds 			= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	Enables controls for this class.  
		 * 
		 *	@return void
		 * 
		 */
		private function enableControls():void
		{
			_controlsEnabled = true;
		}
	}
}