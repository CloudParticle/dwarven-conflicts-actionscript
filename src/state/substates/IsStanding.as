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
	 *	This class represents the dwarf while its standing.  All changes to this state should be implemented
	 * 	here.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsStanding extends MovieClip implements SubState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------	
		private var _THIS:IsAlive;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var dwarf:SubstateController;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the standing state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of the isAlive class.  	
		 * 
		 *	@return void
		 *
		 */
		public function IsStanding($dwarf:SubstateController)
		{
			super();
			dwarf = $dwarf;
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *	Method called when entering this state.  Calls forward this method on any substates of
		 * 	isStanding through the substate Controller.  	
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{
			setFaceDirection();
		}
		
		/**
		 *	Method called when exiting this state.  Calls forward this method on any substates of
		 * 	isStanding through the substate Controller.  	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	Use this method to enable jump y increase in this state. This is a
		 * 	method of the interface.   	
		 * 
		 *	@return void
		 *
		 */
		public function jump($explosion:int):void{}
		
		/**
		 *	Use this method to enable build in this state.  This is a
		 * 	method of the interface.  
		 * 
		 *	@return void
		 *
		 */
		public function build():void
		{
			dwarf.currentState.build();
		}
		
		/**
		 *	Use this method to enable update in this state.  Update here 	
		 * 	controls collisions to maintain or leave this state and begins
		 * 	the implementation of the controller in sub states.    	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			dwarf.thisUpdate();
			updateControls();
			checkCollision();
			build();
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
			dwarf.currentState.onExit();
			dwarf.currentState = $state;
			dwarf.currentState.onEnter();
		}
		
		/**
		 *	Use this method to set the animation that represents which 
		 * 	direction the character is looking.  Note that each state will 
		 * 	have its own animation specific to a facing direction.  This is 
		 * 	also an interface method.      	
		 * 
		 *	@return void
		 *
		 */
		public function setFaceDirection():void
		{
			dwarf.setFaceDirection();	
		}
		
		/**
		 *	Use this method to enable left side collision handling in this state.
		 * 
		 *	@return void
		 *
		 */
		public function onHitXL(result:Boolean):void{}
		
		/**
		 *	Use this method to enable right side collision handling in this state.
		 * 
		 *	@return void
		 *
		 */
		public function onHitXR(result:Boolean):void{}
		
		/**
		 *	Cleaner method
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isStanding");
			_THIS = null;
			dwarf = null;
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
			_THIS = dwarf.ssDwarf;
			
		}
		
		/**
		 *	 Switchboard method that checks whether the player is trying to move left or right
		 * 	 through the SDK's keyboard listeners and changes to the appropriate state.  This 
		 *	 method also continues the update chain down the interfaces to the class' substates.  
		 * 
		 *	@return void
		 *
		 */
		private function updateControls():void
		{
			dwarf.updateControls();
		
			if(Session.keyboard.pressed(_THIS.aliveDwarf.controls.PLAYER_RIGHT)){ // Player move right
				_THIS.changeState(_THIS.getIsRunningState());	
			}
	
			if(Session.keyboard.pressed(_THIS.aliveDwarf.controls.PLAYER_LEFT)){ // Player move left
				_THIS.changeState(_THIS.getIsRunningState());	
			}
		}
		
		/**
		 *	 Checks collision on the y axis.  
		 * 
		 *	@return void
		 *
		 */
		private function checkCollision():void
		{
			_THIS.aliveDwarf.map.checkForNoGroundCollision(_THIS.aliveDwarf.dwarf.hitArea, Tile.TYPE_GROUND, _THIS.aliveDwarf.bridge, onYHit)
		}
		
		/**
		 *	Handles collision on the y axis if any.  
		 * 
		 *	@return void
		 *
		 */
		private function onYHit(result:Boolean):void
		{
			if(!result){
				_THIS.changeState(_THIS.getIsJumpingState());
			}
		}
		
		
		
	}
}