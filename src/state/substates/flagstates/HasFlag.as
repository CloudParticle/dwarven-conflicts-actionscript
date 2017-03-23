package state.substates.flagstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.flagState;
	
	import math.Grid;
	import math.Layout;
	
	import object.Flag;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.substates.SubstateController;
	import state.utilitystates.MultiplayerWinState;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class handles all necesarry actions while the dwarf has the flag.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class HasFlag extends MovieClip implements flagState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _THIS:PlayerBase;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var hasFlagDwarf:SubstateController;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the flag bearing state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of substateController sub class.  
		 * 					Either, isJumping, isRunning or isStanding	
		 * 
		 *	@return void
		 *
		 */
		public function HasFlag($dwarf:SubstateController)
		{
			super();
			hasFlagDwarf 	= $dwarf;
			_THIS 			= hasFlagDwarf.ssDwarf.aliveDwarf
				
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		/**
		 *	Method called when entering this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{
			setFaceDirection();
		}
		
		/**
		 *	 
		 * 	Method called when exiting this state.   	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	
		 * 	Enable the ability for the dwarf to build bridges here.   	
		 * 
		 *	@return void
		 *
		 */
		public function build():void{}
		
		/**
		 *	Method updates every frame automatically. 	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			checkforWin();
		}
		
		/**
		 *		
		 * 	Sets the correct animation and flag color depending on the dwarf and direction the
		 * 	dwarf is moving/facing.    	
		 * 
		 *	@return void
		 *
		 */
		public function setFaceDirection():void
		{
			switch(_THIS.facingRight){
				case true:
					_THIS.dwarf.gotoAndStop							("stand_right_flag");
					_THIS.dwarf.s_right_flag.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
					break;
				case false:
					_THIS.dwarf.gotoAndStop							("stand_left_flag");
					_THIS.dwarf.s_left_flag.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
					break;
			}
		}
		
		/**
		 *	 
		 * 	Handles all movement controls for the dwarf while in hasFlag state.  Slightly larger method
		 * 	may need to be shortened.    	
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void
		{
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_5)){ // player drop flag
				switch(_THIS.facingRight){
					case true:
						_THIS.dwarf.gotoAndStop							("drop_right");
						_THIS.dwarf.d_right_flag.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
						break;
					case false:
						_THIS.dwarf.gotoAndStop							("drop_left");
						_THIS.dwarf.d_left_flag.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
						break;
				}
				
				Session.application.state.setPause(1, dropFlag);	
			}
			
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_RIGHT)){ // player move right
				hasFlagDwarf.moveRight								= true;
				_THIS.facingRight 									= true;	
				_THIS.dwarf.gotoAndStop								("walk_right_flag");
				_THIS.dwarf.w_right_flag.dwarf_flag.gotoAndStop		(_THIS.enemyColor);
			}
			
			if(Session.keyboard.released(_THIS.controls.PLAYER_RIGHT)){ // player stop
				hasFlagDwarf.moveRight								= false;
				hasFlagDwarf.ssDwarf.changeState					(hasFlagDwarf.ssDwarf.getIsStandingState());
				
			}
			
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_LEFT)){ // player move left
				hasFlagDwarf.moveLeft								= true;
				_THIS.facingRight 									= false;
				_THIS.dwarf.gotoAndStop								("walk_left_flag");
				_THIS.dwarf.w_left_flag.dwarf_flag.gotoAndStop		(_THIS.enemyColor);
			}
			
			if(Session.keyboard.released(_THIS.controls.PLAYER_LEFT)){ // player stop
				hasFlagDwarf.moveLeft 								= false;
				hasFlagDwarf.ssDwarf.changeState					(hasFlagDwarf.ssDwarf.getIsStandingState());
			}
			
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_UP) || Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_2)){ // player jump
				hasFlagDwarf.ssDwarf.changeState					(hasFlagDwarf.ssDwarf.getIsJumpingState());
				hasFlagDwarf.ssDwarf.jump();
			}
		}
		
		/**
		 *	Use this method to enable flag checks in this state. 
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void
		{
		}
		
		/**
		 *	  	
		 * 	This method enables the player to drop their flag if in this state.  This will result
		 * 	in the flag being placed on the stage and the change back to noFlag state  
		 * 
		 *	@return void
		 *
		 */
		public function dropFlag():void
		{
			Session.application.state.addChild											(_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag]);
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].inCastle		= false;
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].x 			= _THIS.x;
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].y 			= _THIS.y; 
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].height		= 35;
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].width		= 35;
			_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag].flagsPlayer	= _THIS.enemyFlag;
			hasFlagDwarf.changeState													(hasFlagDwarf.getNoFlagState());
		}	
		
		/**
		 *
		 *  Cleaner method. 
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from hasFlag");
			_THIS 			= null;
			hasFlagDwarf 	= null;
		}
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 *	 
		 * 	This method enables the round to be won.  Checks to see if the player reaches his castle
		 * 	while in hasFlag mode.  	
		 * 
		 *	@return void
		 *
		 */
		private function checkforWin():void
		{
			_THIS.map.checkForCastle(_THIS, _THIS.playerNum, winTheGame)
		}
		
		/**
		 *
		 * 	Called if the player reaches his castle with the other palyers flag.
		 * 
		 * 	@param $result:Boolean	Whether the player has reached his castle.  True or false.
		 * 	@param $stolenFlag:Flag	The instance of the opposing players flag.  	  	
		 * 
		 *	@return void
		 *
		 */
		private function winTheGame($result:Boolean, $stolenFlag:Flag):void
		{
			if($result){
				hasFlagDwarf.ssDwarf.alerter 			= null;							
				Session.application.state				= new MultiplayerWinState(_THIS.playerNum, _THIS.THIS.uiBar)	// was ui2
				
			}
		}
		
		
	}
}