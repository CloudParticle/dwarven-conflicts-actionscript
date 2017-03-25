package state.utilitystates
{	
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	
	import flash.display.MovieClip;
	
	import gamesound.Sounds;
	
	import interfaces.roundState;
	
	import math.Grid;
	import math.Layout;
	
	import object.Castle;
	import object.Dynamite;
	import object.Flag;
	import object.SinglePlayerBase;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.input.Controls;
	import se.lnu.mediatechnology.stickossdk.input.SuperControls;
	
	import state.utilitystates.roundstates.RoundOne;
	import state.utilitystates.roundstates.RoundThree;
	import state.utilitystates.roundstates.RoundTwo;
	
	import ui.UserInterface;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Active state that single player mode runs in.  
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class GameState extends State
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------			
		private var _playerOneCliff		:MovieClip 			= new mc_cliff();
		private var _readySteadyGo		:MovieClip 			= new mc_countdowner();
		private var _roundOneState		:roundState;
		private var _roundTwoState		:roundState;
		private var _roundThreeState	:roundState;
		private var _dwarfOne			:SinglePlayerBase;
		private var _playerOneFlag		:Flag;
		private var _currentRound		:int;
		private var _currentState		:roundState;
		private var deallocBug			:Boolean 			= false;
		//--------------------------------------------------------------------------
		//
		// Protected properties
		//
		//--------------------------------------------------------------------------	
		protected var _backGround		:MovieClip		= new mc_background();
		protected var _playerColors		:Array 			= new Array("red", "yellow", "blue", "green");
		protected var _castlePlayerOne	:Castle 		= new Castle();
		protected var _game				:SuperControls	= new SuperControls();
		protected var _sounds			:Sounds;
		protected var _randomColor		:int;
		protected var _randomDwarfColor	:String;
		protected var _skinDecider:int
		//--------------------------------------------------------------------------
		//
		// Public static properties
		//
		//--------------------------------------------------------------------------
		public var tileMap				:Grid;
		public var uiBar				:UserInterface;
		//------------------------------------------------------------------------------
		//
		// Constructor method
		//
		//------------------------------------------------------------------------------
		/**
		 * 
		 *	The class constructor.
		 * 
		 *	@param	$round	The round the player is about to begin.  Default is 1.	
		 * 
		 *	@return	void
		 * 
		 */
		public function GameState($round:int = 1):void
		{
			_currentRound = $round;
		}
		
		//------------------------------------------------------------------------------
		//
		// Override public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	This method is executed when the state is ready for use.  All game state items
		 * 	are initiated here.
		 * 
		 *	@return void
		 * 
		 */
		override public function init():void
		{
			super.init();
			initUI();
			initGrid();
			initWorld();
			initStates();
			initCountdown();
			initDwarfOne();
			initSounds();	
		}
		
		/**
		 * 
		 *	This method is executed when any object is added to the stage and
		 * 	swaps it out for the players avatar to keep it on the top level
		 * 	of the z access.    
		 * 
		 *	@param	$object	object to be added to the stage.  
		 * 
		 *	@return void
		 * 
		 */
		override public function addChild($object:*):void
		{
			super.addChild($object);
			if(_dwarfOne){
				Session.application.state.swapChild($object, _dwarfOne);
			}
		}
		
		/**
		 * 
		 *	This method runs automatically for each frame.  Controlls are handled here.
		 * 	thisUpdate is run here and is simulation of update for this class' states.    
		 * 
		 *	@return void
		 * 
		 */
		override public function update():void
		{
			
			super.update();
			updateControl();
			if(deallocBug){
				return;
			}
			thisUpdate();
		}
		
		/**
		 * 
		 *	Method to clean up the class before it is removed. Remove Event
		 * 	Listeners here.  
		 * 
		 *	@return void
		 * 
		 */
		override public function dealloc():void
		{
			trace("Dealloc from Gamestate");
			super.dealloc();
			
			Session.sound.		stopAll();
			_castlePlayerOne.	dealloc();
			tileMap.layout.		dealloc();
			tileMap.			dealloc();
			
			if(_dwarfOne){
				_dwarfOne.dealloc(); 
				_roundOneState.onExit(); 
				_roundTwoState.onExit(); 
				_roundThreeState.onExit();
			}
			if(_playerOneFlag)	{_playerOneFlag.deallocFlag();}
			
			deallocBug 			= true;
			
			removeChild			(_playerOneCliff);
			removeChild			(_readySteadyGo);
			removeChild			(_backGround);
			
			_currentState 		= null;
			_playerOneCliff 	= null;
			_readySteadyGo 		= null;
			_roundOneState 		= null;
			_roundThreeState 	= null;
			_roundTwoState 		= null;
			_playerOneFlag 		= null;
			_dwarfOne 			= null;
			_backGround 		= null;
			_playerColors 		= null;
			_castlePlayerOne 	= null;
			_sounds 			= null;
			tileMap 			= null;
		}
	
		
		//------------------------------------------------------------------------------
		//
		// Class getters
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Gets the instance of dwarfOne
		 * 
		 *	@return dwarfOne An instance of the singlePlayerBase
		 * 
		 */
		public function get dwarf():SinglePlayerBase
		{
			return _dwarfOne;
		}
		
		//------------------------------------------------------------------------------
		//
		// Class setters
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Sets the instance of dwarfOne.
		 * 
		 * 	@param $dwarf	singlePlayerBase 
		 * 
		 *	@return void
		 * 
		 */
		public function set dwarf($dwarf:SinglePlayerBase):void
		{
			_dwarfOne = $dwarf;
		}
	
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Initializes the states for GameState. Each round is accessed 
		 * 	seperately through its getter method. Ex: getRoundOne():roundState.
		 * 
		 *	@return void
		 * 
		 */
		public function initStates():void
		{
			_roundOneState		= new RoundOne	(this);
			_roundTwoState		= new RoundTwo	(this);
			_roundThreeState	= new RoundThree(this);
			
			getRound();	
		}
		
		
		
		/**
		 * 
		 *	Ends the current Round and calls the child method
		 * 	in the current state(round).
		 * 
		 * 	@param $timeRemainging The remainig time in the current round in seconds.
		 * 
		 *	@return void
		 * 
		 */
		public function endRound($timeRemaining:int):void
		{
			_currentState.endRound($timeRemaining);
		}
		
		/**
		 * 
		 *	Runs each frame.  Current state childs update method 
		 * 	also enabled via this method.  
		 * 
		 *	@return void
		 * 
		 */
		public function thisUpdate():void
		{
			if(!_currentState){return}
			_currentState.thisUpdate();
			
		}
		
		/**
		 * 
		 * Returns _roundOneState from GameState.
		 * 
		 * @return roundState
		 */
		public function getRoundOne():roundState 	{return _roundOneState}
		
		/**
		 * 
		 * Returns _roundOneState from GameState.
		 * 
		 * @return roundState
		 */
		public function getRoundTwo():roundState 	{return _roundTwoState}
		
		/**
		 * 
		 * Returns _roundOneState from GameState.
		 * 
		 * @return roundState
		 */
		public function getRoundThree():roundState	{return _roundThreeState}
		
		
		/**
		 *	The class's state changer.  Allows an exit and enter method to be called 
		 * 	from each state respectively.  	
		 * 
		 * 	@param	$state	The state to switch into.  Must be an instance of actionState.  
		 * 
		 *	@return void
		 *
		 */
		public function changeState ($state:roundState):void 
		{
			_currentState.onExit();
			_currentState = $state;
			_currentState.onEnter();
		}
		
		//------------------------------------------------------------------------------
		//
		// Protected methods
		//
		//------------------------------------------------------------------------------

		/**
		 * 
		 *	Initiates the UI.
		 * 
		 *	@return void
		 * 
		 */
		protected function initUI():void
		{
			uiBar 			= new UserInterface();
			addChild		(uiBar);
			uiBar.uIBar		= "single";
			uiBar.PlayerOne(0);
			positionElement	(uiBar, 0, 0);
		}
		
		/**
		 * 
		 *	Call this method to initiate the dwarf.  This method
		 * 	generates a random color from a preset array and assigns 
		 * 	the dwarf, the dwarfs uiBar, the dwarfs flag and castle this 
		 * 	color.  
		 * 
		 *	@return void
		 * 
		 */
		protected function initDwarfOne():void
		{
			Session.application.state.swapChild						(_backGround,	uiBar);
			initDwarfColors();
			prepDwarfOne();
			_castlePlayerOne.playerCastle.tower.banner.gotoAndStop	(_randomDwarfColor);
		}
		
		protected function prepDwarfOne():void
		{
			_dwarfOne 												= new SinglePlayerBase(_game.PLAYER_ONE,	tileMap,	_randomDwarfColor,	this);
			addChild												(_dwarfOne);	
			_dwarfOne.playerSpeed 									= 0;
			positionElement											(_dwarfOne, 		60,		(Grid.CLIFF_HEIGHT*10)	);
		}
	
		protected function initDwarfColors():void
		{
			_randomColor										= int(Math.random()	*	_playerColors.length);
			_randomDwarfColor									= _playerColors[_randomColor];
			_playerColors.splice								(_randomColor,		1);
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
		protected function initGrid($numIslands:int = 1):void
		{
			tileMap = new Grid($numIslands);
			tileMap.layout.assignTileMapArray();
		}
		
		/**
		 * 
		 *	Initiates the world objects and adds them to the stage
		 * 
		 *	@return void
		 * 
		 */
		protected function initWorld():void
		{	
			_skinDecider = Math.floor(Math.random()*3);
			
			addChild			(_backGround);
			positionElement		(_backGround, 0, 0);
			
			
			
			addChild			(_playerOneCliff);
			positionElement		(_playerOneCliff,	0,	Grid.STAGE_HEIGHT - (Grid.CLIFF_HEIGHT * Grid.TILE_HEIGHT) - 30,	1,	1,	"cliff_left");
			
			
			if(_skinDecider > 1){
				_backGround.gotoAndStop("cave");
				_playerOneCliff.gotoAndStop("cliffCave_left");
				//if(uiBar){ uiBar.background = "cave";}
				uiBar.background = "cave";
			}
			
			addChild			(_castlePlayerOne);
			buildCaslte			(_castlePlayerOne,	"left",	0,	_playerOneCliff.y - _castlePlayerOne.height + 20,	0);
			
			_playerOneFlag 			= new Flag(tileMap);
			initFlag			(_playerOneFlag,	_castlePlayerOne.width/2,	_castlePlayerOne.y - Grid.TILE_HEIGHT,	0);
		}
		
		/**
		 * 	Establishes the castle movieclip.  mc_cliff must already be instantiated before
		 * 	this method can run.   
		 * 
		 *	@param	$castle		the instance of the mc_cliff.
		 *	@param	$direction	which direction the castle will face.  "left" or "right".
		 *	@param	$x			the castles x position
		 *	@param	$y			the castles y position
		 * 	@param	$player		which player the castle will represent.  1 or 0.
		 * 
		 * @return void
		 * 
		 */
		protected function buildCaslte($castle:MovieClip, $direction:String, $x:int, $y:int, $player:int):void
		{
			$castle.playerCastle.gotoAndStop	($direction);
			positionElement				($castle, $x, $y);
			tileMap.layout.worldItems	[Layout.TYPE_CASTLE][$player] = $castle;
		}
		
		/**
		 * 	Establishes the flag for the player.  The players flag is a class called Flag
		 * 	and must be instantiated before this method can run.    
		 * 
		 *	@param	$flag		the instance of Flag
		 *	@param	$x			the castles x position
		 *	@param	$y			the castles y position
		 * 	@param	$player		which player the flag will belong too.  1 or 0.
		 * 
		 * @return void
		 * 
		 */
		protected function initFlag($flag:Flag, $x:int, $y:int, $player:int):void
		{
			addChild												($flag);
			positionElement											($flag, $x, $y);
			$flag.flag.width 										= 35;
			$flag.flag.height 										= 35;
			tileMap.layout.worldItems[Layout.TYPE_FLAG][$player]	= $flag;
		}
		
		/**
		 * Small function to posision an element.
		 * 
		 *	@param	$element	The movie clip to be positioned
		 *	@param	$x			The movie clips new x position on the stage
		 *	@param	$y			The movie clips new y position on the stage
		 *	@param	$Xscale		The new X scale of the movie clip. Default is 1.
		 * 	@param	$Yscale		The new Y scale of the movie clip. Default is 1.
		 * 	@param	$frame		The frame for the movieclip to go to and stop.  Must be an int or a string. Default is 1.
		 * 
		 * 
		 * @return void
		 * 
		 */
		protected function positionElement($element:MovieClip, $x:uint, $y:uint, $Xscale:int = 1, $Yscale:int = 1, $frame:* = 1):void
		{
			$element.gotoAndStop	($frame);
			$element.x 				= $x;
			$element.y 				= $y;
			$element.scaleX 		= $Xscale;
			$element.scaleY 		= $Yscale;
		}
		
		/**
		 * 
		 *	This method handles the keyboard commands for this state.
		 * 
		 *	@return void
		 * 
		 */
		protected function updateControl():void
		{
			if(keyboard.pressedOnce(Controls.UNIVERSAL_START_1) && keyboard.pressedOnce(Controls.UNIVERSAL_START_2 )){
				uiBar.dealloc();
				state = new MenuState();
			}
		}
		
		/**
		 * 
		 *	Adds the sounds for the entire round of this game.  This method
		 * 	must be called on for any of the sounds to work in the round.  
		 * 
		 * 	@param $gameType	A string to start the round music.  Must be 
		 * 						game or menu.  Default is game.
		 * 
		 *	@return void
		 * 
		 */
		protected function initSounds($gameType:String = "game"):void
		{
			_sounds = new Sounds($gameType);
		}
		
		//------------------------------------------------------------------------------
		//
		// Private methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Starts the countdown for animation for the round.  
		 * 
		 *	@return void
		 * 
		 */
		private function initCountdown():void
		{
			addChild(_readySteadyGo);
			Session.application.state.swapChild(Session.application.getChildAt(Session.application.numChildren - 1), _readySteadyGo);
			Session.setPause(3.5, function():void{	
				removeChild(_readySteadyGo); 
				_dwarfOne.playerSpeed = 3;
			});
		}
		
		/**
		 * 
		 *	Switchboard for the round to be.  This method will handle
		 * 	the round changes after each respective round is done.  
		 * 
		 *	@return void
		 * 
		 */
		private function getRound():void
		{
			switch(_currentRound){
				case 1:
					_currentState 	= _roundOneState;
					break;
				case 2:
					_currentState 	= _roundTwoState;
					break;
				case 3:
					_currentState 	= _roundThreeState;
					break;
			}
			_currentState.onEnter();
		}
	}
}