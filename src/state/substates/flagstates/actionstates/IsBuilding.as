package state.substates.flagstates.actionstates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	
	import interfaces.actionState;
	
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import state.substates.flagstates.NoFlag;
	
	import tile.Tile;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	The bridge building state of the dwarf.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class IsBuilding extends MovieClip implements actionState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _buildingDwarf	:NoFlag;
		private var _direction		:Boolean;
		private var _playerBridge	:int;
		private var _enemyBridge	:int;
		private var _THIS			:PlayerBase
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the building state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of noFlag
		 * 
		 *	@return void
		 *
		 */
		public function IsBuilding($dwarf:NoFlag)
		{
			super();
			_buildingDwarf = $dwarf;
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
			_buildingDwarf.noFlagDwarf.moveLeft 	= false;
			_buildingDwarf.noFlagDwarf.moveRight 	= false;
			_direction 								= _THIS.facingRight;
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
		 * 	This method enables a link to this state in other sub states.  
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
		public function updateControls():void{}

		/**
		 *
		 *  Cleaner method. 
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void
		{
			trace("dealloc from isBuilding");
			_buildingDwarf  = null;
			_THIS			= null;
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
			_THIS 			= _buildingDwarf.noFlagDwarf.ssDwarf.aliveDwarf;
			_playerBridge 	= _THIS.bridge;
			_enemyBridge 	= _THIS.enemyBridge;	
		}
		
		/**
		 *	  
		 * 	Sets the correct animation for the direction the dwarf is facing in this class and 
		 * 	initiates the class' main methods.   	
		 * 
		 *	@return void
		 *
		 */
		private function getDirectionFacing():void
		{
			switch(_direction){
				case true:
					_THIS.dwarf.gotoAndStop				("build_right");
					Session.application.state.setPause	(1, buildBridge);
					break;
				case false:
					_THIS.dwarf.gotoAndStop				("build_left");
					Session.application.state.setPause	(1, buildBridge);
					break;
				default:
					_buildingDwarf.changeState			(_buildingDwarf.getIsDefaultState());
					break;
			}
		}
		
		/**
		 *	  	
		 * 	Checks for available spaces to bridge and if callsback to bridgeBuilt.
		 * 
		 *	@return void
		 *
		 */
		private function buildBridge():void
		{
			if(_THIS.score.woodCount > 0){
			_THIS.map.attemptBridgeBuild(_THIS, Tile.TYPE_AIR, _direction, _buildingDwarf.bridgeDir, _playerBridge, _enemyBridge, bridgeBuilt);
			}
			else{	Session.sound.play("needWood");	 bridgeBuilt(false);}
			
		}
		
		/**
		 *	  	
		 * 	If a bridge was build this method updates the players UI wood count and exits this state to the
		 * 	default state.  
		 * 
		 * 	@param $result:Boolean 	Whether a bridge was built or not.  True or false.
		 * 
		 *	@return void
		 *
		 */
		private function bridgeBuilt($result:Boolean):void
		{
			if($result){
				_THIS.score.updateWoodCount("--");
			}
			_buildingDwarf.changeState(_buildingDwarf.getIsDefaultState());
			
			
		}
	}
}