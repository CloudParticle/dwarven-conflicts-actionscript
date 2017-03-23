package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import interfaces.IState;
	
	import math.Grid;
	import math.Layout;
	
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	import state.mainstates.SinglePlayerAlive;
	import state.utilitystates.GameState;
	
	import tile.Tile;
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Class representing the singleplayer dwarf instance.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class SinglePlayerBase extends PlayerBase implements IStickOsDisplayObject
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------			
		private var _ThisState		:GameState;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@return void
		 * 
		 */
		public function SinglePlayerBase($playerNum:int, $map:Grid, $color:String, $state:GameState)
		{
			super($playerNum, $map, $color);
			_ThisState = $state;
		}
		
		//------------------------------------------------------------------------------
		//
		// Override protected methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Initializes the states for the singleplayer Dwarf.
		 * 	The player can be only alive or dead.  
		 * 
		 *	@return void
		 * 
		 */
		override protected function initializeStates():void
		{
			_isAliveState 	= new SinglePlayerAlive(this);
		}
		
		/**
		 * Sets the properties of the player.  These properties are used to continue setting up
		 * the player for the game and are used heavily by this class's sub state class'. 
		 * bride is the bridge number for the bridges the player can cross, _score allows access
		 * to the UI class to update scores and facingRight is used as a boolean to control which
		 * direction the player is facing.  
		 * 
		 * @return void
		 */
		override protected function setPlayer():void
		{
			bridge									= Tile.TYPE_BRIDGE1;
			score									= _ThisState.uiBar.playerOne;
			facingRight 							= true;	
		}
		
		/**
		 * This method is actually establishes the player on the map.  The score is set using
		 * update score and the flag is colored to the appropriate color of the player.  The dwarfs
		 * movie clip is then generated dynamically using the color string to build its reference and 
		 * then using this reference instanciates it and adds it to the scene.
		 * 
		 * 
		 * @return void
		 */
		override protected function buildPlayer():void
		{
			setFlagColor();
			matchColorToDwarf();
			setInnerHitBox();
		}
		
		/**
		 *
		 * 	Updates every frame.
		 * 
		 *	@return void
		 *
		 */
		override public function update():void
		{
			
			super.update();
			if(_ThisState.dwarf && _ThisState.dwarf.y > Grid.STAGE_HEIGHT)
			{
				_ThisState.endRound(0);
			}
		}
		
		/**
		 *
		 *  Cleaner method.  Extras like event listeners to be removed here
		 * 
		 *	@return void
		 *
		 */
		override public function dealloc():void
		{
			trace("single player dwarf dealloc");
			super.dealloc();
			_ThisState 		= null;
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 * Matches the flag color to the dwarf color.
		 * 
		 * @return void
		 */
		private function setFlagColor():void
		{
			map.layout.worldItems[Layout.TYPE_FLAG][playerNum].flag.gotoAndStop(_playerColor);
		}
		
		/**
		 * 
		 * Matches the randomly generated color to the dwarf then adds the dwarf
		 * to the stage.
		 * 
		 * @return void
		 */
		private function matchColorToDwarf():void
		{
			var class_name:String	= ("mc_" + _playerColor + "Dwarf");
			var definition:Class 	= getDefinitionByName(class_name) as Class;
			var _dwarf:MovieClip 	= new definition() as MovieClip;
			dwarf 					= _dwarf
			
			addChild				(dwarf);
			dwarf.gotoAndStop		("stand_right");
		}
		
		/**
		 * 
		 * Establishes a hitArea within the dwarf.  This is what is used for most
		 * collision handling.  
		 * 
		 * @return void
		 */
		private function setInnerHitBox():void
		{
			dwarf.hitArea 						= new Sprite();
			dwarf.hitArea.graphics.beginFill	(0xFF00FF);
			dwarf.hitArea.graphics.drawRect		(0,0, 20, 30);
			dwarf.hitArea.graphics.endFill		();
			dwarf.hitArea.alpha = 0;
			dwarf.addChild						(dwarf.hitArea);
		}
	
	}
}