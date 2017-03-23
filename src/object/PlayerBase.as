package object
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import interfaces.IState;
	
	import math.Grid;
	import math.Layout;
	
	import se.lnu.mediatechnology.stickossdk.application.State;
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	import se.lnu.mediatechnology.stickossdk.input.SuperControls;
	
	import state.mainstates.IsAlive;
	import state.mainstates.IsDying;
	import state.mainstates.IsRespawning;
	import state.mainstates.SinglePlayerAlive;
	import state.utilitystates.GameState;
	import state.utilitystates.MultiplayerGameState;
	
	import tile.Tile;
	
	import ui.Score;
	import ui.UserInterface;
	
	import utils.Register;

	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	Class for the base of the dwarf player. This class is used in all circumstances when creating the dwarf avatar.
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class PlayerBase extends MovieClip implements IStickOsDisplayObject
	{
		//--------------------------------------------------------------------------
		//
		// Private properties
		//
		//--------------------------------------------------------------------------
		private var _greenDwarf			:mc_greenDwarf; // Not all movie clips are used but must be imported for the
		private var _blueDwarf			:mc_blueDwarf; 	// the random generation of player dwarf.  
		private var _yellowDwarf		:mc_yellowDwarf;
		private var _redDwarf			:mc_redDwarf;
		private var _isDyingState		:IState;
		private var _isRespawningState	:IState;
		private var _gameMode			:int;
		private var deallocBug			:Boolean 			= false;
		//--------------------------------------------------------------------------
		//
		// Protected properties
		//
		//--------------------------------------------------------------------------
		protected var _isAliveState		:IState;
		protected var _playerColor		:String;
		//--------------------------------------------------------------------------
		//
		// Public properties
		//
		//--------------------------------------------------------------------------	
		public var previous				:Point		  		= new Point();
		public var controls				:SuperControls 		= new SuperControls();
		public var playerSpeed			:int 				= 3;
		public var gravity				:int 				= 2;
		public var playerNum			:int;
		public var bridge				:int;
		public var enemyBridge			:int;
		public var enemyFlag			:int;
		public var dwarf				:MovieClip;
		public var currentState			:IState;
		public var facingRight			:Boolean
		public var score				:Score;
		public var map					:Grid;
		public var enemyColor			:String;
		public var THIS					:MultiplayerGameState;
		//--------------------------------------------------------------------------
		//
		// Constructor method
		//
		//--------------------------------------------------------------------------
		
		/**
		 *
		 *	The class constructor. Sets this class to player 1 or 2
		 *
		 *	@param 	$playerNum	Must be either 0 or 1. Represents the different players number
		 * 	@param 	$map		Singleton instance of Grid to be used for collision and tile map interaction
		 * 	@param 	$mode		represents single player or multiplayer.  Default is 0.
		 * 	@param 	$state		In order for multiplayer to work an instance of Multiplaayer game state must be sent.  For single player send nothing. Default is null.
		 * 
		 *	@return void
		 *
		 */
		public function PlayerBase($playerNum:int, $map:Grid, $color:String, $mode:int= Register.singlePlayer, $state:MultiplayerGameState = null)
		{
			super();
			_playerColor	= $color;
			_gameMode 		= $mode;
			THIS			= $state;
			map 			= $map
			controls.player	= $playerNum
			playerNum 		= $playerNum
		}
		
		//--------------------------------------------------------------------------
		//
		// Public methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *
		 * 	Secondary constructor.  Implemented from IStickOSDisplayObject.
		 * 
		 *	@return void
		 *
		 */
		public function init():void
		{	
			setPlayer();
			buildPlayer();
			initializeStates();
			currentState = _isAliveState;	
		}
		
		/**
		 *
		 * 	Enables dynamite knock back effects on the player.  
		 * 
		 *	@return void
		 *
		 */
		public function knockBack():void
		{
			currentState.knockBack();
		}
		
		/**
		 *
		 * 	Updates this frame every frame according to the fps set in the SDK.
		 * 	Players world map x and y are saved each frame to help in collision detection.
		 * 
		 *	@return void
		 *
		 */
		public function update():void
		{
			this.previous.x = this.x;
			this.previous.y = this.y;
			currentState.thisUpdate();	
		}
		
		/**
		 *
		 *  Cleaner method.  Extras like event listeners to be removed here
		 * 
		 *	@return void
		 *
		 */
		public function dealloc():void{
			trace("Player base dealloc");
			_isAliveState.dealloc();
			if(_isDyingState	 ) _isDyingState.dealloc();
			if(_isRespawningState) _isRespawningState.dealloc();
			
			removeChild(dwarf);
			
			_greenDwarf 		= null;
			_blueDwarf 			= null;
			_yellowDwarf 		= null;
			_redDwarf 			= null;
			_isDyingState 		= null;
			_isRespawningState	= null;
			_isAliveState 		= null;
			currentState 		= null;
			previous 			= null;
			controls 			= null;
			dwarf 				= null;
			score 				= null;
			map 				= null;
			THIS 				= null;
		}
		
		/**
		 *	Changes states betweem Alive, Respawning and Dead.  This method also
		 * 	allows for a method to be called on entering and on leaving the current
		 * 	state.  Call this method to change between whether the dwarf is alive dead 
		 * 	or respawning.  
		 *  
		 * 	@param $state	The state to be changed. Must be an implementation of IState
		 * 
		 *	@return void
		 *
		 */
		public function changeState ($state:IState):void 
		{
			currentState.onExit();
			currentState = $state; 
			currentState.onEnter();
		}
		
		//--------------------------------------------------------------------------
		//
		// State Getters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * Returns _isAliveState from playerBase.  
		 * 
		 * @return IState
		 */
		public function getIsAliveState()		:IState	{ return _isAliveState;		}
		
		/**
		 * 
		 * Returns _isRespawningState from playerBase.  
		 * 
		 * @return IState
		 */
		public function getIsRespawningState()	:IState	{ return _isRespawningState;}
		
		/**
		 * 
		 * Returns _isDyingState from playerBase.  
		 * 
		 * @return IState
		 */
		public function getIsDyingState()		:IState { return _isDyingState;		}
		
		/**
		 * 
		 * Returns _isDyingState from playerBase.  
		 * 
		 * @return IState
		 */
		protected function getIsDeadState()		:IState {return _isDyingState 		}
		
		
		//--------------------------------------------------------------------------
		//
		// Protected methods
		//
		//--------------------------------------------------------------------------	
		
		/**
		 * Sets the properties of the player.  These properties are used to continue setting up
		 * the player for the game and are used heavily by this class's sub state class'. 
		 * bride is the bridge number for the bridges the player can cross, _score allows access
		 * to the UI class to update scores and facingRight is used as a boolean to control which
		 * direction the player is facing.  
		 * 
		 * @return void
		 */
		protected function setPlayer():void
		{
			switch(playerNum){
				case controls.PLAYER_ONE:
					bridge									= Tile.TYPE_BRIDGE1;
					enemyBridge 							= Tile.TYPE_BRIDGE2; 
					enemyFlag 								= 1;
					score									= THIS.uiBar.playerOne; // was ui2
					score.playerColor						= _playerColor
					facingRight 							= true;
					break;
				case controls.PLAYER_TWO:
					bridge									= Tile.TYPE_BRIDGE2;
					enemyBridge 							= Tile.TYPE_BRIDGE1;
					enemyFlag 								= 0;
					score									= THIS.uiBar.playerTwo; // was ui2
					score.playerColor						= _playerColor
					facingRight 							= false;
					break;
			}
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
		protected function buildPlayer():void
		{
			score.woodCount	 	= 8;
			map.layout.worldItems[Layout.TYPE_FLAG][playerNum].flag.gotoAndStop(_playerColor);

			var class_name:String	= ("mc_" + _playerColor + "Dwarf");
			var definition:Class 	= getDefinitionByName(class_name) as Class;
			var _dwarf:MovieClip 	= new definition() as MovieClip;
			dwarf 					= _dwarf

			addChild				(dwarf);
			dwarf.gotoAndStop		("stand_right");
			setInnerHitBox();
			
			class_name 				= null;
			definition 				= null;
			_dwarf					= null;
		}
		
		/**
		 * 
		 * Initializes the states basic states for the player.  Can be running, respawning or dying
		 * 
		 * @return void
		 */
		protected function initializeStates():void
		{
			_isAliveState 		= new IsAlive		(this);
			_isRespawningState  = new IsRespawning	(this);
			_isDyingState 		= new IsDying		(this);
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
			dwarf.hitArea.alpha 				= 0;
			dwarf.addChild						(dwarf.hitArea);
		}
		
		
		
	}
}