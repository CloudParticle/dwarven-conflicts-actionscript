package state.substates.flagstates.actionstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.actionState;
	
	import object.Dynamite;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.substates.flagstates.NoFlag;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	The throwing dynamite state for the dwarf.
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsThrowing extends MovieClip implements actionState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _throwingdwarf	:NoFlag;
		private var _direction		:Boolean;
		private var _dynamiteStick	:Dynamite;
		private var _THIS			:PlayerBase;
		private var _dynCount		:int 			= 5;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the throwing dynamite state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of noFlag
		 * 
		 *	@return void
		 *
		 */
		public function IsThrowing($dwarf:NoFlag)
		{
			super();
			_throwingdwarf = $dwarf;
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
			_throwingdwarf.noFlagDwarf.moveLeft = false;
			_throwingdwarf.noFlagDwarf.moveLeft = false;
			_direction 							= _THIS.facingRight;
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
		public function build():void{}
		
		/**
		 *	 
		 * 	Use this method to checks for the enemies flag in this state. 	
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void{}
		
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
		public function updateControls():void{
		
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_RIGHT)){ // player move right
				_throwingdwarf.noFlagDwarf.moveRight 			= true;
				_THIS.facingRight 								= true;	
			}
			if(Session.keyboard.released(_THIS.controls.PLAYER_RIGHT)){ // player stop
				_throwingdwarf.noFlagDwarf.moveRight 			= false;
				_throwingdwarf.noFlagDwarf.ssDwarf.changeState	(_throwingdwarf.noFlagDwarf.ssDwarf.getIsStandingState());
			}
			
			if(Session.keyboard.pressed(_THIS.controls.PLAYER_LEFT)){ // player move left
				_throwingdwarf.noFlagDwarf.moveLeft 			= true; 
				_THIS.facingRight 								= false;
			}
			if(Session.keyboard.released(_THIS.controls.PLAYER_LEFT)){ // player stop
				_throwingdwarf.noFlagDwarf.moveLeft 			= false;
				_throwingdwarf.noFlagDwarf.ssDwarf.changeState	(_throwingdwarf.noFlagDwarf.ssDwarf.getIsStandingState());
			}
			
			if(Session.keyboard.pressedOnce(_THIS.controls.PLAYER_UP) || Session.keyboard.pressedOnce(_THIS.controls.PLAYER_BUTTON_2)){ // play jump
				_throwingdwarf.noFlagDwarf.ssDwarf.changeState	(_throwingdwarf.noFlagDwarf.ssDwarf.getIsJumpingState());
				_throwingdwarf.noFlagDwarf.ssDwarf.jump();	
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
			trace("dealloc from isThrowing");
			if(_dynamiteStick){_dynamiteStick.dealloc();}
			_THIS 			= null;
			_dynamiteStick	= null;
			_throwingdwarf	= null;	
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
			_THIS = _throwingdwarf.noFlagDwarf.ssDwarf.aliveDwarf;
		}
		
		/**
		 *	  	
		 * 	Sets the right animation depending on which way the dwarf is facing and 
		 * 	initiates the class' main methods.  
		 * 
		 *	@return void
		 *
		 */
		private function getDirectionFacing():void
		{
			switch(_direction){
				case true:
					_THIS.dwarf.gotoAndStop				("throw_right");
					Session.application.state.setPause	(1, throwDynamite);
					break;
				case false:
					_THIS.dwarf.gotoAndStop				("throw_left");
					Session.application.state.setPause	(1, throwDynamite);
					break;
				default:
					_throwingdwarf.changeState			(_throwingdwarf.getIsDefaultState());
			}
		}
		
		/**
		 *	  	
		 * 	This method does a check to see if there is a dynamite on the stage, whether it exists or not and whether the player
		 * 	is playing in single player or multiplayer mode.  
		 * 	the 
		 * 
		 *	@return void
		 *
		 */
		private function throwDynamite():void
		{
			if(		!_dynamiteStick || _dynamiteStick && !_dynamiteStick.isOnStage && !_throwingdwarf.noFlagDwarf.ssDwarf.singlePlayer){
				simulateDynamite();
			}
			else if(!_dynamiteStick || _dynamiteStick && !_dynamiteStick.isOnStage && _THIS.score.dynamiteCount > 0){
				simulateDynamite();
				updateSinglePlayerDynamiteCount();
			}
			_throwingdwarf.changeState(_throwingdwarf.getIsDefaultState());
		}
		
		
		/**
		 *	  	
		 * 	Private method to update the singple players UI dynamite count.  
		 * 
		 *	@return void
		 *
		 */
		private function updateSinglePlayerDynamiteCount():void
		{
			if(_throwingdwarf.noFlagDwarf.ssDwarf.singlePlayer){
				if(_THIS.score.dynamiteCount < 0){_THIS.score.dynamiteCount = 0;}
				_THIS.score.updateDyanmiteCount("--");
			}
		}
		
		/**
		 *	
		 * 	This method acutally creates and initiates the dynamite thrown.   	
		 * 
		 *	@return void
		 *
		 */
		private function simulateDynamite():void
		{
			Session.sound.play("dwarfThrow");
			_THIS.score.dynamiteAlpha 			= false;
			_dynamiteStick 						= new Dynamite(_THIS.x, _THIS.y, _direction, _THIS.playerNum, _THIS.map, _THIS.score);
			_dynamiteStick.x 					= _THIS.x
			_dynamiteStick.y 					= _THIS.y
			Session.application.state.addChild	(_dynamiteStick);	
		}
	}
}