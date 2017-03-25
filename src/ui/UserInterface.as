package ui
{
	//------------------------------------------------------------------------------
	//
	// Imports
	//
	//------------------------------------------------------------------------------
	import flash.display.MovieClip;
	import ui.Score;
	
	import se.lnu.mediatechnology.stickossdk.core.Session;
	import se.lnu.mediatechnology.stickossdk.display.IStickOsDisplayObject;
	
	//------------------------------------------------------------------------------
	//
	// Public class
	//
	//------------------------------------------------------------------------------
	
	/**
	 *
	 *	This class is a container for the players user interface.  One or two player
	 * 	class's are iniated here to handle the scores and colors for each player.  In 
	 * 	this way this class can be passed to both multiplayer or singleplayer for interface
	 * 	handling.  playerOne:Score functions both for single player and for multiplayer
	 * 	Where as playerTwo:Score is primarily meant for multiplayer.  
	 * 	 
	 * 
	 *	@author		Chris Shields
	 *	@version 	1.0
	 *
	 */
	public class UserInterface extends MovieClip implements IStickOsDisplayObject
	{
		//------------------------------------------------------------------------------
		//
		// Private properties
		//
		//------------------------------------------------------------------------------
		private var _uiBar		:MovieClip;
		//------------------------------------------------------------------------------
		//
		// Public properties
		//
		//------------------------------------------------------------------------------
		public var playerOne	:Score;
		public var playerTwo	:Score;
		public var background	:String	= "mountain";
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
		public function UserInterface()
		{
			super();
		}
	
		//------------------------------------------------------------------------------
		//
		// Public methods
		//
		//------------------------------------------------------------------------------
		
		/**
		 * 
		 *	Acts as a second constructor called through the IStickOSDisplayObject 
		 * 	Interface. 
		 * 
		 *	@return void
		 * 
		 */
		public function init():void
		{
			_uiBar = new mc_ui();	
		}
		
		/**
		 * 
		 *	Runs automatically every frame.  
		 * 
		 *	@return void
		 * 
		 */
		public function update():void{}
		
		/**
		 * 
		 *	Cleans the class
		 * 
		 *	@return void
		 * 
		 */
		public function dealloc():void
		{
			trace("dealloc from UserInterface");
			playerOne.dealloc();
			if(playerTwo) {playerTwo.dealloc();}
			removeChild(_uiBar);
			_uiBar		= null;
			playerOne 	= null;
			playerTwo 	= null;
		}
		
		/**
		 * 
		 *	Sets the uiBar to the right frame.
		 * 
		 *	@return void
		 * 
		 */
		public function set uIBar($gameMode:String):void
		{
			_uiBar.gotoAndStop	($gameMode);
			addChild			(_uiBar);
		}
		
		/**
		 * 
		 *	Calls and instatiates player ones user interface.  
		 * 
		 * 	@param $playerNum:int	Number representing player one. 
		 * 
		 *	@return void
		 * 
		 */
		public function PlayerOne($playerNum:int):void
		{
			playerOne = new Score($playerNum, _uiBar);
		}
		
		/**
		 * 
		 *	Calls and instatiates player twos user interface.  
		 * 
		 * 	@param $playerNum:int	Number representing player two.
		 * 
		 *	@return void
		 * 
		 */
		public function PlayerTwo($playerNum:int):void
		{
			playerTwo = new Score($playerNum, _uiBar);
		}
		
	}
}