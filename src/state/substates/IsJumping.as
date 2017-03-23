package state.substates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.SubState;
	import interfaces.flagState;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.mainstates.IsAlive;
	
	import tile.Tile;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class represents the dwarf not only in jumping state but also doubles as when the dwarf is falling.
	 * 	This state is therefore where all gravity and y movements are handled.   
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsJumping extends MovieClip implements SubState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------	
		private var _THIS		:IsAlive;
		private var _ySpeed		:Number 				= 0;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var isJumDwarf	:SubstateController;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the jumping state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of the isAlive class.  	
		 * 
		 *	@return void
		 *
		 */
		public function IsJumping($dwarf:SubstateController)
		{
			super();
			isJumDwarf = $dwarf
			init();
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
		public function onEnter():void{  }
		
		/**
		 *	Method called when exiting this state. 	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{
			_ySpeed = 0;
		}

		/**
		 *	Use this method to enable jump y increase in this state. This is a
		 * 	method of the interface.   	
		 * 
		 * 	@param $explosion:int	The amount of increased ySpeed.  This is sent only if 
		 * 							there is a explosion hit on the dwarf from a dynamite
		 * 							explosion.  Default is 0 in a parent class. 	
		 * 
		 *	@return void
		 *
		 */
		public function jump($explosion:int):void
		{
			Session.sound.play("dwarfJump", 0.3);
			_ySpeed = 4 + $explosion;
		}
		
		/**
		 *	Handles y collisions while moving up.   	
		 * 
		 * 	@param offset:int	this is the difference in displacement from a collision check.  
		 * 	@param $height:int	this is the height of the dwarfs collision box.  Together with offset
		 * 						this method repositions the dwarf to the correct location. 
		 * 
		 *	@return void
		 *
		 */
		private function onHeadHit(offset:int, $height:int):void
		{
			trace("head hit");
			_ySpeed				= 0;
			_THIS.aliveDwarf.y	= offset +  $height;
		}
		
		private function onHeadHit2(offset:int, $height:int):void
		{
			//trace("head hit");
			_ySpeed				= 0;
			_THIS.aliveDwarf.y	=  offset - _THIS.aliveDwarf.height + 5
		}
		
		/**
		 *	Use this method to enable update in this state.  Update here 	
		 * 	controls collisions to maintain or leave this state and begins
		 * 	the implementation of the controller in sub states.   Gravity is
		 * 	applied and managaed here. 
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			_THIS.aliveDwarf.y 		+=	_THIS.aliveDwarf.gravity;
			_THIS.aliveDwarf.y 		=	_THIS.aliveDwarf.y - (_ySpeed);	
			_ySpeed 				-= 	.1;
			
			setFaceDirection();
			updateControls();
			checkCollision();
			isJumDwarf.thisUpdate();
		}
		
		/**
		 *	Use this method to enable left side collision handling in this state.
		 * 
		 * 	@param $result:Boolean	Whether there was a hit or not.  True for hit and false fro no hit.   	
		 * 
		 *	@return void
		 *
		 */
		public function onHitXL(result:Boolean):void
		{
			if(result){
				_THIS.aliveDwarf.x = _THIS.aliveDwarf.previous.x;
			}
		}
		
		/**
		 *	Use this method to enable right side collision handling in this state.
		 * 
		 * 	@param $result:Boolean	Whether there was a hit or not.  True for hit and false fro no hit.   	
		 * 
		 *	@return void
		 *
		 */
		public function onHitXR(result:Boolean):void
		{
			if(result){
				_THIS.aliveDwarf.x = _THIS.aliveDwarf.previous.x;
			}
		}
		
		
		
		/**
		 *	The class's state changer.  Allows an exit and enter method to be called 
		 * 	from each state respectively.  	
		 * 
		 * 	@param	$state	The state to switch into.  Must be an instance of flagState.  
		 * 
		 *	@return void
		 *
		 */
		public function changeState ($state:flagState):void 
		{
			isJumDwarf.currentState.onExit();
			isJumDwarf.currentState = $state;
			isJumDwarf.currentState.onEnter();
		}
		
		/**
		 *	Cleaner method
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isJumping");
			_THIS 		= null;
			isJumDwarf	= null;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The class's initiator.  Paths to parent states set here.  
		 * 
		 *	@return void
		 *
		 */
		private function init():void
		{
			_THIS = isJumDwarf.ssDwarf;
		}
		
		/**
		 *	Depending on whether the dwarf has the flag or not and is facing right or left
		 * 	this complicated switch case sets the correct animation and flag color for the 
		 * 	dwarf.  
		 * 
		 *	@return void
		 *
		 */
		private function setFaceDirection():void
		{
			switch(_THIS.aliveDwarf.facingRight){
				case true:
					if(isJumDwarf.currentState == isJumDwarf.noFlagState){
						_THIS.aliveDwarf.dwarf.gotoAndStop							("jump_right");
					}
					else{
						_THIS.aliveDwarf.dwarf.gotoAndStop							("jump_right_flag");
						_THIS.aliveDwarf.dwarf.j_right_flag.dwarf_flag.gotoAndStop	(_THIS.aliveDwarf.enemyColor);
					}
					break;
				case false:
					if(isJumDwarf.currentState == isJumDwarf.noFlagState){
						_THIS.aliveDwarf.dwarf.gotoAndStop							("jump_left");
					}
					else{
						isJumDwarf.ssDwarf.aliveDwarf.dwarf.gotoAndStop				("jump_left_flag");
						_THIS.aliveDwarf.dwarf.j_left_flag.dwarf_flag.gotoAndStop	(_THIS.aliveDwarf.enemyColor);
					}
					break;
			}
		}
		
		/**
		 *	Because Jumping dwarf handles both x and y movement and has a special animaiton set
		 * 	update controls are handled here instead of in a sub state.  Controls for jumping
		 * 	dwarf should therefore be updates here.   
		 * 
		 *	@return void
		 *
		 */
		private function updateControls():void
		{
			//---------------------------------------------------
			//  Player move Right
			//---------------------------------------------------
			if(Session.keyboard.pressed(_THIS.aliveDwarf.controls.PLAYER_RIGHT)){
				isJumDwarf.moveRight 			= true;
				_THIS.aliveDwarf.facingRight 	= true;	
			}
			if(Session.keyboard.released(_THIS.aliveDwarf.controls.PLAYER_RIGHT)){
				isJumDwarf.moveRight 			= false;
			}
			//---------------------------------------------------
			// Player move Left
			//---------------------------------------------------
			if(Session.keyboard.pressed(_THIS.aliveDwarf.controls.PLAYER_LEFT)){
				isJumDwarf.moveLeft 			= true;
				_THIS.aliveDwarf.facingRight 	= false;
			}
			if(Session.keyboard.released(_THIS.aliveDwarf.controls.PLAYER_LEFT)){
				isJumDwarf.moveLeft 			= false;
			}
		}
		
		/**
		 *	 Checks collision on the y axis. With both ground tiles and the players bridge tiles.    
		 * 
		 *	@return void
		 *
		 */
		private function checkCollision():void
		{
			_THIS.aliveDwarf.map.checkYAxisCollisionUp		(_THIS.aliveDwarf.dwarf.hitArea, 	Tile.TYPE_GROUND, 			onHeadHit);
			
			_THIS.aliveDwarf.map.checkYAxisCollision		(_THIS.aliveDwarf.dwarf.hitArea, 	Tile.TYPE_GROUND, 			onHit);
			_THIS.aliveDwarf.map.checkYAxisCollision		(_THIS.aliveDwarf.dwarf.hitArea, 	_THIS.aliveDwarf.bridge,	onHit);
			_THIS.aliveDwarf.map.checkYAxisCollisionUpObj	(_THIS.aliveDwarf.dwarf.hitArea, 	_THIS.aliveDwarf.bridge, 	onHeadHit2);
		}
		
		/**
		 *	Handles collision on the y axis if any.  
		 * 
		 * 	@param $result:Boolean	Whether there was a hit or not.  True for hit and false for no hit.  
		 * 
		 *	@return void
		 *
		 */
		private function onHit($result:Boolean):void
		{
			if($result){
				_THIS.aliveDwarf.y 		= _THIS.aliveDwarf.previous.y
				if(isJumDwarf.moveLeft || isJumDwarf.moveRight){
					_THIS.changeState	(_THIS.getIsRunningState());
				}
				else{
					_THIS.changeState	(_THIS.getIsStandingState());
				}
			}
		}
	}
}