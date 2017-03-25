package state.utilitystates
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	
	import flash.display.MovieClip;
	
	import gamesound.Sounds;
	
	import math.Grid;
	import math.Layout;
	
	import object.Castle;
	import object.Flag;
	import object.PlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	
	import ui.UserInterface;
	
	import utils.Register;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	/**
	 *
	 *	Extension of GameState that allows for multiplayer play.
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class MultiplayerGameState extends GameState
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _playerTwoCliff:MovieClip		= new mc_cliff();
		private var _castlePlayerTwo	:Castle 		= new Castle();
		private var _playerTwoFlag	:Flag;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------
		//public var uiBar		:UserInterface;
		public var dwarfTwo		:PlayerBase;
		public var dwarfOne		:PlayerBase;
		public var gameComplete	:Boolean
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
		public function MultiplayerGameState()
		{
		}
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	This method is executed when the state is ready for use.
		 * 
		 *	@return void
		 * 
		 */
		override public function init():void
		{
			initUI();
			initGrid();
			initWorld();	
			initDwarfOne();
			initDwarfTwo();
			initSounds();
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.  Position is handled here.  
		 * 
		 *	@return void
		 * 
		 */
		override public function update():void
		{
			super.update();	
		}
		
		/**
		 * 
		 *	Runs each frame.
		 * 
		 *	@return void
		 * 
		 */
		override public function thisUpdate():void {}
		
		/**
		 * 
		 *	Method to clean up the class before it is removed. Event listeners
		 *  are removed here.
		 * 
		 *	@return void
		 * 
		 */
		override public function dealloc():void
		{
			trace("dealloc from MultiplayerGameState");
			_castlePlayerTwo.dealloc();
			_playerTwoFlag.deallocFlag();
			dwarfOne.dealloc();
			dwarfTwo.dealloc();
			
			
			
			super.dealloc();
			removeChild(_playerTwoCliff);
			
			dwarfTwo 			= null;
			dwarfOne 			= null;
			tileMap	 			= null;
			_castlePlayerTwo	= null;
			_playerTwoFlag  	= null;
			_playerTwoCliff		= null;
			uiBar				= null;
		}
		
		/**
		 * 
		 *	This method is executed when any object is added to the stage and
		 * 	swaps it out for the players avatar to keep it on the top level
		 * 	of the z access.    
		 * 
		 *	@param	object	object to be added to the stage.  
		 * 
		 *	@return void
		 * 
		 */
		override public function addChild(object:*):void
		{
			super.addChild(object);
			if(dwarfTwo){
				Session.application.state.swapChild(object, dwarfTwo);
			}
			if(dwarfOne){
				Session.application.state.swapChild(object, dwarfOne);
			}
		}
		
		//------------------------------------------------------------------------------
		//
		// Override protected methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Initiates the UI.
		 * 
		 *	@return void
		 * 
		 */
		override protected function initUI():void
		{
			super.initUI();
			uiBar.uIBar 		= "multi";
			uiBar.PlayerTwo(1);
		}
		
		/**
		 * 
		 *	Initiates the grid.  Grid expects an int based upon how many
		 * 	islands to add.  
		 * 
		 * 	@param $numIslands	Number of islands the round is to have.  
		 * 
		 *	@return void
		 * 
		 */
		override protected function initGrid($numIslands:int = 3):void
		{
			tileMap = new Grid($numIslands, this);
			tileMap.layout.assignMulitplayerTiles();
		}
		
		/**
		 * 
		 *	Initiates the world objects and adds them to the stage
		 * 
		 *	@return void
		 * 
		 */
		override protected function initWorld():void
		{
			super.initWorld()
				
			addChild		(_playerTwoCliff)
			positionElement	(_playerTwoCliff,	680,	Grid.STAGE_HEIGHT - (Grid.CLIFF_HEIGHT * Grid.TILE_HEIGHT) - 30,	1,	1,	"cliff_right");
			
			addChild		(_castlePlayerTwo);
			buildCaslte		(_castlePlayerTwo,	"right",	800-_castlePlayerTwo.width,	_playerTwoCliff.y - _castlePlayerTwo.height + 20,	1);
			
			_playerTwoFlag 	= new Flag(tileMap);
			initFlag		(_playerTwoFlag,	_castlePlayerTwo.x + _castlePlayerTwo.width/2,	_castlePlayerTwo.y - Grid.TILE_HEIGHT,	1);
			
			if(_skinDecider > 1){
				_playerTwoCliff.gotoAndStop("cliffCave_right");
				uiBar.background = "cave";
			}
		}
		
		/**
		 * 
		 *	Overrites the prepare dwarf one method in Game State.  This is needed
		 * 	as dwarf one uses a different class for multiplayer as opposed to single
		 * 	player. 
		 * 
		 *	@return void
		 * 
		 */
		override protected function prepDwarfOne():void
		{
			dwarfOne 											= new PlayerBase(_game.PLAYER_ONE, tileMap, _randomDwarfColor, Register.multiPlayer, this)
			positionElement										(dwarfOne, 60,  (Grid.CLIFF_HEIGHT*10));
			addChild											(dwarfOne);	
		}
		
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Call this method to initiate dwarf player two.  This method
		 * 	generates a random color from a preset array and assigns 
		 * 	the dwarf, the dwarfs uiBar, the dwarfs flag and castle this 
		 * 	color.  
		 * 
		 *	@return void
		 * 
		 */
		private function initDwarfTwo():void
		{
			initDwarfColors();
			dwarfTwo 											= new PlayerBase(_game.PLAYER_TWO, tileMap, _randomDwarfColor, Register.multiPlayer, this)
			positionElement										(dwarfTwo, 700, (Grid.CLIFF_HEIGHT*10));
			addChild											(dwarfTwo);	
			
			dwarfOne.enemyColor 								= uiBar.playerTwo.playerColor;
			dwarfTwo.enemyColor 								= uiBar.playerOne.playerColor;
			
			_castlePlayerTwo.playerCastle.tower.banner.gotoAndStop	(_randomDwarfColor);
		}
		
	}
}