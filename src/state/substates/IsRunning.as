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
	 *	This class represents the dwarf while its running.  All changes to this state should be implemented
	 * 	here.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsRunning extends MovieClip implements SubState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------	
		private var _THIS		:IsAlive;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var isRunDwarf	:SubstateController;
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
		public function IsRunning($dwarf:SubstateController)
		{
			super();
			isRunDwarf = $dwarf
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
		public function onEnter():void{}
		
		/**
		 *	Method called when exiting this state.   	
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}
		
		/**
		 *	Use this method to enable jump y increase in this state. This is a
		 * 	method of the interface.   	
		 * 
		 * 	@param $explosion:int 	If jump is enabled in this state use this parameter to add to the 
		 * 							ySpeed of the dwarf.  It enables the dynamite explosion effect on
		 * 							the dwarf.  
		 * 
		 *	@return void
		 *
		 */
		public function jump($explosion:int):void{}
		
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
			updateControls(); 
			checkCollision();
			isRunDwarf.thisUpdate();
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
			isRunDwarf.currentState.onExit();
			isRunDwarf.currentState = $state;
			isRunDwarf.currentState.onEnter();
		}
		
		/**
		 *	Use this method to enable left side collision handling in this state.
		 * 
		 * 	@param $result:Boolean	Whether there was a hit or not.  True for hit and false fro no hit.   	
		 * 
		 *	@return void
		 *
		 */
		public function onHitXL($result:Boolean):void
		{
			if($result){
				_THIS.aliveDwarf.x = _THIS.aliveDwarf.previous.x
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
		public function onHitXR($result:Boolean):void
		{
			if($result){
				_THIS.aliveDwarf.x = _THIS.aliveDwarf.previous.x
			}
		}
		
		/**
		 *	Enables control updates in the flag states and further.  Directed through
		 * 	substatecontroller. 
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void
		{	
			isRunDwarf.updateControls();
		}		
		
		/**
		 *	Cleaner method
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isRunning");
			_THIS 		= null;
			isRunDwarf 	= null;
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
			_THIS = isRunDwarf.ssDwarf;
		}
		
		/**
		 *	 Checks collision on the y axis.  
		 * 
		 *	@return void
		 *
		 */
		private function checkCollision():void
		{
			_THIS.aliveDwarf.map.checkForNoGroundCollision(_THIS.aliveDwarf.dwarf.hitArea, Tile.TYPE_GROUND, _THIS.aliveDwarf.bridge, onYHit);
		}
			
		/**
		 *	Handles collision on the y axis if any.  
		 * 
		 * 	@param $result:Boolean	If this is false it means the dwarf is no longer on a surface and 	
		 * 							needs to be changed into is jumping.   If ture the dwarf remains
		 * 							in this state.  
		 * 
		 *	@return void
		 *
		 */
		private function onYHit($result:Boolean):void
		{
			if(!$result){
				_THIS.changeState(_THIS.getIsJumpingState());
			}
		}
		
		
	}
}