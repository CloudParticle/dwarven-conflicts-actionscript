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
	
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Simple class acts as a bridge between the menu state and single player mode.
	 * 	Shows the player the instructions on how to play.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class SinglePlayerInstructions extends State
	{
	
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _menuState		:MovieClip 	= new mc_state();
		private var _keyboardActive	:Boolean 	= false;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@return void
		 * 
		 */
		public function SinglePlayerInstructions()
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
		public override function init():void
		{
			addChild							(_menuState);
			_menuState.gotoAndStop				("singleState");
			Session.application.state.setPause	(1, enableButtons);
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.
		 * 
		 *	@return void
		 * 
		 */
		public override function update():void
		{
			super.update();
			if(keyboard.anyKeyIsPressed() && _keyboardActive){
				state = new GameState();
			}
		}
		
		/**
		 * 
		 *	Use this method to clean up the class before it is removed. 
		 * 	Remove Event Listeners here. 
		 * 
		 *	@return void
		 * 
		 */
		public override function dealloc():void
		{
			trace("dealloc from singlePlayerInstructions");
			super.dealloc();
			removeChild(_menuState);
			_menuState = null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Enables keyboard events in this class. 
		 * 
		 *	@return void
		 * 
		 */
		private function enableButtons():void
		{
			_keyboardActive = true;
		}	
	}
}