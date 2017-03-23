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
	public class IsAttacking extends MovieClip implements actionState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _attackingDwarf	:NoFlag;
		private var _direction		:Boolean;
		private var _THIS			:PlayerBase;
		private var _trees			:int;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	The constructor for the attacking state of the dwarf.  
		 *
		 *	@param 	$dwarf	Must be an instance of noFlag
		 * 
		 *	@return void
		 *
		 */
		public function IsAttacking($dwarf:NoFlag)
		{
			super();
			_attackingDwarf = $dwarf
			init();
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *	 
		 * 	Method called when entering this state.  Checks first if the dwarf is trying to collect wood
		 * 	If not moves thed dwarf ot tying to attack method.  If trying to gather wood certain condition must be 	
		 * 	met.  There is a complex if condition that checks first if there is a tree on the level, secondly if the
		 * 	the tree hit box is being hit by the hammer and then if the player is trying to gather wood from his caslte.
		 * 	Castle wood gathering can only be achieved when their wood level is 0 hence the check on the woodCount. 
		 * 
		 *	@return void
		 *
		 */
		public function onEnter():void
		{
			_attackingDwarf.noFlagDwarf.moveLeft 	= false;
			_attackingDwarf.noFlagDwarf.moveRight 	= false;
			_direction 								= _THIS.facingRight;
			
			if(		_trees > 0 																	&& 
					_THIS.hitTestObject(_THIS.map.layout.worldItems[Layout.TYPE_TREE][0]) 		|| 
					_THIS.score.woodCount == 0 													&& 
					_THIS.hitTestObject(_THIS.map.layout.worldItems[Layout.TYPE_CASTLE][_THIS.playerNum].playerCastle.tower.castleWood)
			){ 
				if(_trees > 0)
				{
					if(_THIS.hitTestObject(_THIS.map.layout.worldItems[Layout.TYPE_TREE][0]))
					Session.setPause(1, animateTree);
					Session.setPause(2, animateTree);
					Session.setPause(3, animateTree);
				}

					switch(_direction){
						case true:
							_THIS.dwarf.gotoAndStop				("attack_right");
							Session.application.state.setPause	(4, getWood);
							break;
						case false:
							_THIS.dwarf.gotoAndStop				("attack_left");
							Session.application.state.setPause	(4, getWood);
							break;
						default:
							_attackingDwarf.changeState			(_attackingDwarf.getIsDefaultState());
							break;
					}
			}
			else{getDirectionFacing()}
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
			trace("dealloc from isAttacking");
			_attackingDwarf = null;
			_THIS 			= null;
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
			this._THIS 	= _attackingDwarf.noFlagDwarf.ssDwarf.aliveDwarf
			_trees 	= _THIS.map.layout.worldItems[Layout.TYPE_TREE].length;
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
					_THIS.dwarf.gotoAndStop				("attack_right");
					Session.application.state.setPause	(1.2, swingHammer);
					break;
				case false:
					_THIS.dwarf.gotoAndStop				("attack_left");
					Session.application.state.setPause	(1.2, swingHammer);
					break;
				default:
					_attackingDwarf.changeState			(_attackingDwarf.getIsDefaultState());
					break;
			}
		}
		
		/**
		 *	 
		 * 	Updates the current player wood count and UI.  
		 * 
		 *	@return void
		 *
		 */
		private function getWood():void
		{
			for (var i:int = 0; i < 3; i++) {
				_THIS.score.updateWoodCount("++");
			}
						_attackingDwarf.changeState(_attackingDwarf.getIsDefaultState());
		}

		/**
		 *	 
		 * 	Checks collision for hammer swings against bridges and if in single player
		 * 	rock blocks.   	
		 * 
		 *	@return void
		 *
		 */
		private function swingHammer():void
		{
			Session.sound.play				("hammerHit");
				
			if(_THIS.score.roundTimeSpent && _THIS.map.hammerStones(_THIS, _direction)){
				_attackingDwarf.changeState	(_attackingDwarf.getIsDefaultState());
				return;	
			}
			_THIS.map.hammerBridge			(_THIS, Tile.TYPE_BRIDGE1, _direction);
			_THIS.map.hammerBridge			(_THIS, Tile.TYPE_BRIDGE2, _direction);
		
			_attackingDwarf.changeState		(_attackingDwarf.getIsDefaultState());
		}
		
		/**
		 *	 
		 * 	Runs a simple animation for the tree when harvesting it for wood.   	
		 * 
		 *	@return void
		 *
		 */
		private function animateTree():void
		{
			_THIS.map.layout.worldItems[Layout.TYPE_ISLAND][1].treeIsland.tree.gotoAndPlay(2);
		}
	}
}