package state.substates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import interfaces.SubState;
	import interfaces.flagState;
	
	import math.Grid;
	import math.Layout;
	
	import state.mainstates.IsAlive;
	import state.substates.flagstates.HasFlag;
	import state.substates.flagstates.NoFlag;
	
	import tile.Tile;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class acts as a bridge between the substates and the flag states.  
	 * 	This class prevents the right states from being initiated to many times and thus
	 * 	acts to encapsulate the right state at the right moment.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class SubstateController 
	{
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var hasFlagState		:flagState;
		public var noFlagState		:flagState;
		public var currentState		:flagState;
		
		public var isRunningState	:IsRunning;
		public var isJumpingState	:IsJumping;
		public var isStandingState	:IsStanding;
		
		public var ssDwarf			:IsAlive;
		
		public var moveRight		:Boolean;
		public var moveLeft			:Boolean;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the alive state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of the playerBase class.  	
		 * 
		 *	@return void
		 *
		 */
		public function SubstateController($dwarf:IsAlive)
		{
			ssDwarf 		= $dwarf
			initializeStates();
			currentState 	= noFlagState;	
			
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	Enables this function to be called down through the substates.  
		 * 	Sets the animation and Boolean as to whether the dwarf is facing
		 * 	left or right.  
		 * 
		 *	@return void
		 *
		 */
		public function setFaceDirection():void
		{
			currentState.setFaceDirection();
		}
		
		/**
		 *	Use this method to enable update in this state.  	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			currentState.thisUpdate();
			
		}
		/**
		 *	Use this method to enable build in this state.  This is a
		 * 	method of the interface.  
		 * 
		 *	@return void
		 *
		 */
		public function build():void
		{
			currentState.build();
		}
		
		/**
		 *	Use this method to enable controls in this state.  Controls allow the player to move and 
		 * 	interact through listeners for the keyboard.  The supposed "listeners" are interfaced through
		 * 	superControls with if conditionals.  All control methods should be implemented here.  
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void
		{
			currentState.updateControls();
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
			currentState.onExit();
			currentState = $state;
			currentState.onEnter();
		}
		
		/**
		 *	This method handles the pixel movement of the dwarf.  Based upon whether
		 * 	the player wants to move left or right with a boolean paramater.  Collision
		 * 	checks must be done here for each direction.  
		 * 
		 *	@return void
		 *
		 */
		public function movePlayer():void
		{
			if(moveLeft){
				ssDwarf.aliveDwarf.x -= ssDwarf.aliveDwarf.playerSpeed;
				ssDwarf.aliveDwarf.map.checkXAxisLeftCollision(ssDwarf.aliveDwarf.dwarf.hitArea, Tile.TYPE_GROUND, onHitXL)
				ssDwarf.aliveDwarf.map.checkXAxisLeftCollision(ssDwarf.aliveDwarf.dwarf.hitArea, Tile.TYPE_EDGE_AIR, onHitXL)
				ssDwarf.aliveDwarf.map.checkXAxisLeftCollision(ssDwarf.aliveDwarf.dwarf.hitArea, ssDwarf.aliveDwarf.playerNum, onHitXL);
				
			}
			if(moveRight){
				ssDwarf.aliveDwarf.x += ssDwarf.aliveDwarf.playerSpeed; 
				ssDwarf.aliveDwarf.map.checkXAxisRightCollision(ssDwarf.aliveDwarf.dwarf.hitArea, Tile.TYPE_GROUND, onHitXR)
				ssDwarf.aliveDwarf.map.checkXAxisRightCollision(ssDwarf.aliveDwarf.dwarf.hitArea, Tile.TYPE_EDGE_AIR, onHitXR)
				ssDwarf.aliveDwarf.map.checkXAxisRightCollision(ssDwarf.aliveDwarf.dwarf.hitArea, ssDwarf.aliveDwarf.playerNum, onHitXR);
				if(ssDwarf.aliveDwarf.x > Grid.STAGE_WIDTH - ssDwarf.aliveDwarf.width){
					ssDwarf.aliveDwarf.x = ssDwarf.aliveDwarf.previous.x;
				}
			}
		}
		
		/**
		 *	Impelements the collision result with the respective substate.  
		 * 
		 * 	@param $result:Boolean	the resulting hit.  True or false.
		 * 
		 *	@return void
		 *
		 */
		public function onHitXL($result:Boolean):void
		{
			ssDwarf.currentState.onHitXL($result);
		}
		
		/**
		 *	Impelements the collision result with the respective substate.  
		 * 
		 * 	@param $result:Boolean	the resulting hit.  True or false.
		 * 
		 *	@return void
		 *
		 */
		public function onHitXR($result:Boolean):void
		{
			ssDwarf.currentState.onHitXR($result);
		}
		
		/**
		 *	Use this method to enable flag checks in subsequent sub states. 
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void
		{
			currentState.checkForFlag();
		}
		
		/**
		 *	Cleaner method. 
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			
			trace("dealloc from subStateController");
			hasFlagState.		dealloc();	
			noFlagState.		dealloc();
			isRunningState.		dealloc(); 	
			isJumpingState.		dealloc();	
			isStandingState.	dealloc(); 
			hasFlagState 	= null;
			noFlagState  	= null;
			currentState	= null;
			isRunningState 	= null;
			isJumpingState	= null;
			isStandingState = null;
			ssDwarf 		= null;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	Sub states of isAlive instatiated here for use in the caller.  Each
		 * 	sub state of isAlive then uses this class to access their respective
		 * 	sub states: hasFlag and noFlag.  
		 * 
		 *	@return void
		 *
		 */
		private function initializeStates():void
		{	
			isRunningState 		= new IsRunning		(this);
			isJumpingState 		= new IsJumping		(this);
			isStandingState		= new IsStanding	(this);
			hasFlagState 		= new HasFlag		(this);
			noFlagState 		= new NoFlag		(this);
		}
		
		//--------------------------------------------------------------------------
		//
		// State Getters
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * Returns _hasFlagState from subController. Should only be called from one of isAlive's sub states.
		 * 
		 * @return flagState
		 */
		public function getHasFlagState():flagState  { return hasFlagState; }
		/**
		 * 
		 * Returns _noFlagState from subController. Should only be called from one of isAlive's sub states.
		 * 
		 * @return flagState
		 */
		public function getNoFlagState():flagState	 { return noFlagState;  }
	}
}