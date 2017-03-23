package state.substates.flagstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.actionState;
	import interfaces.flagState;
	
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.mainstates.IsAlive;
	import state.substates.flagstates.actionstates.IsAttacking;
	import state.substates.flagstates.actionstates.IsBuilding;
	import state.substates.flagstates.actionstates.IsDefault;
	import state.substates.flagstates.actionstates.IsDroppingFlag;
	import state.substates.flagstates.actionstates.IsThrowing;
	import state.substates.SubstateController;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class handles all necesarry actions while the dwarf does not have the flag.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class NoFlag extends MovieClip implements flagState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _THIS:PlayerBase 
		private var _currentState:actionState;
		private var _isAttackingState:actionState;
		private var _isBuildingState:actionState;
		private var _isThrowingState:actionState;
		private var _isDroppingFlagState:actionState;
		private var _isDefaultState:actionState;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var noFlagDwarf:SubstateController;
		public var bridgeDir:String;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the non flag bearing state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of substateController sub class.  
		 * 					Either, isJumping, isRunning or isStanding	
		 * 
		 *	@return void
		 *
		 */
		public function NoFlag($dwarf:SubstateController)
		{
			super();
			noFlagDwarf = $dwarf
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
		public function onEnter():void
		{
			setFaceDirection();
		}
		
		/**
		 *	Method called when exiting this state.  
		 * 
		 *	@return void
		 *
		 */
		public function onExit():void{}		
		
		/**
		 *	Use this method to enable update in this state and in the sub states
		 * 	of this state.    	
		 * 
		 *	@return void
		 *
		 */
		public function thisUpdate():void
		{
			_currentState.thisUpdate();	
		}
		
		/**
		 *	Use this method to enable flag checks in subsequent sub states. 
		 * 
		 *	@return void
		 *
		 */
		public function checkForFlag():void
		{
			_currentState.checkForFlag();
		}
		
		/**
		 *	Use this method to enable bridge building in subsequent sub states. 
		 * 
		 *	@return void
		 *
		 */
		public function build():void
		{
			_currentState.build();
		}
		
		/**
		 *	Interface method meant for dropping the flag while in has flag state. 
		 * 
		 *	@return void
		 *
		 */
		public function dropFlag():void{}
		
		/**
		 *	Use this method to enable animation control over which direction to use. 
		 * 
		 *	@return void
		 *
		 */
		public function setFaceDirection():void
		{
			switch(_THIS.facingRight){
				case true:
					_THIS.dwarf.gotoAndStop("stand_right");
					break;
				case false:
					_THIS.dwarf.gotoAndStop("stand_left");
					break;
			}
		}
		
		/**
		 *	Use this method to enable update controls in this class and sub classes.
		 * 
		 *	@return void
		 *
		 */
		public function updateControls():void
		{
			_currentState.updateControls();
		}
		
		
		/**
		 *	The class's state changer.  Allows an exit and enter method to be called 
		 * 	from each state respectively.  	
		 * 
		 * 	@param	$state	The state to switch into.  Must be an instance of actionState.  
		 * 
		 *	@return void
		 *
		 */
		public function changeState ($state:actionState):void 
		{
			_currentState.onExit();
			_currentState = $state;
			_currentState.onEnter();
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
			trace("dealloc from noFlag");
			_isAttackingState.dealloc();	
			_isBuildingState.dealloc();
			_isDefaultState.dealloc();	
			_isDroppingFlagState.dealloc();	
			_isThrowingState.dealloc();		
			_THIS 					= null;
			_currentState 			= null;
			_isAttackingState		= null;
			_isBuildingState		= null;
			_isDefaultState			= null;
			_isDroppingFlagState	= null;
			_isThrowingState		= null;
			noFlagDwarf				= null;
			
		}
		//--------------------------------------------------------------------------
		//
		// Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The class's initiator.  Paths to parent states 
		 * 	are set and instantiated here.  
		 * 
		 *	@return void
		 *
		 */
		private function init():void
		{
			initializeStates();
			_THIS 			= noFlagDwarf.ssDwarf.aliveDwarf;
			_currentState	= _isDefaultState;
		}
		
		/**
		 *	Initializes noFlags substates. When initiating sub states
		 * 	this class must be passed to the respective sub state.
		 * 
		 *	@return void
		 *
		 */
		private function initializeStates():void
		{
			_isAttackingState		= new IsAttacking		(this);
			_isBuildingState		= new IsBuilding		(this);
			_isDroppingFlagState	= new IsDroppingFlag	(this);
			_isThrowingState 		= new IsThrowing		(this);
			_isDefaultState 		= new IsDefault			(this);
		}
		
		//--------------------------------------------------------------------------
		//
		// State Getters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * Returns _isAttackingState from noFlag.
		 * 
		 * @return actionState
		 */
		public function getIsAttackingState():actionState 		{return _isAttackingState	}
		
		/**
		 * 
		 * Returns _isBuildingState from noFlag.
		 * 
		 * @return actionState
		 */
		public function getIsBuildingState():actionState 		{return _isBuildingState	}
		
		/**
		 * 
		 * Returns _isDroppingFlagState from noFlag.
		 * 
		 * @return actionState
		 */
		public function getIsDroppingFlagState():actionState	{return _isDroppingFlagState}
		
		/**
		 * 
		 * Returns _isThrowingState from noFlag.
		 * 
		 * @return actionState
		 */
		public function getIsThrowingState():actionState 		{return _isThrowingState	}
		
		/**
		 * 
		 * Returns _isDefaultState from noFlag.
		 * 
		 * @return actionState
		 */
		public function getIsDefaultState():actionState 		{return _isDefaultState		}
	}
}