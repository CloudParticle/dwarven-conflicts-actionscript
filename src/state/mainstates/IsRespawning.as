package state.mainstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import interfaces.IState;
	
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.input.Controls;
	import se.lnu.mediatechnology.stickossdk.input.SuperControls;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Simulates the respawning state of the dwarf.  Part of the finite state machine.   
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsRespawning implements IState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		protected var _player		:PlayerBase;
		protected var _counter		:int			= 0;
		protected var _blinkMax		:int			= 240;
		protected var _blinkRate	:int 			= 20;	
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the respawning state of the dwarf.  
		 *
		 *	@param 	$player	Must be an instance of the playerBase class.  	
		 * 
		 *	@return void
		 *
		 */
		public function IsRespawning($player:PlayerBase)
		{
			_player = $player;
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	Method called when entering this state.  Determines which player is calling
		 * 	this method and resets his position.  
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{	
			switch(_player.playerNum){
				case 0:
					_player.x = 70;
					_player.y = 150;
					break;
				case 1:
					_player.x = 700;
					_player.y = 150;
					break;
			}
			blinkState();
		}
		
		/**
		 *	Method called when entering this state.  Calls forward this method on any substates of
		 * 	isRespawning.  	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{
		}
		
		/**
		 *	Use this method to enable jump in this state. This is a
		 * 	method of the interface.    	 
		 * 
		 *	@return void
		 *
		 */
		public function jump():void{}
		
		/**
		 *	Use this method to enable update in this state.  	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void{}
		
		/**
		 *	Use this method to enable knockback in this state.  	
		 * 
		 *	@return void
		 *
		 */
		public function knockBack():void{}
		
		/**
		 *	Cleaner method.   	
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{	
			trace("dealloc from isRespawning");
			_player = null;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		/**
		 *	This function creates a sudo timer that changes the alpha 
		 * 	of the character back and forth between 0 and 1 until the 
		 * 	counter max is reached.  The character is then set back 
		 * 	to isAlive and the counter parameter is rest.  
		 * 
		 *	@return void
		 *
		 */
		protected function blinkState():void
		{
			if(_counter > _blinkMax){
				_counter 						= 0;
				_player.dwarf.alpha 			= 1;
				_player.changeState				(_player.getIsAliveState());
				
			}
			else{
				switch(_player.dwarf.alpha){
					case 0:
						_player.dwarf.alpha		= 1;
						break;
					case 1:
						_player.dwarf.alpha		= 0;
						break;
				}
			_counter							+=_blinkRate;
			Session.application.state.setPause	(.2, blinkState)
			}
		}
	}
}