package state.substates.flagstates.actionstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.actionState;
	
	import math.Layout;
	
	import object.Flag;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.mainstates.IsAlive;
	import state.substates.flagstates.NoFlag;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	The default state for the no flag dwarf.  This method in some ways helps direct
	 * 	the needed states of the dwarf while im no flag state.   
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsDefault extends MovieClip implements actionState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _ddwarf		:NoFlag;
		private var _direction	:Boolean;
		private var _THIS		:PlayerBase
		private var _subTHIS	:IsAlive;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the defualt state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of noFlag
		 * 
		 *	@return void
		 *
		 */
		public function IsDefault($dwarf:NoFlag)
		{
			super();
			_ddwarf = $dwarf
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	 
		 * 	Method called when entering this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{
			_ddwarf.noFlagDwarf.moveLeft 	= false;
			_ddwarf.noFlagDwarf.moveLeft 	= false;
			_direction 						= _THIS.facingRight;
			getDirectionFacing();
		}
		
		/**
		 *	  	
		 * 	Method called when entering this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	 
		 * 	Use this method to enable bridge building in this state.
		 * 
		 *	@return void
		 *
		 */
		public function build():void
		{
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_1)) // player build up 
			{
				_ddwarf.bridgeDir 	= "up";
				_ddwarf.changeState	(_ddwarf.getIsBuildingState());
			} 
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_4)) // player build forward
			{
				_ddwarf.bridgeDir 	= "front";
				_ddwarf.changeState	(_ddwarf.getIsBuildingState());
			}
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_7)) // player build down
			{
				_ddwarf.bridgeDir 	= "down";
				_ddwarf.changeState	(_ddwarf.getIsBuildingState());
			}	
		}
		
		/**
		 *	 
		 * 	Use this method to checks for the enemies flag in this state. 	
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void
		{
			if(_THIS.map.layout.worldItems[Layout.TYPE_CASTLE][_THIS.enemyFlag].hasItsflag ){
				_THIS.map.checkForCastle(_THIS, _THIS.enemyFlag, getFlag)
			}
		}
		
		/**
		 *	  	
		 * 	Use this method to update in this state 
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void{}
		
		/**
		 *	  	
		 * 	Updates the controls while in this state. 
		 * 
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void
		{
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_RIGHT)){ // player move right
				_ddwarf.noFlagDwarf.moveRight 	= true;
				_THIS.facingRight 				= true;	
				_THIS.dwarf.gotoAndStop			("walk_right");
			}
			if(Session.keyboard.released(_THIS.controls.PLAYER_RIGHT)){ // player stop
				_ddwarf.noFlagDwarf.moveRight 	= false;
				_subTHIS.changeState(_subTHIS.getIsStandingState());
			}
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_LEFT)){ // player move left
				_ddwarf.noFlagDwarf.moveLeft 	= true; 
				_THIS.facingRight 				= false;
				_THIS.dwarf.gotoAndStop			("walk_left");
			}
			if(Session.keyboard.released(_THIS.controls.PLAYER_LEFT)){ // player stop
				_ddwarf.noFlagDwarf.moveLeft 	= false;
				_subTHIS.changeState			(_subTHIS.getIsStandingState());
			}
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_UP) || Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_2)){ // play jump
				_subTHIS.changeState			(_subTHIS.getIsJumpingState());
				_subTHIS.jump();	
			}
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_5)){ // player pick up flag
				lookForFlag();
			}
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_8)){ // player throw dynamite
				_ddwarf.changeState				(_ddwarf.getIsThrowingState());
			}
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_3)){ // player swing hammer
				_ddwarf.changeState				(_ddwarf.getIsAttackingState());
			}
			
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
			trace("dealloc from isDefault");
			_ddwarf 	= null;
			_THIS 		= null;
			_subTHIS 	= null;
		}
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	  	
		 * 	Initiates the class' references.  
		 * 
		 *	@return void
		 *
		 */
		private function init():void
		{
			_subTHIS	= _ddwarf.noFlagDwarf.ssDwarf;
			_THIS 		= _subTHIS.aliveDwarf;
		}
		
		/**
		 *	  	
		 * 	Allows the dwarf to capture the flag from the opposing dwarfs castle.
		 * 	Because the dwarf with the flag is only an animation representation. 
		 * 	This method removes the flag child from the stage.  It is added back in
		 * 	another function if the player drops it or falls into the chasm.  
		 * 
		 *	@return void
		 *
		 */
		private function getFlag(result:Boolean, $enemyFlag:Flag):void
		{
			if(result){
				_THIS.map.layout.worldItems[Layout.TYPE_CASTLE][_THIS.enemyFlag].hasItsflag		= false;
				Session.application.state.sound.play											("flagCapture");
				_ddwarf.noFlagDwarf.changeState													(_ddwarf.noFlagDwarf.getHasFlagState());
				Session.application.state.removeChild											($enemyFlag);	
			}
		}
		
		/**
		 *	  
		 * 	Sets the correct animation for the direction the dwarf is facing in this class.  	
		 * 
		 *	@return void
		 *
		 */
		private function getDirectionFacing():void
		{
			switch(_direction){
				case true:
					_THIS.dwarf.gotoAndStop("stand_right");
					break;
				case false:
					_THIS.dwarf.gotoAndStop("stand_left");
					break;
			}
		}
		
		/**
		 *	Checks to see when called if the enemy flag is within grasp of the dwarf
		 * 	while on the stage.   
		 * 
		 *	@return void
		 *
		 */
		private function lookForFlag():void
		{
			if(_THIS.hitTestObject(_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag])){
				pickUpFlag(true);
			}
		}
		
		/**
		 *	Method handles flag pick ups from the stage.  If the flag is on the stage
		 * 	and not in the castle this method will update the animation, remoe the flag
		 * 	from the stage and change the dwarf to has the flag state.  
		 * 
		 * 	@param	Boolean	True if the flag is in the dwarfs pick up radius.  False if not. 
		 * 
		 *	@return void
		 *
		 */
		private function pickUpFlag(result:Boolean):void
		{
			if(result){
				Session.sound.play									("flagCapture");
				switch(_THIS.facingRight){
					case true:
						_THIS.dwarf.gotoAndStop						("pickUp_right");
						_THIS.dwarf.pu_right.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
						break;
					case false:
						_THIS.dwarf.gotoAndStop						("pickUp_left");
						_THIS.dwarf.pu_left.dwarf_flag.gotoAndStop	(_THIS.enemyColor);
						break;
				}
				Session.application.state.removeChild				(_THIS.map.layout.worldItems[Layout.TYPE_FLAG][_THIS.enemyFlag]);
				_ddwarf.noFlagDwarf.changeState						(_ddwarf.noFlagDwarf.getHasFlagState());
			}
		}
		
		
	}
}