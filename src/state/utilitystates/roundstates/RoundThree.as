package state.utilitystates.roundstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import interfaces.roundState;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.utilitystates.GameState;
	
	import utils.Register;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class represents round three of the single player mode and is a substate
	 * 	of Game State. 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class RoundThree implements roundState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _THIS:GameState;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@param $state:GameState Must be an instance of the current game state. 
		 * 
		 *	@return	void
		 * 
		 */
		public function RoundThree($state:GameState)
		{
			_THIS = $state;
		}
		
		/**
		 * 
		 *	This method is called when the state is entered only.  Set 
		 * 	the resources for the round here including wood count, dynamite count
		 * 	round length in seconds and treasure total.    
		 * 
		 *	@return void
		 * 
		 */
		public function onEnter():void
		{
			_THIS.uiBar.playerOne.woodCount 		= 15;
			_THIS.uiBar.playerOne.dynamiteCount		= 10;
			_THIS.uiBar.playerOne.roundLength 		= Register.roundThreeTime;
			_THIS.uiBar.playerOne.treasureTotal   	= 6;
			_THIS.tileMap.randomizeChestsRThree();
			_THIS.uiBar.playerOne.startTimer();
		}
		
		/**
		 * 
		 *	This method is called when the state is disengagged.
		 * 	Use this method for deallocation.  
		 * 
		 *	@return void
		 * 
		 */
		public function onExit():void
		{
			_THIS 			= null;
		}
		
		/**
		 * 
		 *	Updates every frame.  Checks for the treasure count and time spent.  
		 * 
		 *	@return void
		 * 
		 */
		public function thisUpdate():void
		{
			if(_THIS.uiBar.playerOne.treasuerCount == 6){
				endRound(_THIS.uiBar.playerOne.roundTimeSpent);
				return;
			}
			
			if(_THIS.uiBar.playerOne.roundTimeSpent == 0){
				endRound(0);
				return;
			}
		}
		
		/**
		 * 
		 *	Ends the round and initiates the round end state.  
		 * 	time remaining must be sent to RoundEnd();
		 * 
		 * 	@param $timeRemaining:int 	the time remaining in the round.
		 * 
		 *	@return void
		 * 
		 */
		public function endRound($timeRemaining:int):void
		{
			Session.application.state = new RoundEnd($timeRemaining, 3, _THIS.uiBar.background, _THIS);
		}
	}
}